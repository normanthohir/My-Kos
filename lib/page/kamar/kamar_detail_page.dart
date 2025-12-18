import 'package:flutter/material.dart';
import 'package:may_kos/page/kamar/kamar_page.dart';

class KamarDetailPage extends StatefulWidget {
  final Room? room; // jika null, maka mode tambah

  const KamarDetailPage({
    Key? key,
    this.room,
  }) : super(key: key);

  @override
  State<KamarDetailPage> createState() => _KamarDetailPageState();
}

class _KamarDetailPageState extends State<KamarDetailPage> {
  late TextEditingController roomNumberController;
  late String selectedRoomType;
  late bool isOccupied;

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
  }

  @override
  Widget build(BuildContext context) {
    bool isEditMode = widget.room != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        title: Text(isEditMode
            ? 'Edit Kamar ${widget.room!.roomNumber}'
            : 'Tambah Kamar Baru'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[800],
        elevation: 1,
        actions: [
          // // Tombol simpan di app bar
          // IconButton(
          //   icon: const Icon(Icons.save),
          //   onPressed: _saveRoom,
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input nomor kamar
                    Text(
                      'Nomor Kamar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: roomNumberController,
                      decoration: InputDecoration(
                        hintText: 'Contoh: 101',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue[800]!),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Pilih tipe kamar
                    Text(
                      'Tipe Kamar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedRoomType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue[800]!),
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
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tombol aksi
              Row(
                children: [
                  // Tombol batal
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue[800],
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
            ],
          ),
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
    );

    // Kembalikan ke halaman sebelumnya dengan data kamar baru
    Navigator.pop(context, newRoom);
  }

  @override
  void dispose() {
    roomNumberController.dispose();
    super.dispose();
  }
}
