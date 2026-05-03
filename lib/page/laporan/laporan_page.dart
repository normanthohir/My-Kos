import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/data/databases/database_helper.dart';
import 'package:may_kos/data/models/kamar.dart';
import 'package:may_kos/data/models/pembayaran.dart';
import 'package:may_kos/data/models/penghuni.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  bool _isLoading = true;
  int _totalRooms = 0;
  int _occupiedRooms = 0;
  int _availableRooms = 0;
  int _activeResidents = 0;
  int _checkoutResidents = 0;
  int _paidResidents = 0;
  int _unpaidResidents = 0;
  double _totalIncome = 0;
  double _averageOccupancy = 0;
  List<_MonthlyTrend> _monthlyTrend = [];
  List<_TopRoom> _topRooms = [];
  List<_RecentActivity> _recentActivities = [];

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    try {
      final helper = DatabaseHelper();
      final allRooms = await helper.getAllKamar();
      final occupiedRooms = await helper.getKamarTerisi();
      final availableRooms = await helper.getKamarTersedia();
      final allPenghuni = await helper.getAllPenghuni();
      final paidThisMonth = await helper.getPenghuniSudahBayarBulanIni();
      final unpaidThisMonth = await helper.getTagihanJatuhTempo();
      final allPayments = await helper.getAllPembayaran();

      final now = DateTime.now();
      final currentMonth = now.month.toString().padLeft(2, '0');
      final currentYear = now.year.toString();

      final currentPayments = allPayments.where((payment) {
        try {
          final date = DateTime.parse(payment.periodePembayaran);
          return date.month.toString().padLeft(2, '0') == currentMonth &&
              date.year.toString() == currentYear;
        } catch (_) {
          return false;
        }
      }).toList();

      final totalIncome = currentPayments.fold<double>(0, (sum, item) {
        return sum + item.jumlahPembayaran;
      });

      final monthlyTrend = _buildMonthlyTrend(allPayments);
      final topRooms = _buildTopRooms(allRooms, allPayments);
      final recentActivities =
          _buildRecentActivities(currentPayments, unpaidThisMonth);

      if (!mounted) return;
      setState(() {
        _totalRooms = allRooms.length;
        _occupiedRooms = occupiedRooms.length;
        _availableRooms = availableRooms.length;
        _activeResidents =
            allPenghuni.where((item) => item.statusPenghuni).length;
        _checkoutResidents = allPenghuni.length - _activeResidents;
        _paidResidents = paidThisMonth.length;
        _unpaidResidents = unpaidThisMonth.length;
        _totalIncome = totalIncome;
        _averageOccupancy =
            _totalRooms == 0 ? 0 : (_occupiedRooms / _totalRooms) * 100;
        _monthlyTrend = monthlyTrend;
        _topRooms = topRooms;
        _recentActivities = recentActivities;
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      debugPrint('LaporanPage load error: $error');
      debugPrint('$stackTrace');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<_MonthlyTrend> _buildMonthlyTrend(List<Pembayaran> payments) {
    final now = DateTime.now();
    final List<_MonthlyTrend> trend = [];

    for (int offset = 3; offset >= 0; offset--) {
      final month = DateTime(now.year, now.month - offset);
      final monthLabel = DateFormat('MMM', 'id').format(month);
      final income = payments.fold<double>(0, (sum, payment) {
        try {
          final date = DateTime.parse(payment.periodePembayaran);
          if (date.month == month.month && date.year == month.year) {
            return sum + payment.jumlahPembayaran;
          }
        } catch (_) {}
        return sum;
      });
      final occupancy = _calculateMonthOccupancy(payments, month);
      trend.add(_MonthlyTrend(monthLabel, income, occupancy));
    }

    return trend;
  }

  double _calculateMonthOccupancy(List<Pembayaran> payments, DateTime month) {
    if (_totalRooms == 0) return 0;
    final paidThisMonth = payments.where((payment) {
      try {
        final date = DateTime.parse(payment.periodePembayaran);
        return date.month == month.month && date.year == month.year;
      } catch (_) {
        return false;
      }
    }).length;
    return (_totalRooms == 0) ? 0 : (paidThisMonth / _totalRooms) * 100;
  }

  List<_TopRoom> _buildTopRooms(List<Kamar> rooms, List<Pembayaran> payments) {
    final Map<int, double> incomeByRoom = {};
    final Map<int, int> paymentCountByRoom = {};

    for (final payment in payments) {
      final roomId = payment.kamarId;
      if (roomId == null) continue;
      incomeByRoom[roomId] =
          (incomeByRoom[roomId] ?? 0) + payment.jumlahPembayaran;
      paymentCountByRoom[roomId] = (paymentCountByRoom[roomId] ?? 0) + 1;
    }

    final topRooms = rooms.map((room) {
      return _TopRoom(
        roomNumber: room.nomorKamar,
        income: incomeByRoom[room.id] ?? 0,
        payments: paymentCountByRoom[room.id] ?? 0,
      );
    }).toList();

    topRooms.sort((a, b) => b.income.compareTo(a.income));
    return topRooms.take(4).toList();
  }

  List<_RecentActivity> _buildRecentActivities(
    List<Pembayaran> currentPayments,
    List<Map<String, dynamic>> unpaidThisMonth,
  ) {
    final activities = <_RecentActivity>[];

    for (final payment in currentPayments.take(3)) {
      activities.add(_RecentActivity(
        title: 'Pembayaran Diterima',
        subtitle:
            '${payment.namaPenghuniPembayaran} - Rp ${NumberFormat.decimalPattern('id').format(payment.jumlahPembayaran)}',
        time: payment.tanggalPembayaran.isNotEmpty
            ? _formatRelativeTime(payment.tanggalPembayaran)
            : 'Baru saja',
        icon: Iconsax.wallet_check,
        color: colorsApp.primary,
      ));
    }

    if (unpaidThisMonth.isNotEmpty) {
      activities.add(_RecentActivity(
        title: 'Tunggakan Baru',
        subtitle: '${unpaidThisMonth.length} penghuni belum bayar bulan ini',
        time: 'Sekarang',
        icon: Iconsax.warning_2,
        color: colorsApp.warning,
      ));
    }

    if (activities.isEmpty) {
      activities.add(_RecentActivity(
        title: 'Tidak ada aktivitas baru',
        subtitle: 'Semua laporan sudah terupdate.',
        time: '',
        // icon: Iconsax.shield_done,
        icon: Iconsax.shield_tick,
        color: colorsApp.success,
      ));
    }

    return activities;
  }

  String _formatRelativeTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final difference = DateTime.now().difference(date);
      if (difference.inDays >= 1) {
        return '${difference.inDays} hari lalu';
      }
      if (difference.inHours >= 1) {
        return '${difference.inHours} jam lalu';
      }
      if (difference.inMinutes >= 1) {
        return '${difference.inMinutes} menit lalu';
      }
    } catch (_) {}
    return 'Baru saja';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorsApp.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 240,
                  pinned: true,
                  backgroundColor: colorsApp.primary,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Iconsax.arrow_left_1, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    title: Text(
                      'Laporan & Analitik',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: colorsApp.primaryGradient,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 80, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ringkasan Bulan Ini',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Pendapatan: Rp ${NumberFormat.decimalPattern('id').format(_totalIncome)}',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${_paidResidents} sudah bayar • ${_unpaidResidents} belum bayar',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Iconsax.document_download,
                          color: Colors.white),
                      tooltip: 'Export Laporan',
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Iconsax.filter5, color: Colors.white),
                      tooltip: 'Filter',
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Statistik Utama',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: colorsApp.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.08,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            _buildInfoCard(
                              title: 'Total Kamar',
                              value: '$_totalRooms',
                              icon: Iconsax.home,
                              color: colorsApp.primary,
                              subtitle: '$_availableRooms tersedia',
                            ),
                            _buildInfoCard(
                              title: 'Pendapatan',
                              value:
                                  'Rp ${NumberFormat.decimalPattern('id').format(_totalIncome)}',
                              icon: Iconsax.money,
                              color: colorsApp.success,
                              subtitle:
                                  '${_averageOccupancy.toStringAsFixed(1)}% okupansi',
                            ),
                            _buildInfoCard(
                              title: 'Penghuni Aktif',
                              value: '$_activeResidents',
                              icon: Iconsax.user5,
                              color: colorsApp.info,
                              subtitle: '$_checkoutResidents check-out',
                            ),
                            _buildInfoCard(
                              title: 'Sudah Bayar',
                              value: '$_paidResidents',
                              icon: Iconsax.wallet_check,
                              color: colorsApp.secondary,
                              subtitle: '$_unpaidResidents belum bayar',
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        _buildTrendSection(),
                        const SizedBox(height: 28),
                        _buildTopRoomsSection(),
                        const SizedBox(height: 28),
                        _buildRecentActivitySection(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorsApp.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: colorsApp.cardShadow,
        border: Border.all(color: colorsApp.border.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Spacer(),
              Icon(Iconsax.more, color: colorsApp.textHint, size: 18),
            ],
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: colorsApp.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: colorsApp.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: colorsApp.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorsApp.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: colorsApp.cardShadow,
        border: Border.all(color: colorsApp.border.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Tren Pendapatan',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorsApp.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colorsApp.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'Bulan Ini',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorsApp.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _monthlyTrend.map((item) {
                final maxIncome = _monthlyTrend
                    .map((m) => m.income)
                    .fold<double>(0.0,
                        (prev, current) => current > prev ? current : prev);
                final double barHeight =
                    maxIncome == 0.0 ? 0.0 : (item.income / maxIncome) * 120.0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: barHeight < 24 ? 24 : barHeight,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorsApp.primary,
                                colorsApp.primaryLight
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.label,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: colorsApp.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Bulan Ini',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: colorsApp.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Rata-rata ${_averageOccupancy.toStringAsFixed(1)}% okupansi',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: colorsApp.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopRoomsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Kamar',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colorsApp.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: _topRooms.map((room) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: colorsApp.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: colorsApp.subtleShadow,
                  border: Border.all(color: colorsApp.border.withOpacity(0.5)),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: colorsApp.secondaryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          room.roomNumber,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kamar ${room.roomNumber}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: colorsApp.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${NumberFormat.decimalPattern('id').format(room.income)} pemasukan',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorsApp.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${room.payments}x',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colorsApp.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aktivitas Terbaru',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colorsApp.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: _recentActivities.map((activity) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: colorsApp.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: colorsApp.subtleShadow,
                  border: Border.all(color: colorsApp.border.withOpacity(0.5)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: activity.color.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child:
                          Icon(activity.icon, color: activity.color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: colorsApp.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity.subtitle,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorsApp.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      activity.time,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: colorsApp.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _MonthlyTrend {
  final String label;
  final double income;
  final double occupancy;

  _MonthlyTrend(this.label, this.income, this.occupancy);
}

class _TopRoom {
  final String roomNumber;
  final double income;
  final int payments;

  _TopRoom({
    required this.roomNumber,
    required this.income,
    required this.payments,
  });
}

class _RecentActivity {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  _RecentActivity({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });
}
