import 'package:flutter/material.dart';

class PenghuniPage extends StatelessWidget {
  const PenghuniPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data dummy penghuni
    List<Resident> residents = [
      Resident(
        id: '1',
        nama: 'Budi Santoso',
        hp: '081234567890',
        kamar: '101',
        status: 'aktif',
        tanggalMasuk: '15 Jan 2024',
        foto: 'https://randomuser.me/api/portraits/men/1.jpg',
      ),
      Resident(
        id: '2',
        nama: 'Siti Aminah',
        hp: '082345678901',
        kamar: '102',
        status: 'aktif',
        tanggalMasuk: '20 Feb 2024',
        foto: 'https://randomuser.me/api/portraits/women/2.jpg',
      ),
      Resident(
        id: '3',
        nama: 'Ahmad Fauzi',
        hp: '083456789012',
        kamar: '104',
        status: 'aktif',
        tanggalMasuk: '10 Mar 2024',
        foto: 'https://randomuser.me/api/portraits/men/3.jpg',
      ),
      Resident(
        id: '4',
        nama: 'Dewi Lestari',
        hp: '084567890123',
        kamar: '201',
        status: 'keluar',
        tanggalMasuk: '01 Des 2023',
        tanggalKeluar: '14 Jan 2024',
        foto: 'https://randomuser.me/api/portraits/women/4.jpg',
      ),
      Resident(
        id: '5',
        nama: 'Rudi Hartono',
        hp: '085678901234',
        kamar: '202',
        status: 'keluar',
        tanggalMasuk: '15 Nov 2023',
        tanggalKeluar: '19 Feb 2024',
        foto: 'https://randomuser.me/api/portraits/men/5.jpg',
      ),
      Resident(
        id: '6',
        nama: 'Maya Indah',
        hp: '086789012345',
        kamar: '103',
        status: 'aktif',
        tanggalMasuk: '05 Apr 2024',
        foto: 'https://randomuser.me/api/portraits/women/6.jpg',
      ),
      Resident(
        id: '7',
        nama: 'Fajar Nugraha',
        hp: '087890123456',
        kamar: '105',
        status: 'aktif',
        tanggalMasuk: '12 Apr 2024',
        foto: 'https://randomuser.me/api/portraits/men/7.jpg',
      ),
      Resident(
        id: '8',
        nama: 'Rina Melati',
        hp: '088901234567',
        kamar: '203',
        status: 'keluar',
        tanggalMasuk: '10 Okt 2023',
        tanggalKeluar: '15 Mar 2024',
        foto: 'https://randomuser.me/api/portraits/women/8.jpg',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header dengan statistik
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            decoration: BoxDecoration(
              color: Colors.blue[800],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue[900]!.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul dan tombol tambah
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Data Penghuni',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total ${residents.length} penghuni terdaftar',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                    // Tombol tambah penghuni
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Aksi tambah penghuni
                        },
                        icon: Icon(
                          Icons.person_add,
                          color: Colors.blue[800],
                        ),
                        tooltip: 'Tambah Penghuni',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Statistik card
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard(
                      context,
                      'Aktif',
                      residents
                          .where((r) => r.status == 'aktif')
                          .length
                          .toString(),
                      Colors.green,
                      Icons.person,
                    ),
                    _buildStatCard(
                      context,
                      'Keluar',
                      residents
                          .where((r) => r.status == 'keluar')
                          .length
                          .toString(),
                      Colors.orange,
                      Icons.logout,
                    ),
                    _buildStatCard(
                      context,
                      'Kamar',
                      '8',
                      Colors.purple,
                      Icons.hotel,
                    ),
                    _buildStatCard(
                      context,
                      'Baru',
                      '3',
                      Colors.red,
                      Icons.new_releases,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search dan filter bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari nama penghuni...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          icon: Icon(Icons.search, color: Colors.grey[500]),
                        ),
                      ),
                    ),
                  ),
                  // Filter button
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Aksi filter
                      },
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tab status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatusTab('Semua', true),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatusTab('Aktif', false),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatusTab('Keluar', false),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // List penghuni
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: residents.length,
              itemBuilder: (context, index) {
                return _buildResidentCard(residents[index]);
              },
            ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi tambah penghuni
        },
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.person_add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Widget untuk statistik card
  Widget _buildStatCard(BuildContext context, String title, String value,
      Color color, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
            child: Icon(icon, color: color, size: 20),
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

  // Widget untuk status tab
  Widget _buildStatusTab(String label, bool isActive) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue[800] : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? Colors.blue[800]! : Colors.grey[300]!,
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
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  // Widget untuk resident card
  Widget _buildResidentCard(Resident resident) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Foto profil
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: resident.foto.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(resident.foto),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: resident.foto.isEmpty ? Colors.blue[100] : null,
              ),
              child: resident.foto.isEmpty
                  ? Center(
                      child: Text(
                        resident.nama[0],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    )
                  : null,
            ),
          ),

          // Informasi penghuni
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
                        resident.nama,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: resident.status == 'aktif'
                              ? Colors.green[50]
                              : Colors.orange[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: resident.status == 'aktif'
                                ? Colors.green[100]!
                                : Colors.orange[100]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: resident.status == 'aktif'
                                    ? Colors.green[600]
                                    : Colors.orange[600],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              resident.status == 'aktif' ? 'Aktif' : 'Keluar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: resident.status == 'aktif'
                                    ? Colors.green[800]
                                    : Colors.orange[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Nomor HP
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        resident.hp,
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
                        color: Colors.blue[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Kamar ${resident.kamar}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Tanggal
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Masuk: ${resident.tanggalMasuk}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (resident.status == 'keluar' &&
                          resident.tanggalKeluar != null) ...[
                        const SizedBox(width: 10),
                        Icon(
                          Icons.logout,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Keluar: ${resident.tanggalKeluar}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
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
                const PopupMenuItem(
                  value: 'detail',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Detail'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                if (resident.status == 'aktif')
                  const PopupMenuItem(
                    value: 'checkout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 18, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('Check-out'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Hapus'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                // Aksi berdasarkan pilihan
                if (value == 'detail') {
                  // Navigasi ke detail
                } else if (value == 'edit') {
                  // Navigasi ke edit
                } else if (value == 'checkout') {
                  // Proses checkout
                } else if (value == 'delete') {
                  // Hapus data
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Resident {
  final String id;
  final String nama;
  final String hp;
  final String kamar;
  final String status;
  final String tanggalMasuk;
  final String? tanggalKeluar;
  final String foto;

  Resident({
    required this.id,
    required this.nama,
    required this.hp,
    required this.kamar,
    required this.status,
    required this.tanggalMasuk,
    this.tanggalKeluar,
    this.foto = '',
  });
}
