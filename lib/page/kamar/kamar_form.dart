import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/data/databases/database_helper.dart';
import 'package:may_kos/data/models/kamar.dart';
import 'package:may_kos/widgets/widget_textFormField.dart';

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

  void _simpanKamar() async {
    if (_formKey.currentState!.validate()) {
      Kamar dataKamar = Kamar(
        id: widget.room?.id,
        nomorKamar: _roomNumberController.text,
        hargaKamar: double.parse(_hargaController.text),
        typeKamar: _selectedRoomType,
        statusKamar: _statusRoom == 'Tersedia' ? 'Tersedia' : 'terisi',
      );

      if (widget.room == null) {
        await DatabaseHelper().insertKamar(dataKamar);
      } else {
        widget.room!.nomorKamar = dataKamar.nomorKamar;
        widget.room!.hargaKamar = dataKamar.hargaKamar;
        widget.room!.typeKamar = dataKamar.typeKamar;
        widget.room!.statusKamar = dataKamar.statusKamar;

        await DatabaseHelper().updateKamar(widget.room!);
      }
      Navigator.pop(context);
    }
  }

  void _hapusKamar() async {
    await DatabaseHelper().deleteKamar(widget.room!.id!);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    _roomNumberController =
        TextEditingController(text: widget.room?.nomorKamar ?? '');
    _selectedRoomType = widget.room?.typeKamar ?? 'Standard';
    _statusRoom = widget.room?.statusKamar ?? 'Tersedia';
    _hargaController =
        TextEditingController(text: widget.room?.hargaKamar.toString() ?? '');
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
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: colorsApp.active,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
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
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
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
    );
  }
}
