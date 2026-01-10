import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/data/databases/database_helper.dart';
import 'package:may_kos/data/models/kamar.dart';
import 'package:may_kos/widgets/Widget_DeleteDialog.dart';
import 'package:may_kos/widgets/widget_CurrencyInputFormatter.dart';
import 'package:may_kos/widgets/widget_textFormField.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class KamarForm extends StatefulWidget {
  final Kamar? room; // jika null, maka mode tambah

  const KamarForm({
    Key? key,
    this.room,
  }) : super(key: key);

  @override
  State<KamarForm> createState() => _KamarFormState();
}

class _KamarFormState extends State<KamarForm> {
  late TextEditingController _roomNumberController;
  late String _selectedRoomType;
  late String _statusRoom;
  late TextEditingController _hargaController;
  // List tipe kamar yang tersedia
  final List<String> roomTypes = ['Standard', 'Deluxe', 'Suite'];
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future _simpanKamar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final db = DatabaseHelper();
      final String nomorKamarInput = _roomNumberController.text.trim();

      // Cek apakah nomor kamar sudah ada
      bool isDuplikat =
          await db.cekNomorKamar(nomorKamarInput, idTerpasang: widget.room?.id);

      if (isDuplikat) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "Nomor Kamar $nomorKamarInput sudah terdaftar!",
          ),
        );
        return;
      }

      // Persiapan Data
      String hargaBersih =
          _hargaController.text.replaceAll(RegExp(r'[^0-9]'), '');
      Kamar dataKamar = Kamar(
        id: widget.room?.id,
        nomorKamar: nomorKamarInput,
        hargaKamar: double.tryParse(hargaBersih) ?? 0,
        typeKamar: _selectedRoomType,
        statusKamar: _statusRoom,
      );

      // Proses Simpan atau Update
      bool isEdit = widget.room != null;
      if (isEdit) {
        await db.updateKamar(dataKamar);
      } else {
        await db.insertKamar(dataKamar);
      }
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message:
              isEdit ? "Data kamar diperbarui" : 'Kamar berhasil ditambahkan',
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      debugPrint("Error Simpan Kamar: $e");
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: "Terjadi kesalahan sistem",
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  // Hapus kamar
  void _hapusKamar() async {
    // Validasi Status (Proteksi)
    if (widget.room?.statusKamar.trim().toLowerCase() == 'terisi') {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: "Kamar terisi tidak boleh dihapus!",
        ),
      );
      return;
    }

    // Panggil  Dialog
    bool? confirm = await SharedDeleteDialog.show(
      context,
      title: "Hapus Kamar",
      content:
          "Apakah Anda yakin ingin menghapus kamar ${widget.room?.nomorKamar}?",
    );

    //  Eksekusi jika 'Hapus' ditekan
    if (confirm == true) {
      await DatabaseHelper().deleteKamar(widget.room!.id!);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: "Kamar berhasil dihapus",
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    super.initState();
    _roomNumberController =
        TextEditingController(text: widget.room?.nomorKamar ?? '');
    _selectedRoomType = widget.room?.typeKamar ?? 'Standard';
    _statusRoom = widget.room?.statusKamar ?? 'Tersedia';
    _hargaController = TextEditingController(
        text: widget.room?.hargaKamar.toInt().toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    bool isEditMode = widget.room != null;
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEditMode
                            ? 'Edit Kamar ${widget.room!.nomorKamar}'
                            : 'Tambah Kamar Baru',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Iconsax.close_circle,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                // body form
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SharedTextFormField(
                        Controller: _roomNumberController,
                        labelText: 'Nomor kamar',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor kamar harus diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Pilih tipe kamar
                      DropdownButtonFormField<String>(
                        value: _selectedRoomType,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tipe kamar harus dipilih';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Tipe kamar',
                          prefixIcon: const Icon(Iconsax.wallet_2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: roomTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRoomType = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      SharedTextFormField(
                        Controller: _hargaController,
                        labelText: 'Harga kamar',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(Iconsax.wallet_1),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter(),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor kamar harus diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Status kamar (hanya untuk edit, untuk tambah default tersedia)
                      if (isEditMode) ...[
                        Text(
                          'Status Kamar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _statusRoom = 'Tersedia';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: _statusRoom == "Tersedia"
                                        ? Colors.green[50]
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _statusRoom == "Tersedia"
                                          ? Colors.green[300]!
                                          : Colors.grey[300]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: _statusRoom == "Tersedia"
                                            ? Colors.green[600]
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Tersedia',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: _statusRoom == "Tersedia"
                                              ? Colors.green[800]
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _statusRoom = 'terisi';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: _statusRoom == "terisi"
                                        ? Colors.red[50]
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _statusRoom == 'terisi'
                                          ? Colors.red[300]!
                                          : Colors.grey[300]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: _statusRoom == 'terisi'
                                            ? Colors.red[600]
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Terisi',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: _statusRoom == 'terisi'
                                              ? Colors.red[800]
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 18),
                      Row(
                        children: [
                          // Tombol batal
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: Colors.grey[500]!),
                              ),
                              child: Text(
                                'Batal',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Tombol simpan
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _simpanKamar,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: colorsApp.active,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      'Simpan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      isEditMode
                          ? _statusRoom == 'terisi'
                              ? Container()
                              : Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _hapusKamar,
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12),
                                          backgroundColor: colorsApp.error,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text(
                                          'hapus kamar',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                          : Container()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
