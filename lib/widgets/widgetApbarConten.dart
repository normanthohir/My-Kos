import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:may_kos/config/theme.dart';

class Widgetapbarconten extends StatelessWidget {
  const Widgetapbarconten({
    super.key,
    required this.title,
    this.rightIcon,
    this.onRightIconTap,
    this.showBackButton = true,
    this.contain,
  });

  final String title;
  final IconData? rightIcon;
  final VoidCallback? onRightIconTap;
  final bool showBackButton;
  final Widget? contain;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 50,
        left: 20,
        right: 20,
        bottom: 20,
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
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // AppBar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showBackButton)
                IconButton(
                  icon: const Icon(Iconsax.arrow_left_1, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                )
              else
                const SizedBox(),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              rightIcon != null
                  ? IconButton(
                      icon: Icon(rightIcon, color: Colors.white),
                      onPressed: onRightIconTap)
                  : const SizedBox(width: 48),
            ],
          ),
          SizedBox(height: 15),
          contain ?? const SizedBox(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
