import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/widgets/widgetApbarConten.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorsApp.background,
      body: Column(
        children: [
          Widgetapbarconten(
            title: 'Laporan',
            rightIcon: Iconsax.add,
          ),
        ],
      ),
    );
  }
}
