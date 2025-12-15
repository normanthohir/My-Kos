import 'package:flutter/material.dart';
import 'package:may_kos/widgets/widget_appBar.dart';

class PembayaranPage extends StatelessWidget {
  const PembayaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppbar(
        title: 'Pembayaran',
      ),
    );
  }
}
