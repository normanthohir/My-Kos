class AppFormatters {
  // Kita buat static agar bisa dipanggil tanpa perlu install class
  static String formatCurrency(num amount) {
    // Pakai num agar bisa menerima int maupun double
    // Kita bulatkan dulu ke int agar tidak ada .0
    int value = amount.toInt();

    return value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
