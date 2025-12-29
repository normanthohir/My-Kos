import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/widgets/widget_CurrencyInputFormatter.dart';
import 'package:may_kos/widgets/widget_textFormField.dart';
import 'package:google_fonts/google_fonts.dart';

class PenghuniForm extends StatefulWidget {
  final Map<String, dynamic>?
      penghuniData; // Data untuk edit, null untuk tambah
  final bool isEditMode;

  const PenghuniForm({
    super.key,
    this.penghuniData,
    this.isEditMode = false,
  });

  @override
  State<PenghuniForm> createState() => _PenghuniFormState();
}

class _PenghuniFormState extends State<PenghuniForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRoom;
  final _namaController = TextEditingController();
  final _nomorHpController = TextEditingController();
  final _hargaController = TextEditingController();

  @override
  @override
  void initState() {
    super.initState();
    // Jika mode edit, isi field dengan data yang ada
    if (widget.isEditMode && widget.penghuniData != null) {
      _namaController.text = widget.penghuniData!['nama'] ?? '';
      _nomorHpController.text = widget.penghuniData!['nomorTelepon'] ?? '';
      _hargaController.text = widget.penghuniData!['harga'] ?? '';

      // Ambil data kamar dari data yang dikirim
      String roomFromData = widget.penghuniData!['kamar'] ?? '';

      // LOGIKA PERBAIKAN:
      // Cek apakah nomor kamar dari data (misal: '112') ada di list availableRooms
      if (availableRooms.contains(roomFromData)) {
        _selectedRoom = roomFromData;
      } else {
        // Jika tidak ada (seperti kasus '112'), tambahkan secara otomatis ke list
        // agar Dropdown tidak error/crash
        if (roomFromData.isNotEmpty) {
          availableRooms.add(roomFromData);
          _selectedRoom = roomFromData;
        }
      }
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isEditMode
                    ? 'Edit Data Penghuni'
                    : 'Tambah Penghuni Baru',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 16),

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

          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Pilih Kamar',
              prefixIcon: const Icon(Icons.meeting_room_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            value: _selectedRoom,
            items: availableRooms
                .map((room) => DropdownMenuItem(
                      value: room,
                      child: Text(room),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedRoom = value;
              });
            },
            validator: (value) => value == null ? 'Silakan pilih kamar' : null,
          ),

          const SizedBox(height: 15),
          SharedTextFormField(
            Controller: _hargaController,
            labelText: 'Harga bulanan',
            keyboardType: TextInputType.number,
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Proses simpan/update data
                  final data = {
                    'nama': _namaController.text,
                    'nomor_hp': _nomorHpController.text,
                    'kamar': _selectedRoom,
                  };

                  // Kirim data kembali ke halaman sebelumnya
                  Navigator.pop(context, data);
                }
              },
              child: Text(
                widget.isEditMode ? 'Update' : 'Simpan',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
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
    );
  }

  List<String> availableRooms = ['101', '102', '201', '202'];
}
