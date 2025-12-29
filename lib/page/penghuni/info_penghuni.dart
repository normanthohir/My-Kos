import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:may_kos/config/theme.dart';

class DetailPenghuniDialog extends StatelessWidget {
  final Map<String, dynamic> penghuniData;

  const DetailPenghuniDialog({
    super.key,
    required this.penghuniData,
  });

  @override
  Widget build(BuildContext context) {
    final isAktif = penghuniData['tanggalKeluar']?.isEmpty ?? true;
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 40,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header dengan gradient
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorsApp.primary,
                    colorsApp.primary.withOpacity(0.8),
                    // colorScheme.scrim,
                    // colorScheme.scrim.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Avatar dan Nama
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            getInitials(penghuniData['nama'] ?? ''),
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: colorsApp.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Nama dan Status
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              penghuniData['nama'] ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isAktif
                                    ? colorsApp.success
                                    : colorsApp.error,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isAktif ? Colors.green : Colors.red,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                isAktif ? 'AKTIF' : 'TIDAK AKTIF',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tombol Close
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Body - Detail Informasi
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildInfoRow(
                    icon: Icons.phone_rounded,
                    title: 'Nomor Telepon',
                    value: penghuniData['nomorTelepon'] ?? '-',
                    context: context,
                  ),
                  const SizedBox(height: 16),

                  _buildInfoRow(
                    icon: Icons.meeting_room_rounded,
                    title: 'Nomor Kamar',
                    value: penghuniData['kamar'] ?? '-',
                    context: context,
                    valueColor: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorsApp.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.monetization_on_rounded,
                          size: 18,
                          color: colorsApp.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Harga Sewa perbulan',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              NumberFormat.currency(
                                locale: 'id',
                                symbol: 'Rp ',
                                decimalDigits:
                                    0, // Set ke 0 agar tidak ada ,00 di belakang
                              ).format(
                                  int.parse(penghuniData['harga'].toString())),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildInfoRow(
                    icon: Icons.calendar_today_rounded,
                    title: 'Tanggal Masuk',
                    value: formatDate(penghuniData['tanggalMasuk'] ?? '-'),
                    context: context,
                  ),

                  if (!isAktif) ...[
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      icon: Icons.logout_rounded,
                      title: 'Tanggal Keluar',
                      value: formatDate(penghuniData['tanggalKeluar'] ?? '-'),
                      context: context,
                      valueColor: Colors.red,
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Divider
                  Divider(
                    color: Colors.grey[300],
                    height: 1,
                  ),

                  const SizedBox(height: 24),

                  // Info Tambahan
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[200]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.blue[600],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Penghuni telah menempati kamar ini selama ${calculateDuration(penghuniData['tanggalMasuk'])}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tombol Aksi
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                      child: Text(
                        'Tutup',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Tutup detail
                        // Tambahkan logika untuk edit di sini
                        // Misalnya: showPenghuniModal(context, penghuniData, true);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: colorsApp.primary,
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.edit_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required BuildContext context,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorsApp.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: colorsApp.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getInitials(String name) {
    if (name.isEmpty) return '?';
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String formatDate(String date) {
    if (date.isEmpty || date == '-') return '-';

    // Format dari "12 03 2024" menjadi "12 Maret 2024"
    final parts = date.split(' ');
    if (parts.length == 3) {
      final day = parts[0];
      final month = parts[1];
      final year = parts[2];

      final monthNames = [
        '',
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];

      try {
        final monthIndex = int.parse(month);
        if (monthIndex >= 1 && monthIndex <= 12) {
          return '$day ${monthNames[monthIndex]} $year';
        }
      } catch (e) {
        return date;
      }
    }
    return date;
  }

  String calculateDuration(String startDate) {
    if (startDate.isEmpty) return '-';

    try {
      final parts = startDate.split(' ');
      if (parts.length == 3) {
        final start = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
        final now = DateTime.now();
        final difference = now.difference(start);

        final months = (difference.inDays / 30).floor();
        final days = difference.inDays % 30;

        if (months > 0) {
          return '$months bulan ${days > 0 ? '$days hari' : ''}';
        } else {
          return '${difference.inDays} hari';
        }
      }
    } catch (e) {
      return '-';
    }
    return '-';
  }
}
