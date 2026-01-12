import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/data/databases/database_helper.dart';
import 'package:may_kos/data/models/pembayaran.dart';
import 'package:may_kos/page/empty_page/empty_page.dart';
import 'package:may_kos/utils/getInitials.dart';

class RiwayatPembayaranPage extends StatefulWidget {
  const RiwayatPembayaranPage({super.key});

  @override
  State<RiwayatPembayaranPage> createState() => _RiwayatPembayaranPageState();
}

class _RiwayatPembayaranPageState extends State<RiwayatPembayaranPage> {
  String _selectedFilter = 'semua'; // semua, bulan-ini, tahun-ini
  List<Pembayaran> _riwayatList = [];

  @override
  void _loadData() async {
    final data = await DatabaseHelper().getAllPembayaran();
    setState(() {
      _riwayatList = data;
    });
  }

  // 1. Ubah getter agar mengambil data dari _riwayatList
  List<Pembayaran> get _filteredRiwayat {
    // Saya ubah namanya agar lebih jelas
    if (_selectedFilter == 'semua')
      return _riwayatList; // Ambil dari list utama

    final now = DateTime.now();

    // Ambil dari _riwayatList, bukan memanggil getter ini lagi
    return _riwayatList.where((item) {
      try {
        // Karena di database kita simpan ISO8601, gunakan DateTime.parse
        final date = DateTime.parse(item.tanggalPembayaran);

        if (_selectedFilter == 'bulan-ini') {
          return date.month == now.month && date.year == now.year;
        } else if (_selectedFilter == 'tahun-ini') {
          return date.year == now.year;
        }
      } catch (e) {
        return false;
      }
      return true;
    }).toList();
  }

  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    // final filteredList = _filterRiwayat(_riwayatList);
    // final totalPembayaran = _calculateTotal(filteredList);

