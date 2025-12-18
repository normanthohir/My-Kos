import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:may_kos/config/theme.dart';

class RiwayatPembayaranPage extends StatefulWidget {
  const RiwayatPembayaranPage({super.key});

  @override
  State<RiwayatPembayaranPage> createState() => _RiwayatPembayaranPageState();
}

class _RiwayatPembayaranPageState extends State<RiwayatPembayaranPage> {
  String _selectedFilter = 'semua'; // semua, bulan-ini, tahun-ini
  final List<Map<String, dynamic>> _riwayatList = [];

  @override
  void initState() {
    super.initState();
    _loadDummyData();
  }

  void _loadDummyData() {
    // Data dummy riwayat pembayaran
    _riwayatList.addAll([
      {
        'id': 1,
        'nama': 'Siti Milaa',
        'kamar': '012',
        'periode': 'April 2024',
        'tanggal_bayar': '5 April 2024',
        'waktu': '14:30',
        'jumlah': 1200000,
        'metode': 'Transfer Bank',
        'status': 'lunas',
        'bukti': 'Tersedia',
      },
      {
        'id': 2,
        'nama': 'Ahmad Fauzi',
        'kamar': '022',
        'periode': 'April 2024',
        'tanggal_bayar': '7 April 2024',
        'waktu': '10:15',
        'jumlah': 1100000,
        'metode': 'Tunai',
        'status': 'lunas',
        'bukti': 'Tidak Tersedia',
      },
      {
        'id': 3,
        'nama': 'Reza Maulana',
        'kamar': '011',
        'periode': 'April 2024',
        'tanggal_bayar': '9 April 2024',
        'waktu': '16:45',
        'jumlah': 1200000,
        'metode': 'Transfer Bank',
        'status': 'lunas',
        'bukti': 'Tersedia',
      },
      {
        'id': 4,
        'nama': 'Swisto Bagus',
        'kamar': '002',
        'periode': 'Maret 2024',
        'tanggal_bayar': '5 Desember 2025',
        'waktu': '11:20',
        'jumlah': 1100000,
        'metode': 'Transfer Bank',
        'status': 'lunas',
        'bukti': 'Tersedia',
      },
      {
        'id': 5,
        'nama': 'Siti Milaa',
        'kamar': '012',
        'periode': 'Maret 2024',
        'tanggal_bayar': '7 Maret 2024',
        'waktu': '09:30',
        'jumlah': 1200000,
        'metode': 'Tunai',
        'status': 'lunas',
        'bukti': 'Tersedia',
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filterRiwayat(_riwayatList);
    final totalPembayaran = _calculateTotal(filteredList);

    return Scaffold(
      backgroundColor: colorsApp.background,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(
              top: 60,
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
                            'Rp ${_formatCurrency(totalPembayaran)}',
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
                              '${filteredList.length} Transaksi',
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

                const SizedBox(height: 16),

                // Filter tabs
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorsApp.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
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

          // List Riwayat
          Expanded(
            child: filteredList.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final riwayat = filteredList[index];
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
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? colorsApp.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
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

  Widget _buildRiwayatCard(Map<String, dynamic> riwayat) {
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
                        riwayat['nama'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorsApp.textPrimary,
                        ),
                      ),
                      Text(
                        'Kamar ${riwayat['kamar']}',
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
                      'LUNAS',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
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
                  value: riwayat['periode'],
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Iconsax.calendar_tick,
                  label: 'Tanggal Bayar',
                  value: riwayat['tanggal_bayar'],
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Iconsax.clock,
                  label: 'Waktu',
                  value: riwayat['waktu'],
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Iconsax.wallet,
                  label: 'Metode',
                  value: riwayat['metode'],
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
                      'Rp ${_formatCurrency(riwayat['jumlah'])}',
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorsApp.background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.receipt_search,
              size: 50,
              color: colorsApp.textTertiary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tidak Ada Riwayat',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colorsApp.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Riwayat pembayaran akan muncul setelah ada pembayaran',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: colorsApp.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _filterRiwayat(List<Map<String, dynamic>> list) {
    if (_selectedFilter == 'semua') return list;

    final now = DateTime.now();
    return list.where((item) {
      final dateParts = item['tanggal_bayar'].split(' ');
      final monthName = dateParts[1];
      final year = dateParts[2];

      final months = {
        'Januari': 1,
        'Februari': 2,
        'Maret': 3,
        'April': 4,
        'Mei': 5,
        'Juni': 6,
        'Juli': 7,
        'Agustus': 8,
        'September': 9,
        'Oktober': 10,
        'November': 11,
        'Desember': 12
      };

      final month = months[monthName];
      final itemYear = int.tryParse(year) ?? 0;

      if (_selectedFilter == 'bulan-ini') {
        return month == now.month && itemYear == now.year;
      } else if (_selectedFilter == 'tahun-ini') {
        return itemYear == now.year;
      }
      return true;
    }).toList();
  }

  int _calculateTotal(List<Map<String, dynamic>> list) {
    return list.fold(0, (sum, item) => sum + (item['jumlah'] as int));
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  void _showDetailRiwayat(BuildContext context, Map<String, dynamic> riwayat) {
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
                              riwayat['nama'][0],
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
                                riwayat['nama'],
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: colorsApp.textPrimary,
                                ),
                              ),
                              Text(
                                'Kamar ${riwayat['kamar']}',
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

                  _buildDetailItem('Periode', riwayat['periode']),
                  _buildDetailItem('Tanggal Bayar', riwayat['tanggal_bayar']),
                  _buildDetailItem('Waktu', riwayat['waktu']),
                  _buildDetailItem('Metode Pembayaran', riwayat['metode']),
                  _buildDetailItem('Status Bukti', riwayat['bukti']),

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
                          'Rp ${_formatCurrency(riwayat['jumlah'])}',
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

  void _showBuktiPembayaran(
      BuildContext context, Map<String, dynamic> riwayat) {
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
                  riwayat['nama'],
                  style: GoogleFonts.poppins(
                    color: colorsApp.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                if (riwayat['bukti'] == 'Tersedia') ...[
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
                          'Bukti_${riwayat['nama']}_${riwayat['periode']}.jpg',
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
