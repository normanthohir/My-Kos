import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerUtil {
  // Fungsi Date Picker biasa (yang sebelumnya)
  static Future<void> selectDate({
    required BuildContext context,
    required DateTime? initialDate,
    required TextEditingController controller,
    required Function(DateTime) onDateSelected,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      onDateSelected(picked);
    }
  }

  // --- FUNGSI BARU: KHUSUS BULAN & TAHUN ---
  static Future<void> selectMonthYear({
    required BuildContext context,
    required DateTime? initialDate,
    required TextEditingController controller,
    required Function(DateTime) onDateSelected,
  }) async {
    // Kita gunakan showDatePicker tapi dengan konfigurasi khusus
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      // Membantu agar user langsung melihat grid bulan (tergantung versi Flutter)
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'PILIH PERIODE',
    );

    if (picked != null) {
      // Format hanya Bulan dan Tahun (Contoh: Januari 2024)
      String formattedDate = DateFormat('MMMM yyyy').format(picked);

      controller.text = formattedDate;
      onDateSelected(picked);
    }
  }
}
