import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:may_kos/config/theme.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildEmptyState();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorsApp.background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.receipt_search,
              size: 50,
              color: colorsApp.textTertiary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tidak Ada Data ',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colorsApp.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Tidak ada data yang dapat di tampilkan ',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: colorsApp.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
