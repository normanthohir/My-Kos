import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/utils/date_picker.dart';
import 'package:may_kos/widgets/widget_CurrencyInputFormatter.dart';
import 'package:may_kos/widgets/widget_textFormField.dart';

class PembayranForm extends StatefulWidget {
  const PembayranForm({super.key});

  @override
  State<PembayranForm> createState() => _PembayranFormState();
}

class _PembayranFormState extends State<PembayranForm> {
  final _jumlahcontroller = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _priodeController = TextEditingController();
  // Tambahkan di deretan controller atas
  final TextEditingController _penghuniController = TextEditingController();
  DateTime? _selectedDate;
  DateTime? _selectedPeriode;
  final List<Map<String, dynamic>> _penghuniList = [];
  String? _selectedPenghuniId;

  @override
  void initState() {
    super.initState();
    // 2. Load data saat pertama kali dibuka
    _loadDummyData();
  }

  @override
  void dispose() {
    _penghuniController.dispose();
    _dateController.dispose();
    _jumlahcontroller.dispose();
    _priodeController.dispose();
    super.dispose();
  }

  void _loadDummyData() {
    _penghuniList.addAll([
      {
        'id': 1,
        'nama': 'Siti Milaa',
        'kamar': '112',
        'tipe_kamar': 'Deluxe',
        'no_hp': '081256151551',
        'harga': '600000',
        'tgl_masuk': '30-05-2024',
      },
      {
        'id': 2,
        'nama': 'Ahmad Fauzi',
        'kamar': '122',
        'tipe_kamar': 'Standard',
        'no_hp': '081256151551',
        'harga': '400000',
        'tgl_masuk': '30-05-2024',
      },
      {
        'id': 3,
        'nama': 'Reza Maulana',
        'kamar': '111',
        'tipe_kamar': 'Deluxe',
        'no_hp': '081256151551',
        'harga': '600000',
        'tgl_masuk': '30-05-2024',
      },
      {
        'id': 4,
        'nama': 'Fauzi Maulana',
        'kamar': '112',
        'tipe_kamar': 'Standard',
        'no_hp': '081256151551',
        'harga': '400000',
        'tgl_masuk': '30-05-2024',
      }
    ]);
  }

  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Input pembayaran',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),

                        // Tombol Close
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
                  ],
                ),
              ),

              // body
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  child: Column(
                    children: [
                      // pilih penghuni yang akan dibayar
                      SizedBox(height: 10),
                      SharedTextFormField(
                        Controller: _penghuniController,
                        labelText: 'Pilih Penghuni',
                        readOnly: true, // Wajib true agar tidak bisa diketik
                        prefixIcon: const Icon(Iconsax.personalcard),
                        suffixIcon:
                            const Icon(Icons.arrow_drop_down_circle_outlined),
                        onTap: () {
                          // modal pilih penghuni
                          _showPenghuniPicker();
                        },
                      ),
                      SizedBox(height: 20),
                      // Jumlah pembayaran
                      SharedTextFormField(
                        Controller: _jumlahcontroller,
                        labelText: 'Jumlah Pembayaran',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(Iconsax.wallet_1),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter(),
                        ],
                      ),
                      SizedBox(height: 20),
                      // priode pembayaran
                      SharedTextFormField(
                        Controller: _priodeController,
                        readOnly: true,
                        onTap: () {
                          DatePickerUtil.selectMonthYear(
                            context: context,
                            initialDate: _selectedPeriode,
                            controller: _priodeController,
                            onDateSelected: (date) {
                              setState(() {
                                _selectedPeriode = date;
                              });
                            },
                          );
                        },
                        labelText: 'Priode',
                        prefixIcon: Icon(Iconsax.calendar),
                      ),
                      SizedBox(height: 20),
                      // metod pembayaran
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: 'Metod Pembayaran',
                          prefixIcon: const Icon(Iconsax.wallet_2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'tunai',
                            child: Text('Tunai'),
                          ),
                          DropdownMenuItem(
                            value: 'transfer',
                            child: Text('Transfer'),
                          ),
                        ],
                        onChanged: (value) {
                          // Handle pilihan penghuni di sini
                        },
                      ),
                      SizedBox(height: 20),
                      // Tanggal pembayaran
                      SharedTextFormField(
                        Controller: _dateController,
                        readOnly: true,
                        onTap: () {
                          DatePickerUtil.selectDate(
                            context: context,
                            initialDate: _selectedDate,
                            controller: _dateController,
                            onDateSelected: (date) {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                          );
                        },
                        labelText: 'Tanggal Pembayaran',
                        keyboardType: TextInputType.datetime,
                        prefixIcon: Icon(Iconsax.calendar_1),
                      ),

                      // Tombol Simpan
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorsApp.active,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'Simpan',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPenghuniPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              // Handle bar kecil di atas
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Pilih Penghuni",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              // List Penghuni
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _penghuniList.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = _penghuniList[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      leading: CircleAvatar(
                        backgroundColor: colorsApp.primary.withOpacity(0.1),
                        child: Text(item['kamar'],
                            style: TextStyle(
                                color: colorsApp.primary,
                                fontWeight: FontWeight.bold)),
                      ),
                      title: Text(item['nama'],
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        "Tipe: ${item['tipe_kamar']}",
                        style: GoogleFonts.poppins(),
                      ),
                      trailing: Text(
                        NumberFormat.currency(
                          locale: 'id',
                          symbol: 'Rp ',
                          decimalDigits:
                              0, // Set ke 0 agar tidak ada ,00 di belakang
                        ).format(int.parse(item['harga'].toString())),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.green,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedPenghuniId = item['id'].toString();
                          // Ini yang Anda minta: Otomatis isi harga
                          _jumlahcontroller.text = item['harga'];
                          // Jika Anda punya controller nama penghuni untuk ditampilkan di UI
                          _penghuniController.text =
                              "${item['nama']} (${item['kamar']})";
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
