import 'package:flutter/material.dart';
import 'package:may_kos/page/laporan/model_report.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({Key? key}) : super(key: key);

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String selectedPeriod = 'Bulan Ini';
  String selectedChartType = 'Penghasilan';

  final List<String> periods = [
    'Hari Ini',
    'Minggu Ini',
    'Bulan Ini',
    'Tahun Ini',
    'Kustom'
  ];
  final List<String> chartTypes = ['Penghasilan', 'Okupansi', 'Penghuni'];

  // Data dummy untuk laporan
  final ReportData reportData = ReportData(
    period: 'April 2024',
    totalRooms: 15,
    occupiedRooms: 10,
    availableRooms: 5,
    activeResidents: 12,
    checkoutResidents: 3,
    totalIncome: 18750000,
    averageOccupancy: 75.5,
    monthlyData: [
      MonthlyData(month: 'Jan', income: 16500000, occupancy: 65),
      MonthlyData(month: 'Feb', income: 17500000, occupancy: 70),
      MonthlyData(month: 'Mar', income: 18200000, occupancy: 73),
      MonthlyData(month: 'Apr', income: 18750000, occupancy: 75),
    ],
    topRooms: [
      TopRoom(
          roomNumber: '101',
          roomType: 'Standard',
          income: 3250000,
          occupancyDays: 30),
      TopRoom(
          roomNumber: '205',
          roomType: 'Suite',
          income: 3000000,
          occupancyDays: 28),
      TopRoom(
          roomNumber: '102',
          roomType: 'Deluxe',
          income: 2800000,
          occupancyDays: 30),
      TopRoom(
          roomNumber: '103',
          roomType: 'Suite',
          income: 2750000,
          occupancyDays: 27),
    ],
    recentActivities: [
      RecentActivity(
        activity: 'Check-in Baru',
        description: 'Budi Santoso - Kamar 101',
        time: '2 jam lalu',
        icon: Icons.person_add,
        color: Colors.green,
      ),
      RecentActivity(
        activity: 'Pembayaran',
        description: 'Siti Aminah - Rp 1.500.000',
        time: '5 jam lalu',
        icon: Icons.payment,
        color: Colors.blue,
      ),
      RecentActivity(
        activity: 'Check-out',
        description: 'Ahmad Fauzi - Kamar 104',
        time: '1 hari lalu',
        icon: Icons.logout,
        color: Colors.orange,
      ),
      RecentActivity(
        activity: 'Maintenance',
        description: 'Perbaikan AC Kamar 203',
        time: '2 hari lalu',
        icon: Icons.build,
        color: Colors.purple,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // AppBar dengan gradient
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Laporan & Analitik',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue[800]!,
                      Colors.purple[700]!,
                    ],
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Ringkasan ${reportData.period}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rp ${_formatCurrency(reportData.totalIncome)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Pendapatan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              // Tombol export
              IconButton(
                onPressed: _exportReport,
                icon: const Icon(Icons.download, color: Colors.white),
                tooltip: 'Export Laporan',
              ),
              // Tombol filter
              IconButton(
                onPressed: _showFilterDialog,
                icon: const Icon(Icons.filter_list, color: Colors.white),
                tooltip: 'Filter',
              ),
            ],
          ),

          // Konten utama
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Statistik utama
                  _buildMainStats(),
                  const SizedBox(height: 24),

                  // Grafik tren
                  _buildTrendChart(),
                  const SizedBox(height: 24),

                  // Kamar terpopuler
                  _buildTopRooms(),
                  const SizedBox(height: 24),

                  // Aktivitas terkini
                  _buildRecentActivities(),
                  const SizedBox(height: 24),

                  // Laporan detail
                  _buildDetailedReport(),
                ],
              ),
            ),
          ),
        ],
      ),

      // Floating Action Button untuk refresh
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  // Widget untuk statistik utama
  Widget _buildMainStats() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        // Total Kamar
        _buildStatCard(
          'Total Kamar',
          '${reportData.totalRooms}',
          Icons.hotel,
          Colors.blue,
          Colors.blue[50]!,
          '${reportData.occupiedRooms} Terisi • ${reportData.availableRooms} Kosong',
        ),

        // Penghasilan
        _buildStatCard(
          'Penghasilan',
          'Rp ${_formatCurrency(reportData.totalIncome)}',
          Icons.attach_money,
          Colors.green,
          Colors.green[50]!,
          '${reportData.averageOccupancy.toStringAsFixed(1)}% Okupansi',
        ),

        // Penghuni Aktif
        _buildStatCard(
          'Penghuni Aktif',
          '${reportData.activeResidents}',
          Icons.people,
          Colors.purple,
          Colors.purple[50]!,
          '${reportData.checkoutResidents} Check-out',
        ),

        // Okupansi
        _buildStatCard(
          'Tingkat Okupansi',
          '${reportData.averageOccupancy.toStringAsFixed(1)}%',
          Icons.trending_up,
          Colors.orange,
          Colors.orange[50]!,
          'Rata-rata bulan ini',
        ),
      ],
    );
  }

  // Widget untuk stat card
  Widget _buildStatCard(String title, String value, IconData icon,
      Color iconColor, Color cardColor, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              Icon(
                Icons.more_vert,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk grafik tren
  Widget _buildTrendChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header grafik
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tren Penghasilan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timeline, size: 16, color: Colors.blue[800]),
                    const SizedBox(width: 6),
                    Text(
                      selectedChartType,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Grafik sederhana (bar chart custom)
          Container(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: reportData.monthlyData.map((data) {
                double maxIncome = reportData.monthlyData
                    .map((d) => d.income)
                    .reduce((a, b) => a > b ? a : b);
                double barHeight = (data.income / maxIncome) * 150;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Bar
                    Container(
                      width: 30,
                      height: barHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue[800]!,
                            Colors.blue[400]!,
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Label bulan
                    Text(
                      data.month,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Nilai
                    Text(
                      '${(data.income / 1000000).toStringAsFixed(1)}JT',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Persentase okupansi
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${data.occupancy}%',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Legenda
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.blue[800]!, 'Penghasilan'),
              const SizedBox(width: 16),
              _buildLegendItem(Colors.green, 'Okupansi'),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk legend item
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Widget untuk kamar terpopuler
  Widget _buildTopRooms() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kamar Terpopuler',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Top ${reportData.topRooms.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: reportData.topRooms.asMap().entries.map((entry) {
              int index = entry.key;
              TopRoom room = entry.value;

              return Container(
                margin: EdgeInsets.only(
                    bottom: index == reportData.topRooms.length - 1 ? 0 : 12),
                child: Row(
                  children: [
                    // Ranking
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color:
                            index == 0 ? Colors.amber[100] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: index == 0
                                ? Colors.amber[800]
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Info kamar
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kamar ${room.roomNumber}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            room.roomType,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Statistik
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rp ${_formatCurrency(room.income)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${room.occupancyDays} hari',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 8),

                    // Icon
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Widget untuk aktivitas terkini
  Widget _buildRecentActivities() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aktivitas Terkini',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: reportData.recentActivities.map((activity) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    // Icon dengan background
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: activity.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        activity.icon,
                        color: activity.color,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Detail aktivitas
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.activity,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Waktu
                    Text(
                      activity.time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Widget untuk laporan detail
  Widget _buildDetailedReport() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Laporan Detail',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          // Statistik detail
          _buildDetailRow(
              'Total Kamar Tersedia', '${reportData.totalRooms} kamar'),
          _buildDetailRow('Kamar Terisi',
              '${reportData.occupiedRooms} kamar (${(reportData.occupiedRooms / reportData.totalRooms * 100).toStringAsFixed(1)}%)'),
          _buildDetailRow('Kamar Kosong',
              '${reportData.availableRooms} kamar (${(reportData.availableRooms / reportData.totalRooms * 100).toStringAsFixed(1)}%)'),
          _buildDetailRow(
              'Penghuni Aktif', '${reportData.activeResidents} orang'),
          _buildDetailRow(
              'Check-out Bulan Ini', '${reportData.checkoutResidents} orang'),
          _buildDetailRow('Rata-rata Okupansi',
              '${reportData.averageOccupancy.toStringAsFixed(1)}%'),
          _buildDetailRow('Penghasilan Rata-rata/Kamar',
              'Rp ${_formatCurrency(reportData.totalIncome / reportData.occupiedRooms)}'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Format currency
  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}JT';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}RB';
    }
    return amount.toStringAsFixed(0);
  }

  // Fungsi untuk export laporan
  void _exportReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Laporan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih format export:'),
            const SizedBox(height: 16),
            _buildExportOption(Icons.picture_as_pdf, 'PDF', Colors.red),
            const SizedBox(height: 12),
            _buildExportOption(Icons.insert_drive_file, 'Excel', Colors.green),
            const SizedBox(height: 12),
            _buildExportOption(Icons.image, 'Gambar', Colors.blue),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Laporan berhasil diexport'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption(IconData icon, String label, Color color) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export $label berhasil'),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }

  // Dialog filter
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Filter Laporan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pilih periode
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Periode Waktu',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: periods.map((period) {
                    bool isSelected = selectedPeriod == period;
                    return ChoiceChip(
                      label: Text(period),
                      selected: isSelected,
                      selectedColor: Colors.blue[800],
                      onSelected: (selected) {
                        setState(() {
                          selectedPeriod = period;
                        });
                      },
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Pilih tipe chart
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tampilkan Data',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: chartTypes.map((type) {
                    bool isSelected = selectedChartType == type;
                    return ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      selectedColor: Colors.blue[800],
                      onSelected: (selected) {
                        setState(() {
                          selectedChartType = type;
                        });
                      },
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Reset'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyFilter();
                },
                child: const Text('Terapkan'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _applyFilter() {
    // Aplikasi filter di sini
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filter diterapkan: $selectedPeriod'),
        backgroundColor: Colors.blue[800],
      ),
    );
  }

  void _refreshData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Memperbarui data...'),
        backgroundColor: Colors.blue,
      ),
    );

    // Simulasi loading
    Future.delayed(const Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}
