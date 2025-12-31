import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/page/kamar/kamar_page.dart';
import 'package:may_kos/widgets/widget_CurrencyInputFormatter.dart';
import 'package:may_kos/widgets/widget_textFormField.dart';

class KamarForm extends StatefulWidget {
  final Room? room; // jika null, maka mode tambah

  const KamarForm({
    Key? key,
    this.room,
  }) : super(key: key);

  @override
  State<KamarForm> createState() => _KamarFormState();
}

class _KamarFormState extends State<KamarForm> {
  late TextEditingController roomNumberController;
  late String selectedRoomType;
  late bool isOccupied;
  late TextEditingController hargaController;

  // List tipe kamar yang tersedia
  final List<String> roomTypes = ['Standard', 'Deluxe', 'Suite'];

  @override
  void initState() {
    super.initState();
    // Jika widget.room tidak null (edit), gunakan data yang ada, jika null (tambah), gunakan default
    roomNumberController =
        TextEditingController(text: widget.room?.roomNumber ?? '');
    selectedRoomType = widget.room?.roomType ?? 'Standard';
    isOccupied = widget.room?.isOccupied ?? false;
    hargaController = TextEditingController(text: widget.room?.harga ?? '');
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        ? 'Edit Kamar ${widget.room!.roomNumber}'
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
                    Controller: roomNumberController,
                    labelText: 'Nomor kamar',
                  ),

                  const SizedBox(height: 20),

                  // Pilih tipe kamar
                  DropdownButtonFormField<String>(
                    value: selectedRoomType,
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
                        selectedRoomType = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  SharedTextFormField(
                    Controller: hargaController,
                    labelText: 'Harga kamar',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Iconsax.wallet_1),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter(),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Status kamar (hanya untuk edit, untuk tambah default kosong)
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
                                isOccupied = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              decoration: BoxDecoration(
                                color: !isOccupied
                                    ? Colors.green[50]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: !isOccupied
                                      ? Colors.green[300]!
                                      : Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.circle_outlined,
                                    color: !isOccupied
                                        ? Colors.green[600]
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Kosong',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: !isOccupied
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
                                isOccupied = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              decoration: BoxDecoration(
                                color: isOccupied
                                    ? Colors.red[50]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isOccupied
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
                                    color: isOccupied
                                        ? Colors.red[600]
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Terisi',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isOccupied
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
                          onPressed: _saveRoom,
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
                      ? isOccupied
                          ? Container()
                          : Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _deleteRoom,
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      backgroundColor: colorsApp.error,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
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
    );
  }

  void _saveRoom() {
    // Validasi input
    if (roomNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor kamar harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Buat objek Room baru dengan data dari form
    Room newRoom = Room(
      roomNumber: roomNumberController.text,
      roomType: selectedRoomType,
      isOccupied: isOccupied,
      harga: hargaController.text,
    );

    // Kembalikan ke halaman sebelumnya dengan data kamar baru
    Navigator.pop(context, newRoom);
  }

  void _deleteRoom() {
    Navigator.pop(context, 'delete');
  }

  @override
  void dispose() {
    roomNumberController.dispose();
    super.dispose();
  }
}
