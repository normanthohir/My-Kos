class DurationUtil {
  static String calculateDuration(DateTime? startDate) {
    if (startDate == null) return '-';

    final now = DateTime.now();

    // Jika tanggal masuk di masa depan (error input)
    if (startDate.isAfter(now)) return 'Baru masuk hari ini';

    final difference = now.difference(startDate);
    final totalDays = difference.inDays;

    // Hitung perkiraan bulan (rata-rata 30.44 hari per bulan untuk akurasi lebih baik)
    final months = (totalDays / 30.44).floor();
    final remainingDays = (totalDays % 30.44).round();

    if (months > 0) {
      String result = '$months bulan';
      if (remainingDays > 0) {
        result += ' $remainingDays hari';
      }
      return result;
    } else {
      // Jika belum satu bulan, tampilkan hari saja
      return totalDays == 0 ? 'Hari pertama' : '$totalDays hari';
    }
  }
}
