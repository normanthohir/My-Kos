// lib/utils/string_utils.dart

class StringUtils {
  static String getInitials(String name) {
    if (name.trim().isEmpty) return '?';

    final names = name.trim().split(' ');
    if (names.length >= 2) {
      // Mengambil huruf pertama dari kata pertama dan kata kedua
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    // Jika hanya satu kata, ambil huruf pertama saja
    return names[0][0].toUpperCase();
  }
}
