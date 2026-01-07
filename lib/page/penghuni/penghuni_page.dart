import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/data/databases/database_helper.dart';
import 'package:may_kos/data/models/kamar.dart';
import 'package:may_kos/data/models/penghuni.dart';
import 'package:may_kos/page/empty_page/empty_page.dart';
import 'package:may_kos/page/penghuni/info_penghuni.dart';
import 'package:may_kos/page/penghuni/penghuni_Form.dart';
import 'package:may_kos/utils/date_picker.dart';
import 'package:may_kos/widgets/Widget_DeleteDialog.dart';
import 'package:may_kos/widgets/widgetApbarConten.dart';
import 'package:may_kos/widgets/widget_Search.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PenghuniPage extends StatefulWidget {
  final Penghuni? penghuni;
  const PenghuniPage({super.key, this.penghuni});

  @override
  State<PenghuniPage> createState() => _PenghuniPageState();
}

class _PenghuniPageState extends State<PenghuniPage> {
  // Default: Semua
  String _selectedFilter = 'Semua';
  // semua penghuni
  List<Penghuni> _allPenghuni = [];
  List<Penghuni> _filteredPenghuni = [];
  // kamar
  List<Kamar> _allKamar = [];
  bool isLoading = true;

  //  mengambil data penghuni dari Database
  void _loadData() async {
    final data = await DatabaseHelper().getAllPenghuni();
    final dataKamar = await DatabaseHelper().getAllKamar();
    setState(() {
      _allPenghuni = data;
      _filteredPenghuni = data;
      _allKamar = dataKamar;
      isLoading = false;
    });
  }

  // total penghuni aktif
  int get totalPenghuniAktif =>
      _allPenghuni.where((p) => p.statusPenghuni == true).length;
  // total penghuni keluar
  int get totalPenghuniKeluar =>
      _allPenghuni.where((p) => p.statusPenghuni == false).length;
  // totla kamar
  int get totalkamar => _allKamar.length;
  // Menghitung penghuni yang masuk dalam 7 hari terakhir
  int get totalPenghuniBaru {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    return _allPenghuni.where((p) {
      // Pastikan hanya menghitung yang statusnya masih Aktif
      // dan tanggal masuknya setelah/sama dengan 7 hari yang lalu
      return p.statusPenghuni == true && p.tanggalMasuk.isAfter(sevenDaysAgo);
    }).length;
  }

  // filtter aktif/keluar
  List<Penghuni> get filteredPenghuni {
    return _allPenghuni.where((p) {
      if (_selectedFilter == 'Aktif') {
        return p.statusPenghuni == true;
      } else if (_selectedFilter == 'Keluar') {
        return p.statusPenghuni == false;
      } else {
        return true;
      }
    }).toList();
  }

