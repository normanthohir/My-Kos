import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SharedTextFormField extends StatelessWidget {
  final TextEditingController Controller;
  final String labelText;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool obsecureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final bool alignLabelWithHint;
  final int? maxLines;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;

  const SharedTextFormField(
      {super.key,
      required this.Controller,
      required this.labelText,
      this.readOnly = false,
      this.onTap,
      this.obsecureText = false,
      this.validator,
      this.suffixIcon,
      this.prefixIcon,
      this.keyboardType,
      this.alignLabelWithHint = false,
      this.maxLines = 1,
      this.autovalidateMode,
      this.inputFormatters});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      autovalidateMode: autovalidateMode,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(color: Colors.grey[800]),
      cursorColor: Colors.grey[800],
      obscureText: obsecureText,
      controller: Controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        floatingLabelStyle: GoogleFonts.poppins(color: Colors.grey[800]),
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[800]),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        alignLabelWithHint: alignLabelWithHint,
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Colors.grey[800]!.withOpacity(0.5), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Colors.grey[800]!.withOpacity(0.6), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.withOpacity(0.6), width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.withOpacity(0.6), width: 2),
        ),
        focusColor: Colors.green,
      ),
    );
  }
}
