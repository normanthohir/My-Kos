import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/data/databases/database_helper.dart';
import 'package:may_kos/data/models/kamar.dart';
import 'package:may_kos/page/empty_page/empty_page.dart';
import 'package:may_kos/page/kamar/kamar_form.dart';
import 'package:may_kos/utils/formatters.dart';
import 'package:may_kos/widgets/widgetApbarConten.dart';

class KamarPage extends StatefulWidget {
  const KamarPage({Key? key}) : super(key: key);

  @override
  State<KamarPage> createState() => _KamarPageState();
}

class _KamarPageState extends State<KamarPage> {
  String filterStatus = 'Semua';
  List<Kamar> allKamar = [];

//  mengambil data kamar dari Database
  Future<void> _ambilData() async {
    final data = await DatabaseHelper().getAllKamar();
    setState(() {
      allKamar = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  Widget build(BuildContext context) {
    // 1. Logika Filter untuk ListView
    List<Kamar> filteredRooms = allKamar.where((room) {
      if (filterStatus == 'Semua') return true;
      return room.statusKamar.toLowerCase() == filterStatus.toLowerCase();
    }).toList();

    int totalRooms = allKamar.length;
    int terisiRooms =
        allKamar.where((room) => room.statusKamar == 'terisi').length;

    int tersediaRooms =
        allKamar.where((room) => room.statusKamar == 'Tersedia').length;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Widgetapbarconten(
            title: 'Daftar Kamar',
            rightIcon: Iconsax.add_circle,
            onRightIconTap: () => _ForminputKamar(room: null, index: -1),
            contain: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  'Total',
                  '$totalRooms',
                ),
                _buildStatCard(
                  'Terisi',
                  '$terisiRooms',
                ),
                _buildStatCard(
                  'Tersedia',
                  '$tersediaRooms',
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Status:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterTap('Semua', filterStatus == 'Semua'),
                    ),
                    Expanded(
                        child: _buildFilterTap(
                            'Tersedia', filterStatus == 'Tersedia')),
                    Expanded(
                        child: _buildFilterTap(
                            'Terisi', filterStatus == 'terisi')),
                  ],
                ),
              ],
            ),
          ),
          FutureBuilder<List<Kamar>>(
            future: DatabaseHelper().getAllKamar(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                    child: Text("Terjadi kesalahan: ${snapshot.error}"));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: EmptyPage());
              }

              List<Kamar> semuaKamar = snapshot.data!;

              List<Kamar> filteredRooms = semuaKamar.where((room) {
                if (filterStatus == 'Semua') return true;
                return room.statusKamar.trim().toLowerCase() ==
                    filterStatus.trim().toLowerCase();
              }).toList();

              if (filteredRooms.isEmpty) {
                return const EmptyPage();
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: filteredRooms.length,
                    itemBuilder: (context, index) {
                      Kamar kamar = filteredRooms[index];

                      return GestureDetector(
                        onTap: () {
                          _ForminputKamar(room: kamar, index: index);
                        },
                        child: _buildRoomCard(kamar: kamar),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // form tambah dan edit kamar
  void _ForminputKamar({Kamar? room, int? index}) async {
    // Tangkap result dari dialog
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
            child: KamarForm(
              room: room,
            ),
          ),
        );
      },
    );
    setState(() {});
    // reload data
    if (result == true) {
      _ambilData();
    }
  }

// Fungsi pembantu snackbar agar kode lebih bersih
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
  ) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTap(String label, bool isSelected) {
    // final isSelected = filterStatus == isSelected;
    return InkWell(
      onTap: () {
        setState(() {
          filterStatus = label;
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

  Widget _buildRoomCard({Kamar? kamar}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: kamar!.statusKamar == "terisi"
                  ? colorsApp.error.withOpacity(0.15)
                  : colorsApp.success.withOpacity(0.15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kamar',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  kamar.nomorKamar,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.king_bed,
                      size: 16,
                      color: colorsApp.textPrimary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      kamar.typeKamar,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colorsApp.textPrimary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Iconsax.wallet,
                      size: 16,
                      color: colorsApp.textPrimary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      NumberFormat.decimalPattern('id')
                          .format(kamar.hargaKamar),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colorsApp.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kamar.statusKamar == "terisi"
                        ? colorsApp.error.withOpacity(0.12)
                        : colorsApp.success.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kamar.statusKamar == "terisi"
                              ? colorsApp.error
                              : colorsApp.success,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        kamar.statusKamar,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kamar.statusKamar == "terisi"
                              ? colorsApp.error
                              : colorsApp.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kamar.statusKamar == "terisi"
                    ? Colors.red.withOpacity(0.2)
                    : Colors.green.withOpacity(0.2),
              ),
              child: Icon(
                kamar.statusKamar == "terisi"
                    ? Icons.person
                    : Icons.person_outline,
                color: kamar.statusKamar == "terisi"
                    ? Colors.red[600]
                    : Colors.green[600],
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
