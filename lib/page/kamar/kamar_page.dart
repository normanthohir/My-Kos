import 'package:flutter/material.dart';
import 'package:may_kos/page/kamar/kamar_detail_page.dart';

class KamarPage extends StatefulWidget {
  const KamarPage({Key? key}) : super(key: key);

  @override
  State<KamarPage> createState() => _KamarPageState();
}

class _KamarPageState extends State<KamarPage> {
  List<Room> rooms = [
    Room(roomNumber: '101', isOccupied: false, roomType: 'Standard'),
    Room(roomNumber: '102', isOccupied: true, roomType: 'Deluxe'),
    Room(roomNumber: '103', isOccupied: false, roomType: 'Suite'),
    Room(roomNumber: '104', isOccupied: true, roomType: 'Standard'),
    Room(roomNumber: '105', isOccupied: false, roomType: 'Deluxe'),
    Room(roomNumber: '201', isOccupied: false, roomType: 'Standard'),
    Room(roomNumber: '202', isOccupied: true, roomType: 'Suite'),
    Room(roomNumber: '203', isOccupied: false, roomType: 'Deluxe'),
    Room(roomNumber: '204', isOccupied: true, roomType: 'Standard'),
    Room(roomNumber: '205', isOccupied: false, roomType: 'Suite'),
  ];

  String filterStatus = 'Semua';

  // Fungsi untuk menambah kamar baru
  void _addNewRoom(Room newRoom) {
    setState(() {
      rooms.add(newRoom);
    });
  }

  // Fungsi untuk mengedit kamar yang sudah ada
  void _updateRoom(int index, Room updatedRoom) {
    setState(() {
      rooms[index] = updatedRoom;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Room> filteredRooms = rooms.where((room) {
      if (filterStatus == 'Semua') return true;
      if (filterStatus == 'Kosong') return !room.isOccupied;
      return room.isOccupied;
    }).toList();

    int totalRooms = rooms.length;
    int occupiedRooms = rooms.where((room) => room.isOccupied).length;
    int availableRooms = totalRooms - occupiedRooms;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Daftar Kamar',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[800],
        elevation: 1,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      'Total Kamar',
                      '$totalRooms',
                      Colors.blue[800]!,
                    ),
                    _buildStatCard(
                      'Terisi',
                      '$occupiedRooms',
                      Colors.orange[700]!,
                    ),
                    _buildStatCard(
                      'Kosong',
                      '$availableRooms',
                      Colors.green[700]!,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Filter Status:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildFilterChip('Semua', filterStatus == 'Semua'),
                    _buildFilterChip('Kosong', filterStatus == 'Kosong'),
                    _buildFilterChip('Terisi', filterStatus == 'Terisi'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: filteredRooms.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman detail untuk mengedit kamar yang dipilih
                      _navigateToRoomDetail(filteredRooms[index], index);
                    },
                    child: _buildRoomCard(filteredRooms[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman detail untuk menambah kamar baru
          _navigateToRoomDetail(null, -1);
        },
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Fungsi untuk navigasi ke halaman detail kamar
  void _navigateToRoomDetail(Room? room, int index) async {
    // Jika room tidak null, maka mode edit, jika null maka mode tambah
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KamarDetailPage(room: room),
      ),
    );

    // Jika result tidak null (user menyimpan data)
    if (result != null) {
      // Jika index == -1, berarti menambah kamar baru, selainnya mengedit
      if (index == -1) {
        _addNewRoom(result);
      } else {
        // Untuk edit, kita perlu mencari index asli di list rooms
        // Karena filteredRooms mungkin berbeda urutan
        int originalIndex =
            rooms.indexWhere((r) => r.roomNumber == room!.roomNumber);
        if (originalIndex != -1) {
          _updateRoom(originalIndex, result);
        }
      }
    }
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.blue[800],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
        fontWeight: FontWeight.w500,
      ),
      onSelected: (selected) {
        setState(() {
          filterStatus = label;
        });
      },
    );
  }

  Widget _buildRoomCard(Room room) {
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
              color: room.isOccupied ? Colors.red[50] : Colors.green[50],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kamar',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  room.roomNumber,
                  style: const TextStyle(
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
                      color: Colors.blue[800],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      room.roomType,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        room.isOccupied ? Colors.red[100] : Colors.green[100],
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
                          color: room.isOccupied
                              ? Colors.red[600]
                              : Colors.green[600],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        room.isOccupied ? 'Terisi' : 'Kosong',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: room.isOccupied
                              ? Colors.red[800]
                              : Colors.green[800],
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
                color: room.isOccupied
                    ? Colors.red.withOpacity(0.2)
                    : Colors.green.withOpacity(0.2),
              ),
              child: Icon(
                room.isOccupied ? Icons.person : Icons.person_outline,
                color: room.isOccupied ? Colors.red[600] : Colors.green[600],
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Room {
  String roomNumber;
  bool isOccupied;
  String roomType;

  Room({
    required this.roomNumber,
    required this.isOccupied,
    required this.roomType,
  });
}
