import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:may_kos/config/theme.dart';
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
  final List<Map<String, dynamic>> _penghuniList = [];

  void _loadDumydata() {
    _penghuniList.addAll([
      {
        'id': 1,
        'nama': 'Siti Milaa',
        'status': true,
        'kamar': '012',
        'no_hp': '081256151551',
        'tgl_masuk': '30-05-2024',
        'tgl_keluar': ''
      },
      {
        'id': 2,
        'nama': 'Ahmad Fauzi',
        'status': true,
        'kamar': '022',
        'no_hp': '081156157878',
        'tgl_masuk': '30-05-2024',
        'tgl_keluar': ''
      },
      {
        'id': 3,
        'nama': 'Reza Maulana',
        'status': false,
        'kamar': '011',
        'no_hp': '081256151551',
        'tgl_masuk': '30-05-2025',
        'tgl_keluar': '10-12-2025'
      },
      {
        'id': 4,
        'nama': 'Swisto Bagus',
        'status': false,
        'kamar': '002',
        'no_hp': '081256151551',
        'tgl_masuk': '20-01-2025',
        'tgl_keluar': '01-08-2025'
      },
      {
        'id': 5,
        'nama': 'Siti Milaa',
        'status': true,
        'kamar': '012',
        'no_hp': '081256151551',
        'tgl_masuk': '30-05-2024',
        'tgl_keluar': ''
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
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
                Expanded(child: _buildStatusTab('Semua', true)),
                SizedBox(width: 10),
                Expanded(child: _buildStatusTab('Aktif', false)),
                SizedBox(width: 10),
                Expanded(child: _buildStatusTab('Keluar', false)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // List Penghun

          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _buildcardPenghuni(
                      1,
                      'Siti Milaa',
                      true,
                      '08012677126',
                      '101',
                      '12 03 2024',
                      '',
                    ),
                    _buildcardPenghuni(
                      2,
                      'Ahmad Fauzi',
                      false,
                      '08012677126',
                      '102',
                      '12 06 2024',
                      '20 04 2025',
                    ),
                    _buildcardPenghuni(
                      3,
                      'Reza Maulana',
                      true,
                      '434398439894',
                      '201',
                      '12 04 2024',
                      '',
                    ),
                    _buildcardPenghuni(
                      4,
                      'Swisto Bagus',
                      false,
                      '080126778376',
                      '202',
                      '12 04 2024',
                      '10 05 2025',
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
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
  Widget _buildStatusTab(String label, bool isActive) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue[800] : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? Colors.blue[800]! : Colors.grey[500]!,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.blue[800]!.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Colors.grey[600],
            )),
      ),
    );
  }

  Widget _buildcardPenghuni(
    int Id,
    String namaPenghuni,
    bool statusPenghuni,
    String nomorTelepon,
    String kamarPenghuni,
    String tanggalMasuk,
    String tanggalKeluar,
  ) {
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
                  getInitials(namaPenghuni),
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
                        namaPenghuni,
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
                          color: statusPenghuni
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusPenghuni
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
                                color: statusPenghuni
                                    ? Colors.green[400]
                                    : Colors.red[400],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              statusPenghuni ? 'Aktif' : 'Keluar',
                              style: TextStyle(
                                fontSize: 12,
                                color: statusPenghuni
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
                        nomorTelepon,
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
                        "Kamar $kamarPenghuni",
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
                        'Masuk: $tanggalMasuk ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      statusPenghuni
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
                                  '$tanggalKeluar',
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
                          'id': Id,
                          'nama': namaPenghuni,
                          'nomorTelepon': nomorTelepon,
                          'kamar': kamarPenghuni,
                          'tanggalMasuk': tanggalMasuk,
                          'tanggalKeluar': tanggalKeluar,
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
                if (statusPenghuni)
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
                        'id': Id,
                        'nama': namaPenghuni,
                        'nomorTelepon': nomorTelepon,
                        'kamar': kamarPenghuni,
                        'tanggalMasuk': tanggalMasuk,
                      };

                      showPenghuniModal(
                        context: context,
                        penghuniData: penghuniData,
                        isEditMode: true,
                      );
                    },
                  ),
                statusPenghuni
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
