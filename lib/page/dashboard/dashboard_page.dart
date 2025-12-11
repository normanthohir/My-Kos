import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/page/kamar/kamar_page.dart';
import 'package:may_kos/page/penghuni/penghuni_page.dart';
import 'package:may_kos/page/penghuni/penghuni_page1.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorsApp.background,
      appBar: AppBar(
        backgroundColor: colorsApp.background,
        title: const Text(
          "Dashboard Kos",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 23,
          ),
        ),
        foregroundColor: Colors.blue[800],
        elevation: 1,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ringkasan Bulan Ini",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // ===== CARD RINGKASAN =====
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                children: [
                  _buildSummaryCard(
                    color: Colors.blue,
                    icon: Iconsax.profile_2user,
                    title: "Penghuni Aktif",
                    value: "0",
                  ),
                  _buildSummaryCard(
                    color: Colors.green,
                    icon: Iconsax.wallet_check,
                    title: "Sudah Bayar",
                    value: "0",
                  ),
                  _buildSummaryCard(
                    color: Colors.redAccent,
                    icon: Iconsax.warning_2,
                    title: "Belum Bayar",
                    value: "0",
                  ),
                  _buildSummaryCard(
                    color: Colors.orange,
                    icon: Iconsax.home,
                    title: "Kamar Kosong",
                    value: "0",
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Menu Utama",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // ===== MENU BUTTON =====
              Column(
                children: [
                  _buildMenuButton(
                    icon: Iconsax.home_2,
                    title: "Data Kamar",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KamarPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuButton(
                    icon: Iconsax.profile_circle,
                    title: "Data Penghuni",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PenghuniPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuButton(
                    icon: Iconsax.money_tick,
                    title: "Pembayaran Bulanan",
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildMenuButton(
                    icon: Iconsax.document_text,
                    title: "Riwayat Pembayaran",
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =================== Widget Card Ringkasan ===================
  Widget _buildSummaryCard({
    required Color color,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
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

  // =================== Widget Menu ===================
  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.blueAccent),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Iconsax.arrow_right_1),
          ],
        ),
      ),
    );
  }
}