  // keluar penghuni
  void _keluarPenghuni(Penghuni data) async {
    final idPenghuni = data.id;
    final idKamar = data.kamarId;
    try {
      await DatabaseHelper().keluarPenghuni(idPenghuni, idKamar);
      _loadData();

      if (!mounted) return;
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(message: "Penghuni berhasil keluar"),
      );
    } catch (e) {
      print("Error keluar: $e");
    }
  }

  // hapus penghuni
  void _hapusPenghuni(Penghuni data) async {
    // Panggil Dialog
    bool? confirm = await SharedDeleteDialog.show(
      context,
      title: "Hapus Penghuni",
      content:
          "Apakah Anda yakin ingin menghapus Penghuni ${data.namaPenghuni}?", // Gunakan 'data', bukan 'widget'
    );

    // Eksekusi jika 'Hapus' ditekan
    if (confirm == true) {
      try {
        // Ambil ID dari 'data'
        await DatabaseHelper().deletePenghuni(data.id!);

        if (!mounted) return;

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message: "Data penghuni berhasil dihapus",
          ),
        );

        // Panggil fungsi untuk refresh list (misal: _loadData())
        _loadData();
      } catch (e) {
        debugPrint("Error Hapus: $e");
      }
    }
  }

  // untu fitur searc
  void _filterPenghuni(String query) {
    final filtered = _allPenghuni.where((p) {
      final searchInput = query.toLowerCase();
      final nama = p.namaPenghuni.toLowerCase();

      // Sesuaikan p.nomorKamar dengan nama field di model atau database kamu
      final nomorKamar = p.nomorKamar?.toString().toLowerCase() ?? "";

      return nama.contains(searchInput) || nomorKamar.contains(searchInput);
    }).toList();

    setState(() {
      _filteredPenghuni = filtered;
    });
  }

  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorsApp.background,
      body: Column(
        children: [
          Widgetapbarconten(
            title: 'Penghuni',
            rightIcon: Iconsax.user_add,
            onRightIconTap: () => showPenghuniModall(
              context: context,
              isEditMode: false,
            ),
            contain: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCard(
                  context,
                  'Aktif',
                  '${totalPenghuniAktif}',
                  Icons.person,
                  Colors.green,
                ),
                _buildCard(
                  context,
                  'Keluar',
                  '${totalPenghuniKeluar}',
                  Icons.logout,
                  Colors.red,
                ),
                _buildCard(
                  context,
                  'Kamar',
                  '${totalkamar}',
                  Icons.hotel,
                  Colors.purple,
                ),
                _buildCard(
                  context,
                  'Baru',
                  totalPenghuniBaru.toString(),
                  Icons.new_releases,
                  Colors.red,
                ),
              ],
            ),
          ),
          // search....
          WidgetSearch(
            title: 'Cari penghuni & nomor kamar',
            onChanged: (value) {
              _filterPenghuni(value);
            },
          ),

          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatusTab(label: 'Semua', isAktif: 'Semua'),
                  _buildStatusTab(label: 'Aktif', isAktif: 'Aktif'),
                  _buildStatusTab(label: 'Keluar', isAktif: 'Keluar'),
                ],
              )),
          const SizedBox(height: 20),

          // List Penghun
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : _allPenghuni.isEmpty
                  ? const EmptyPage() // Jika database memang kosong
                  : Expanded(
                      child: filteredPenghuni.isEmpty
                          ? const Center(
                              child: Text(
                                  "Penghuni tidak ditemukan")) // Jika pencarian tidak ada hasil
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 16),
                              itemCount: filteredPenghuni.length,
                              itemBuilder: (context, index) {
                                final penghuni = filteredPenghuni[index];
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
    required String isAktif,
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

  Widget _buildcardPenghuni(Penghuni? penghuni) {
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
                  getInitials(penghuni!.namaPenghuni),
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
                        penghuni.namaPenghuni,
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
                          color: penghuni.statusPenghuni
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: penghuni.statusPenghuni
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
                                color: penghuni.statusPenghuni
                                    ? Colors.green[400]
                                    : Colors.red[400],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              penghuni.statusPenghuni ? 'Aktif' : 'Keluar',
                              style: TextStyle(
                                fontSize: 12,
                                color: penghuni.statusPenghuni
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
                        "0812731639",
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
                        "Kamar ${penghuni.nomorKamar}",
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
                        "Masuk: ${DatePickerUtil.formatTanggal(penghuni.tanggalMasuk)}",
                        // "Masuk: ${penghuni.tanggalMasuk}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      penghuni.statusPenghuni
                          ? const Text('')
                          : Row(
                              children: [
                                Text(" | "),
                                Icon(
                                  Icons.logout,
                                  size: 12,
                                  color: colorsApp.error,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  DatePickerUtil.formatTanggal(
                                      penghuni.tanggalKeluar),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorsApp.error,
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
                        penghuni: penghuni,
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
                if (penghuni.statusPenghuni)
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
                      // Data penghuni yang akan diedit
                      Future.delayed(
                        const Duration(seconds: 0),
                        () => showPenghuniModall(
                          context: context,
                          penghuni: penghuni,
                          isEditMode: true,
                        ),
                      );
                    },
                  ),
                penghuni.statusPenghuni
                    ? PopupMenuItem(
                        value: 'keluar',
                        child: Row(
                          children: [
                            Icon(Icons.logout, size: 18, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('Keluar'),
                          ],
                        ),
                        onTap: () {
                          Future.delayed(
                            const Duration(seconds: 0),
                            () => _keluarPenghuni(penghuni),
                          );
                        },
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
                        onTap: () {
                          Future.delayed(
                            Duration(seconds: 0),
                            () => _hapusPenghuni(penghuni),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showPenghuniModall({
    required BuildContext context,
    final Penghuni? penghuni,
    bool isEditMode = false,
  }) async {
    final result = await showGeneralDialog(
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
            child: PenghuniForm(
              penghuni: penghuni,
              isEditMode: isEditMode,
            ),
          ),
        );
      },
    );
    setState(() {});
    // reload data
    if (result == true) {
      _loadData();
    }
  }

  // info penghuni
  void showDetailPenghuniDialogWithAnimation({
    required BuildContext context,
    required Penghuni penghuni,
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
            child: DetailPenghuniDialog(penghuni: penghuni),
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
