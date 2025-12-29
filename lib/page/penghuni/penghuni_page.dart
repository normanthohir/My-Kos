import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/page/empty_page/empty_page.dart';
import 'package:may_kos/page/penghuni/info_penghuni.dart';
import 'package:may_kos/page/penghuni/penghuni_Form.dart';
import 'package:may_kos/widgets/widgetApbarConten.dart';
import 'package:may_kos/widgets/widget_Search.dart';

class PenghuniPage extends StatefulWidget {
  const PenghuniPage({super.key});

  @override
  State<PenghuniPage> createState() => _PenghuniPageState();
}

class _PenghuniPageState extends State<PenghuniPage> {
  // Logika untuk memfilter data berdasarkan tombol yang dipilih
  List<Map<String, dynamic>> get _filteredPenghuni {
    if (_selectedFilter == null) {
      return _penghuniList;
    }
    // Filter list berdasarkan status true/false
    return _penghuniList.where((penghuni) {
      return penghuni['status'] == _selectedFilter;
    }).toList();
  }

  Object? _selectedFilter = null; // Default: Semua
  List<Map<String, dynamic>> _penghuniList = [];

  void initState() {
    super.initState();
    _loadDummyData();
  }

  void _loadDummyData() {
    _penghuniList.addAll([
      {
        'id': 1,
        'nama': 'Siti Milaa',
        'status': true,
        'kamar': '112',
        'no_hp': '081256151551',
        'harga': '400000',
        'tgl_masuk': '30-05-2024',
        'tgl_keluar': ''
      },
      {
        'id': 2,
        'nama': 'Ahmad Fauzi',
        'status': true,
        'kamar': '122',
        'no_hp': '081156157878',
        'harga': '500000',
        'tgl_masuk': '30-05-2024',
        'tgl_keluar': ''
      },
      {
        'id': 3,
        'nama': 'Reza Maulana',
        'status': false,
        'kamar': '111',
        'no_hp': '081256151551',
        'harga': '400000',
        'tgl_masuk': '30-05-2025',
        'tgl_keluar': '10-12-2025'
      },
      {
        'id': 4,
        'nama': 'Swisto Bagus',
        'status': false,
        'kamar': '102',
        'no_hp': '081256151551',
        'harga': '400000',
        'tgl_masuk': '20-01-2025',
        'tgl_keluar': '01-08-2025'
      },
      {
        'id': 5,
        'nama': 'Siti Milaa',
        'status': true,
        'kamar': '212',
        'no_hp': '081256151551',
        'harga': '600000',
        'tgl_masuk': '30-05-2024',
        'tgl_keluar': ''
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // final filteredList = _filterPenghuni(_penghuniList);
    return Scaffold(
      backgroundColor: colorsApp.background,
      body: Column(
        children: [
          Widgetapbarconten(
            title: 'Penghuni',
            rightIcon: Iconsax.user_add,
            onRightIconTap: () => showPenghuniModal(
              context: context,
              isEditMode: false,
            ),
            contain: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCard(
                  context,
                  'Aktif',
                  '20',
                  Icons.person,
                  Colors.green,
                ),
                _buildCard(
                  context,
                  'Keluar',
                  '5',
                  Icons.logout,
                  Colors.red,
                ),
                _buildCard(
                  context,
                  'Kamar',
                  '8',
                  Icons.hotel,
                  Colors.purple,
                ),
                _buildCard(
                  context,
                  'Baru',
                  '3',
                  Icons.new_releases,
                  Colors.red,
                ),
              ],
            ),
          ),
          // search....
          WidgetSearch(title: 'Cari penghuni & kamar', onTap: () {}),

          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatusTab(label: 'Semua', isAktif: null),
                  _buildStatusTab(label: 'Aktif', isAktif: true),
                  _buildStatusTab(label: 'Keluar', isAktif: false),
                ],
              )),
          const SizedBox(height: 20),

          // List Penghun

          Expanded(
            child: _filteredPenghuni
                    .isEmpty // Menggunakan list yang sudah difilter
                ? EmptyPage() // Jika hasil filter kosong (misal: tidak ada yang 'Keluar')
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 16),
                    itemCount: _filteredPenghuni.length,
                    itemBuilder: (context, index) {
                      final penghuni = _filteredPenghuni[index];
                      return _buildcardPenghuni(penghuni);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: colorsApp.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 22,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

// tap status penghuni

  Widget _buildStatusTab({
    required String label,
    required bool? isAktif,
  }) {
    final isSelected = _selectedFilter == isAktif;

    return Expanded(
      // Bungkus di sini agar proporsinya sama di dalam Row
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFilter = isAktif;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          // Gunakan AnimatedContainer agar lebih smooth
          duration: const Duration(milliseconds: 200),
          height: 35, // Sedikit lebih tinggi agar teks tidak terlalu sesak
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? colorsApp.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            // Tambahkan border tipis saat tidak terpilih agar terlihat seperti tombol
            border: Border.all(
              color: isSelected ? Colors.transparent : colorsApp.textTertiary,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : colorsApp.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildcardPenghuni(Map<String, dynamic> penghuni) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: colorsApp.card,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorsApp.primary,
                border: Border.all(
                  color: colorsApp.background,
                  width: 0,
                ),
              ),
              child: Center(
                child: Text(
                  getInitials(penghuni['nama']),
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: colorsApp.background,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        penghuni['nama'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorsApp.textSecondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: penghuni['status']
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: penghuni['status']
                                ? Colors.green[100]!
                                : Colors.red[100]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: penghuni['status']
                                    ? Colors.green[400]
                                    : Colors.red[400],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              penghuni['status'] ? 'Aktif' : 'Keluar',
                              style: TextStyle(
                                fontSize: 12,
                                color: penghuni['status']
                                    ? Colors.green[800]
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        penghuni['no_hp'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Kamar
                  Row(
                    children: [
                      Icon(
                        Icons.hotel,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Kamar ${penghuni['kamar']}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Tanggal masuk / keluar
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Masuk: ${penghuni['tgl_masuk']}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      penghuni['status']
                          ? const Text('')
                          : Row(
                              children: [
                                Text("| "),
                                Icon(
                                  Icons.logout,
                                  size: 12,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 1),
                                Text(
                                  penghuni['tgl_keluar'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Tombol aksi
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.grey[600],
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () {
                    Future.delayed(Duration.zero, () {
                      showDetailPenghuniDialogWithAnimation(
                        context: context,
                        penghuniData: {
                          'id': penghuni['id'],
                          'nama': penghuni['nama'],
                          'nomorTelepon': penghuni['no_hp'],
                          'kamar': penghuni['kamar'],
                          'harga': penghuni['harga'],
                          'tanggalMasuk': penghuni['tgl_masuk'],
                          'tanggalKeluar': penghuni['tgl_keluar'],
                        },
                      );
                    });
                  },
                  value: 'info',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('info'),
                    ],
                  ),
                ),
                if (penghuni['status'])
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                    onTap: () {
                      // Data penghuni yang akan diedit (contoh)
                      Map<String, dynamic> penghuniData = {
                        'id': penghuni['id'],
                        'nama': penghuni['nama'],
                        'nomorTelepon': penghuni['no_hp'],
                        'kamar': penghuni['kamar'],
                        'harga': penghuni['harga'],
                        'tanggalMasuk': penghuni['tgl_masuk'],
                      };

                      showPenghuniModal(
                        context: context,
                        penghuniData: penghuniData,
                        isEditMode: true,
                      );
                    },
                  ),
                penghuni['status']
                    ? const PopupMenuItem(
                        value: 'keluar',
                        child: Row(
                          children: [
                            Icon(Icons.logout, size: 18, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('Keluar'),
                          ],
                        ),
                      )
                    : PopupMenuItem(
                        value: 'Hapus',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Hapus'),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showPenghuniModal({
    required BuildContext context,
    Map<String, dynamic>? penghuniData,
    bool isEditMode = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Handle bar
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Form Penghuni
                      PenghuniForm(
                        penghuniData: penghuniData,
                        isEditMode: isEditMode,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).then((result) {
      // Handle result ketika form ditutup
      if (result != null) {
        // result berisi data yang dikirim dari form
        print('Data penghuni: $result');

        // Di sini Anda bisa panggil fungsi untuk menyimpan ke database
        if (isEditMode) {
          // Panggil fungsi update
          // updatePenghuni(penghuniData['id'], result);
        } else {
          // Panggil fungsi tambah
          // addPenghuni(result);
        }
      }
    });
  }

  // Atau dengan animasi yang lebih smooth:
  void showDetailPenghuniDialogWithAnimation({
    required BuildContext context,
    required Map<String, dynamic> penghuniData,
  }) {
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
            child: DetailPenghuniDialog(penghuniData: penghuniData),
          ),
        );
      },
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
}