    return Scaffold(
      backgroundColor: colorsApp.background,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              color: colorsApp.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
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
                  children: [
                    IconButton(
                      icon: const Icon(
                        Iconsax.arrow_left_1,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Riwayat Pembayaran',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Untuk balance layout
                  ],
                ),
                const SizedBox(height: 10),

                // Statistik
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorsApp.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorsApp.primary.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Pembayaran',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Rp. 090920193',
                            // 'Rp ${_formatCurrency(totalPembayaran)}',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
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
                          color: colorsApp.success.withOpacity(0.80),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              // Iconsax.receipt_tick,
                              Iconsax.receipt_1,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '4 Transaksi',
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

                // Filter tabs
              ],
            ),
          ),

          // Filter dan Search
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.search_normal,
                          size: 20,
                          color: colorsApp.textTertiary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Cari riwayat pembayaran...',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: colorsApp.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Iconsax.filter,
                    size: 20,
                    color: colorsApp.primary,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterTab(
                    label: 'Semua',
                    value: 'semua',
                  ),
                ),
                Expanded(
                  child: _buildFilterTab(
                    label: 'Bulan Ini',
                    value: 'bulan-ini',
                  ),
                ),
                Expanded(
                  child: _buildFilterTab(
                    label: 'Tahun Ini',
                    value: 'tahun-ini',
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // List Riwayat
          // Di dalam Widget build, bagian list riwayat:
          Expanded(
            child: _riwayatList.isEmpty
                ? const EmptyPage()
                : _filteredRiwayat.isEmpty
                    ? const Center(
                        child: Text('Riwayat pembayaran tidak ditemukan'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _filteredRiwayat
                            .length, // Gunakan list yang sudah difilter
                        itemBuilder: (context, index) {
                          final riwayat = _filteredRiwayat[index];
                          return _buildRiwayatCard(riwayat);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({
    required String label,
    required String value,
  }) {
    final isSelected = _selectedFilter == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 35,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? colorsApp.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.transparent : colorsApp.textTertiary,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : colorsApp.textTertiary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRiwayatCard(Pembayaran? riwayat) {
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorsApp.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        // Iconsax.receipt_tick,
                        Iconsax.receipt,
                        size: 20,
                        color: colorsApp.success,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        riwayat!.namaPenghuniPembayaran,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorsApp.textPrimary,
                        ),
                      ),
                      Text(
                        'Kamar ${riwayat.nomorKamarPembayar}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: colorsApp.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorsApp.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.tick_circle,
                      size: 12,
                      color: colorsApp.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      riwayat.statusPembayaran,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorsApp.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Informasi Pembayaran
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorsApp.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Iconsax.calendar_1,
                  label: 'Periode',
                  value: DateFormat('MMMM yyyy')
                      .format(DateTime.parse(riwayat.periodePembayaran)),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Iconsax.calendar_tick,
                  label: 'Tanggal Bayar',
                  value: DateFormat('dd MMMM yyyy')
                      .format(DateTime.parse(riwayat.tanggalPembayaran)),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Iconsax.clock,
                  label: 'Waktu',
                  value: '-',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Iconsax.wallet,
                  label: 'Metode',
                  value: riwayat.metodeBayar,
                ),
                const SizedBox(height: 12),
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
                        color: colorsApp.textPrimary,
                      ),
                    ),
                    Text(
                      NumberFormat.decimalPattern('id')
                          .format(riwayat.jumlahPembayaran),
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colorsApp.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tombol Aksi
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _showDetailRiwayat(context, riwayat);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: colorsApp.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.document_text,
                        size: 18,
                        color: colorsApp.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Detail',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: colorsApp.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showBuktiPembayaran(context, riwayat);
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
                      Icon(
                        Iconsax.document_download,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Bukti',
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colorsApp.textTertiary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: colorsApp.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colorsApp.textPrimary,
          ),
        ),
      ],
    );
  }

  // List<Map<String, dynamic>> _filterRiwayat() {
  //   if (_selectedFilter == 'semua') return list;

  //   final now = DateTime.now();
  //   return list.where((item) {
  //     final dateParts = item['tanggal_bayar'].split(' ');
  //     final monthName = dateParts[1];
  //     final year = dateParts[2];

  //     final months = {
  //       'Januari': 1,
  //       'Februari': 2,
  //       'Maret': 3,
  //       'April': 4,
  //       'Mei': 5,
  //       'Juni': 6,
  //       'Juli': 7,
  //       'Agustus': 8,
  //       'September': 9,
  //       'Oktober': 10,
  //       'November': 11,
  //       'Desember': 12
  //     };

  //     final month = months[monthName];
  //     final itemYear = int.tryParse(year) ?? 0;

  //     if (_selectedFilter == 'bulan-ini') {
  //       return month == now.month && itemYear == now.year;
  //     } else if (_selectedFilter == 'tahun-ini') {
  //       return itemYear == now.year;
  //     }
  //     return true;
  //   }).toList();
  // }

  void _showDetailRiwayat(BuildContext context, Pembayaran? riwayat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Detail Pembayaran',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: colorsApp.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Informasi Penghuni
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorsApp.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: colorsApp.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              StringUtils.getInitials(
                                  riwayat!.namaPenghuniPembayaran),
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: colorsApp.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                riwayat.namaPenghuniPembayaran,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: colorsApp.textPrimary,
                                ),
                              ),
                              Text(
                                'Kamar ${riwayat.nomorKamarPembayar}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: colorsApp.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Detail Pembayaran
                  Text(
                    'Detail Transaksi',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorsApp.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildDetailItem(
                      'Periode',
                      DateFormat('MMMM yyyy')
                          .format(DateTime.parse(riwayat.periodePembayaran))),
                  _buildDetailItem(
                      'Tanggal Bayar',
                      DateFormat('dd MMMM yyyy')
                          .format(DateTime.parse(riwayat.tanggalPembayaran))),
                  _buildDetailItem('Waktu', '-'),
                  _buildDetailItem('Metode Pembayaran', riwayat.metodeBayar),
                  _buildDetailItem('Status Bukti', riwayat.statusPembayaran),
                  const SizedBox(height: 20),

                  // Total
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorsApp.success.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pembayaran',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: colorsApp.textPrimary,
                          ),
                        ),
                        Text(
                          NumberFormat.decimalPattern('id')
                              .format(riwayat.jumlahPembayaran),
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: colorsApp.success,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Tombol Aksi
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorsApp.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Tutup',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
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
              color: colorsApp.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showBuktiPembayaran(BuildContext context, Pembayaran? riwayat) {
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
                    color: colorsApp.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.document_download,
                    size: 30,
                    color: colorsApp.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Bukti Pembayaran',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colorsApp.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  riwayat!.namaPenghuniPembayaran,
                  style: GoogleFonts.poppins(
                    color: colorsApp.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                if (riwayat.buktiPembayaran == 'Tersedia') ...[
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorsApp.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorsApp.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.document,
                          size: 50,
                          color: colorsApp.textTertiary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Bukti_${riwayat.namaPenghuniPembayaran}_${riwayat.periodePembayaran}.jpg',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: colorsApp.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                            'Tutup',
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
                            // Download bukti
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
                            'Download',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorsApp.warning.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorsApp.warning.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Iconsax.danger,
                          size: 40,
                          color: colorsApp.warning,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Bukti Pembayaran Tidak Tersedia',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorsApp.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bukti pembayaran untuk transaksi ini belum diupload',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: colorsApp.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorsApp.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Tutup',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
