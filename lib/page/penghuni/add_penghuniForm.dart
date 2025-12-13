import 'package:flutter/material.dart';
import 'package:may_kos/widgets/widget_textFormField.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPenghuniForm extends StatefulWidget {
  const AddPenghuniForm({super.key});

  @override
  State<AddPenghuniForm> createState() => _AddPenghuniFormState();
}

class _AddPenghuniFormState extends State<AddPenghuniForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRoom;
  final _namaController = TextEditingController();
  final _nomorHpController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _nomorHpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tambah Penghuni Baru',
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
        // form

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

        const SizedBox(height: 20),

        // Tombol simpan

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              'Simpan',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.green[800],
            ),
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  List<String> availableRooms = [
    'Kamar A-101',
    'Kamar A-102',
    'Kamar B-201',
    'Kamar B-202'
  ];
}
