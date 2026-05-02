import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:may_kos/config/theme.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  static const String routeName = '/maintenance';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorsApp.primaryExtraLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: colorsApp.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Maintenance Mode',
                  style: GoogleFonts.poppins(
                    color: colorsApp.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildHeroCard(),
              const SizedBox(height: 24),
              _buildFeatureCard(
                icon: Iconsax.clock,
                title: 'Perbaikan Sistem',
                subtitle:
                    'Fitur sedang dalam perbaikan untuk pengalaman yang lebih baik.',
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                icon: Iconsax.cloud_remove,
                title: 'Akses Terbatas',
                subtitle:
                    'Beberapa halaman dunia maya dialihkan di sini sementara waktu.',
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                icon: Iconsax.check,
                title: 'Sistem Stabil',
                subtitle:
                    'Kami sedang memastikan keamanan dan kestabilan untuk Anda.',
              ),
              const SizedBox(height: 30),
              _buildSupportSection(),
              const SizedBox(height: 30),
              Center(child: _buildActionButton(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: colorsApp.accentGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: colorsApp.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.18),
            ),
            child: const Icon(
              Iconsax.building_4,
              color: Colors.white,
              size: 38,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Halaman sedang diperbaiki',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Terima kasih atas kesabarannya. Fitur ini akan kembali tersedia segera dengan pengalaman yang lebih baik.',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.92),
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              _buildStatusBadge('Sedang diperbaiki', Colors.white),
              const SizedBox(width: 10),
              _buildStatusBadge('Rilis segera', Colors.white54),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorsApp.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: colorsApp.subtleShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorsApp.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: colorsApp.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
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
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: colorsApp.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorsApp.secondaryExtraLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorsApp.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Iconsax.message_question,
              color: colorsApp.secondary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Butuh bantuan?',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorsApp.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Silakan kembali ke dashboard atau hubungi admin jika diperlukan.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: colorsApp.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: colorsApp.primary,
        padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        shadowColor: colorsApp.primary.withOpacity(0.25),
        elevation: 8,
      ),
      child: Text(
        'Kembali ke Beranda',
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
