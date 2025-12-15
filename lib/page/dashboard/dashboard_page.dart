import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:may_kos/config/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:may_kos/page/kamar/kamar_page.dart';
import 'package:may_kos/page/pembayaran/pembayaran_page.dart';
import 'package:may_kos/page/penghuni/penghuni_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorsApp.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan gradient
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorsApp.primary,
                        colorsApp.primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: colorsApp.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome message
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Datang!',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'May Kos Management',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Iconsax.home,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Info tanggal dan status
                      Row(
                        children: [
                          Icon(
                            Iconsax.calendar_1,
                            size: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getCurrentDate(),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Bulan Ini',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Statistik Cards Grid
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  children: [
                    _buildStatCard(
                      icon: Iconsax.profile_2user,
                      title: 'Penghuni Aktif',
                      value: '12',
                      trend: '+2',
                      color: colorsApp.success,
                      iconBg: colorsApp.success.withOpacity(0.1),
                    ),
                    _buildStatCard(
                      icon: Iconsax.wallet_check,
                      title: 'Sudah Bayar',
                      value: '10',
                      trend: '+3',
                      color: colorsApp.info,
                      iconBg: colorsApp.info.withOpacity(0.1),
                    ),
                    _buildStatCard(
                      icon: Iconsax.warning_2,
                      title: 'Belum Bayar',
                      value: '2',
                      trend: '-1',
                      color: colorsApp.warning,
                      iconBg: colorsApp.warning.withOpacity(0.1),
                    ),
                    _buildStatCard(
                      icon: Iconsax.home,
                      title: 'Kamar Kosong',
                      value: '5',
                      trend: '0',
                      color: colorsApp.secondary,
                      iconBg: colorsApp.secondary.withOpacity(0.1),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Section Header untuk Menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu Utama',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: colorsApp.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorsApp.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_getMenuItems(context).length} Menu',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: colorsApp.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Menu Grid dengan ikon yang lebih menarik
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.3,
                  ),
                  children: _getMenuItems(context).map((item) {
                    return _buildMenuCard(
                      icon: item['icon'],
                      title: item['title'],
                      subtitle: item['subtitle'],
                      color: item['color'],
                      onTap: item['onTap'],
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Quick Actions Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorsApp.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: colorsApp.cardShadow,
                    border: Border.all(
                      color: colorsApp.border.withOpacity(0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aksi Cepat',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colorsApp.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildQuickAction(
                            icon: Iconsax.add_circle,
                            label: 'Tambah\nPenghuni',
                            color: colorsApp.primary,
                            onTap: () {
                              // Navigate to add penghuni
                            },
                          ),
                          _buildQuickAction(
                            icon: Iconsax.receipt_item,
                            label: 'Input\nPembayaran',
                            color: colorsApp.success,
                            onTap: () {},
                          ),
                          _buildQuickAction(
                            icon: Iconsax.notification,
                            label: 'Pengingat\nTagihan',
                            color: colorsApp.warning,
                            onTap: () {},
                          ),
                          _buildQuickAction(
                            icon: Iconsax.document_download,
                            label: 'Laporan\nBulanan',
                            color: colorsApp.info,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Stat Card dengan desain modern
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String trend,
    required Color color,
    required Color iconBg,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorsApp.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: colorsApp.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      trend.startsWith('+')
                          ? Iconsax.arrow_up_2
                          : trend.startsWith('-')
                              ? Iconsax.arrow_down_2
                              : Iconsax.minus,
                      size: 12,
                      color: color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trend,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: colorsApp.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorsApp.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Menu Card dengan desain modern
  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: colorsApp.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: colorsApp.cardShadow,
          border: Border.all(
            color: colorsApp.border.withOpacity(0.3),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color,
                    color.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorsApp.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: colorsApp.textSecondary,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Spacer(),
                Icon(
                  Iconsax.arrow_right_3,
                  size: 18,
                  color: colorsApp.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Quick Action Button
  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required Function() onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withOpacity(0.2),
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colorsApp.textSecondary,
          ),
        ),
      ],
    );
  }

  // Helper function untuk mendapatkan tanggal sekarang
  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    final days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];

    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  // Daftar menu items
  List<Map<String, dynamic>> _getMenuItems(BuildContext context) {
    return [
      {
        'icon': Iconsax.home_2,
        'title': 'Data Kamar',
        'subtitle': 'Kelola kamar kos',
        'color': colorsApp.primary,
        'onTap': () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => KamarPage()));
        },
      },
      {
        'icon': Iconsax.profile_circle,
        'title': 'Data Penghuni',
        'subtitle': 'Kelola penghuni',
        'color': colorsApp.success,
        'onTap': () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PenghuniPage()));
        },
      },
      {
        'icon': Iconsax.money_tick,
        'title': 'Pembayaran',
        'subtitle': 'Input pembayaran',
        'color': colorsApp.warning,
        'onTap': () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PembayaranPage()));
        },
      },
      {
        'icon': Iconsax.document_text,
        'title': 'Riwayat',
        'subtitle': 'Lihat riwayat bayar',
        'color': colorsApp.info,
        'onTap': () {},
      },
      {
        'icon': Iconsax.chart_2,
        'title': 'Laporan',
        'subtitle': 'Analisis keuangan',
        'color': colorsApp.secondary,
        'onTap': () {},
      },
      {
        'icon': Iconsax.setting_2,
        'title': 'Pengaturan',
        'subtitle': 'Atur aplikasi',
        'color': colorsApp.textSecondary,
        'onTap': () {},
      },
    ];
  }
}
