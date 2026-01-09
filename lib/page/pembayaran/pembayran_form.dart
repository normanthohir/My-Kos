import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/data/models/penghuni.dart';
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
  final TextEditingController _penghuniController = TextEditingController();
  String? _selectedTypepembayaran;
  DateTime? _selectedDate;
  DateTime? _selectedPeriode;
  int? _selectedPenghuniId;
  late Future<List<Penghuni>> _penghuniFuture;
  List<Penghuni> _allAvailablepenghunis = [];

  List<Penghuni> _penghuniList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                        prefixIcon: Icon(Iconsax.dollar_circle),
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
                        value: _selectedTypepembayaran,
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
                        onChanged: (Value) {
                          setState(() {
                            _selectedTypepembayaran = Value;
                          });
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

              FutureBuilder<List<Penghuni>>(
                future: _penghuniFuture,
                // initialData: InitialData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    );
                  }

                  // 2. Ambil data secara aman (Gunakan list kosong jika null)
                  final penghuni = snapshot.data ?? [];

                  // Simpan ke variabel global agar bisa diakses di onChanged
                  _allAvailablepenghunis = penghuni;

                  return Expanded(
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      leading: CircleAvatar(
                        backgroundColor: colorsApp.primary.withOpacity(0.1),
                        child: Text(penghuni.toString(),
                            style: TextStyle(
                                color: colorsApp.primary,
                                fontWeight: FontWeight.bold)),
                      ),
                      title: Text(penghuni.namaPenghuni,
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        "Tipe: ${(penghuni.typeKamar)}",
                        style: GoogleFonts.poppins(),
                      ),
                      trailing: Text(
                        NumberFormat.decimalPattern('id')
                            .format(penghuni.hargaKamar),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.green,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedPenghuniId = penghuni.id;
                          // Ini yang Anda minta: Otomatis isi harga
                          _jumlahcontroller.text =
                              penghuni.hargaKamar.toString();
                          // Jika Anda punya controller nama penghuni untuk ditampilkan di UI
                          _penghuniController.text =
                              "${penghuni.namaPenghuni} (${penghuni.nomorKamar})";
                        });
                        Navigator.pop(context);
                      },
                    );
                  );
                },
              ),
              // List Penghuni
              // Expanded(
              //   child: ListView.separated(
              //     padding: EdgeInsets.symmetric(horizontal: 16),
              //     itemCount: _penghuniList.length,
              //     separatorBuilder: (context, index) => Divider(height: 1),
              //     itemBuilder: (context, index) {
              //       final penghuni = _penghuniList[index];

              //       return ListTile(
              //         contentPadding:
              //             EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              //         leading: CircleAvatar(
              //           backgroundColor: colorsApp.primary.withOpacity(0.1),
              //           child: Text(penghuni.nomorKamar.toString(),
              //               style: TextStyle(
              //                   color: colorsApp.primary,
              //                   fontWeight: FontWeight.bold)),
              //         ),
              //         title: Text(penghuni.namaPenghuni,
              //             style:
              //                 GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              //         subtitle: Text(
              //           "Tipe: ${(penghuni.typeKamar)}",
              //           style: GoogleFonts.poppins(),
              //         ),
              //         trailing: Text(
              //           NumberFormat.decimalPattern('id')
              //               .format(penghuni.hargaKamar),
              //           style: GoogleFonts.poppins(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 13,
              //             color: Colors.green,
              //           ),
              //         ),
              //         onTap: () {
              //           setState(() {
              //             _selectedPenghuniId = penghuni.id;
              //             // Ini yang Anda minta: Otomatis isi harga
              //             _jumlahcontroller.text =
              //                 penghuni.hargaKamar.toString();
              //             // Jika Anda punya controller nama penghuni untuk ditampilkan di UI
              //             _penghuniController.text =
              //                 "${penghuni.namaPenghuni} (${penghuni.nomorKamar})";
              //           });
              //           Navigator.pop(context);
              //         },
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
