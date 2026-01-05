import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/data/databases/database_helper.dart';
import 'package:may_kos/data/models/kamar.dart';
import 'package:may_kos/data/models/penghuni.dart';
import 'package:may_kos/widgets/widget_CurrencyInputFormatter.dart';
import 'package:may_kos/widgets/widget_textFormField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PenghuniForm extends StatefulWidget {
  final Penghuni? penghuni;
  final bool isEditMode;

  const PenghuniForm({
    super.key,
    this.penghuni,
    this.isEditMode = false,
  });

  @override
  State<PenghuniForm> createState() => _PenghuniFormState();
}

class _PenghuniFormState extends State<PenghuniForm> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedKamarId;
  final _namaController = TextEditingController();
  final _nomorHpController = TextEditingController();
  final _hargaController = TextEditingController();

  List<Kamar> _allAvailableRooms = [];
  late Future<List<Kamar>> _kamarFuture;

  @override
  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.penghuni != null) {
      _namaController.text = widget.penghuni!.namaPenghuni;
      // _nomorHpController.text = widget.penghuni!.nomorhanphone;
      _selectedKamarId = widget.penghuni!.kamarId;
      _idKamarAsal = widget.penghuni!.kamarId; // TAMBAHKAN INI

      if (widget.penghuni!.hargaKamar != null) {
        _hargaController.text = widget.penghuni!.hargaKamar!.toInt().toString();
      }
    }
    _kamarFuture = DatabaseHelper().getKamarUntukEdit(widget.penghuni?.kamarId);
  }

  int? _idKamarAsal; // Variabel untuk mencatat kamar lama
// Saat tombol simpan ditekan
  void _simpanPenghuni() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final db = DatabaseHelper();

      Penghuni dataPenghuni = Penghuni(
        id: widget.penghuni?.id, // ID tetap untuk proses Update
        namaPenghuni: _namaController.text.trim(),
        statusPenghuni: true, // Default aktif saat simpan/edit di form ini
        tanggalMasuk: widget.penghuni?.tanggalMasuk ?? DateTime.now(),
        kamarId: _selectedKamarId,
      );

      // 3. Proses Simpan atau Update
      bool isEdit = widget.isEditMode;

      if (isEdit) {
        // Pastikan variabel _idKamarAsal sudah diisi di initState
        await db.updatePenghuni(dataPenghuni, _idKamarAsal);
      } else {
        await db.insertPenghuni(dataPenghuni);
      }

      // 4. Notifikasi Berhasil
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: isEdit
              ? "Data penghuni berhasil diperbarui"
              : "Penghuni berhasil ditambahkan",
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint("Error Simpan Penghuni: $e");

      // 6. Notifikasi Gagal
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: "Gagal menyimpan data: $e",
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nomorHpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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
                        widget.isEditMode
                            ? 'Edit Data Penghuni'
                            : 'Tambah Penghuni Baru',
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

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SharedTextFormField(
                        Controller: _namaController,
                        labelText: 'Nama Lengkap',
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SharedTextFormField(
                        Controller: _nomorHpController,
                        labelText: 'Nomor HP',
                        prefixIcon: const Icon(
                          Icons.phone_android_outlined,
                        ),
                      ),

                      const SizedBox(height: 15),

                      FutureBuilder<List<Kamar>>(
                        future: _kamarFuture,
                        builder: (context, snapshot) {
                          // 1. Cek loading
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            );
                          }

                          // 2. Ambil data secara aman (Gunakan list kosong jika null)
                          final listKamar = snapshot.data ?? [];

                          // Simpan ke variabel global agar bisa diakses di onChanged
                          _allAvailableRooms = listKamar;

                          return DropdownButtonFormField<int>(
                            value: _selectedKamarId,
                            decoration: InputDecoration(
                              labelText: 'Pilih Kamar',
                              prefixIcon:
                                  const Icon(Icons.meeting_room_outlined),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            // Mencegah error jika _selectedKamarId tidak ada di listKamar
                            items: listKamar.map((kamar) {
                              return DropdownMenuItem<int>(
                                value: kamar.id,
                                child: Text("Kamar ${kamar.nomorKamar}"),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                _selectedKamarId = value;

                                // Gunakan try-catch atau findIndex agar lebih aman
                                try {
                                  final selectedRoomData = _allAvailableRooms
                                      .firstWhere((r) => r.id == value);
                                  _hargaController.text = selectedRoomData
                                      .hargaKamar
                                      .toInt()
                                      .toString();
                                } catch (e) {
                                  print("Kamar tidak ditemukan");
                                }
                              });
                            },
                            validator: (value) =>
                                value == null ? 'Silakan pilih kamar' : null,
                          );
                        },
                      ),

                      const SizedBox(height: 15),
                      SharedTextFormField(
                        Controller: _hargaController,
                        labelText: 'Harga bulanan',
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter(),
                        ],
                        prefixIcon: const Icon(
                          Icons.attach_money,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tombol simpan/update
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _simpanPenghuni,
                          child: Text(
                            widget.isEditMode ? 'Update' : 'Simpan',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: colorsApp.success,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
