import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    // Ambil angka saja
    String onlyDigits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    double value = double.parse(onlyDigits);

    // Format dengan titik sebagai pemisah ribuan, tanpa simbol mata uang
    final formatter = NumberFormat.decimalPattern('id');
    String newText = formatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
