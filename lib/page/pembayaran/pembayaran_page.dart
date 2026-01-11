import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/data/databases/database_helper.dart';
import 'package:may_kos/page/empty_page/empty_page.dart';
import 'package:may_kos/page/pembayaran/pembayran_form.dart';
import 'package:may_kos/utils/getInitials.dart';
import 'package:may_kos/widgets/widget_Search.dart';

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({super.key});

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  List<Map<String, dynamic>> _tagihanList = [];
  bool _isLoading = true;

  void _refreshTagihan() async {
    setState(() => _isLoading = true);
    // Sekarang memanggil semua tunggakan tanpa terbatas 1 bulan saja
    final data = await DatabaseHelper().getAllTunggakan();

    setState(() {
      _tagihanList = data;
      _isLoading = false;
    });
  }

  double get _totalTagihan {
    return _tagihanList.fold(0, (sum, item) {
      return sum + (item['jumlah'] ?? 0).toDouble();
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTagihan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorsApp.background,
      body: Column(
        children: [
          // Header dengan gradient
          Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Iconsax.arrow_left_1, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Pembayaran',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.document_upload,
                          color: Colors.white),
                      onPressed: () {
                        ForminputpembayarabDialog();
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Info Ringkasan
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Tagihan',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          Text(
                            NumberFormat.decimalPattern('id')
                                .format(_totalTagihan),
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.danger,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${_tagihanList.length} Belum Bayar',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filter dan Search
          WidgetSearch(
              title: 'Cari penghuni & kamar...', onChanged: (value) {}),

          // List Tagihan
          Expanded(
            child: _isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Tampilkan loading saat proses
                : RefreshIndicator(
                    onRefresh: () async => _refreshTagihan(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _tagihanList.isEmpty
                          ? const EmptyPage()
                          : ListView.separated(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              itemCount: _tagihanList.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                // Data 'tagihan' di sini adalah hasil Map dari rawQuery database
                                final tagihan = _tagihanList[index];
                                return _buildTagihanCard(tagihan);
                              },
                            ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagihanCard(Map<String, dynamic> tagihan) {
    // Ambil tanggal masuk untuk menentukan tanggal jatuh tempo
    final tglMasuk = DateTime.parse(tagihan['tanggal_masuk']);
    // final hariJatuhTempo = tglMasuk.day;

    final String? bulan = tagihan['bulan'];
    final String? tahun = tagihan['tahun'];

    DateTime? datePeriode;
    datePeriode = DateTime(int.parse(tahun!), int.parse(bulan!));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan avatar dan status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorsApp.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    StringUtils.getInitials(tagihan['nama'] ?? ''),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colorsApp.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tagihan['nama'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorsApp.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorsApp.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Belum Bayar',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: colorsApp.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Room ${tagihan['nomor_kamar']} • Period ${datePeriode != null ? DateFormat('MMMM yyyy').format(datePeriode) : '-'}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: colorsApp.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Informasi tagihan
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorsApp.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jatuh Tempo',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: colorsApp.textSecondary,
                      ),
                    ),
                    Text(
                      tglMasuk != null
                          ? DateFormat('dd MMM yyyy').format(tglMasuk)
                          : '-',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorsApp.textPrimary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Jumlah Tagihan',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: colorsApp.textSecondary,
                      ),
                    ),
                    Text(
                      'Rp ${NumberFormat.decimalPattern('id').format(tagihan['jumlah'])}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colorsApp.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tombol aksi
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _showDetailTagihan(context, tagihan);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: colorsApp.border),
                  ),
                  child: Text(
                    'Detail',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: colorsApp.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showBayarModal(context, tagihan);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorsApp.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.wallet_add, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Bayar',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  void _showBayarModal(BuildContext context, tagihan) {
    final Jatuhtempo = DateTime.parse(tagihan['tanggal_masuk']);
    final String? bulan = tagihan['bulan'];
    final String? tahun = tagihan['tahun'];

    DateTime? datePeriode;
    datePeriode = DateTime(int.parse(tahun!), int.parse(bulan!));
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: colorsApp.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.wallet_check,
                    size: 30,
                    color: colorsApp.success,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Konfirmasi Pembayaran',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colorsApp.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${tagihan['nama']} - Kamar ${tagihan['nomor_kamar']}',
                  style: GoogleFonts.poppins(
                    color: colorsApp.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorsApp.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Periode',
                          DateFormat('MMMM yyyy').format(datePeriode!)),
                      const SizedBox(height: 8),
                      _buildInfoRow('Jatuh Tempo',
                          DateFormat('dd MMM yyyy').format(Jatuhtempo)),
                      const SizedBox(height: 16),
                      Divider(color: colorsApp.border),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Rp ${NumberFormat.decimalPattern('id').format(tagihan['jumlah'])}',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: colorsApp.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: colorsApp.border),
                        ),
                        child: Text(
                          'Batal',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Proses pembayaran
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorsApp.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Bayar',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDetailTagihan(BuildContext context, tagihan) {
    final Jatuhtempo = DateTime.parse(tagihan['tanggal_masuk']);
    final String? bulan = tagihan['bulan'];
    final String? tahun = tagihan['tahun'];

    DateTime? datePeriode;
    datePeriode = DateTime(int.parse(tahun!), int.parse(bulan!));
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detail Tagihan',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorsApp.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Nama', tagihan['nama']),
                _buildDetailRow('Kamar', tagihan['nomor_kamar']),
                _buildDetailRow(
                    'Periode', DateFormat('MMMM yyyy').format(datePeriode!)),
                _buildDetailRow('Jatuh Tempo',
                    DateFormat('dd MMM yyyy').format(Jatuhtempo)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorsApp.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jumlah Tagihan',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Rp ${NumberFormat.decimalPattern('id').format(tagihan['jumlah'])}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: colorsApp.error,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showBayarModal(context, tagihan);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorsApp.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Bayar Tagihan',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: colorsApp.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: colorsApp.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // modal Pembayaran
  void ForminputpembayarabDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(
            opacity: animation,
            child: PembayranForm(),
          ),
        );
      },
    );
  }
}
