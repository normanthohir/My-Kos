import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:may_kos/config/theme.dart';
import 'package:may_kos/data/databases/database_helper.dart';
import 'package:may_kos/data/models/pembayaran.dart';
import 'package:may_kos/data/models/penghuni.dart';
import 'package:may_kos/utils/date_picker.dart';
import 'package:may_kos/widgets/widget_CurrencyInputFormatter.dart';
import 'package:may_kos/widgets/widget_textFormField.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PembayranForm extends StatefulWidget {
  // 1. Tambahkan baris ini untuk menampung data
  final Map<String, dynamic>? initialData;

  // 2. Tambahkan widget.initialData ke constructor
  const PembayranForm({super.key, this.initialData});
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
  int? _selectedKamarId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Sekarang widget.initialData sudah bisa dikenali karena sudah didefinisikan di atas
    if (widget.initialData != null) {
      final data = widget.initialData!;

      // Isi Controller
      _jumlahcontroller.text = data['jumlah'].toInt().toString();
      _penghuniController.text =
          "${data['nama']} (Kamar ${data['nomor_kamar']})";

      // Isi format tanggal hari ini
      _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      _selectedDate = DateTime.now();

      // Parsing Periode (Bulan & Tahun) dari tagihan
      if (data['bulan'] != null && data['tahun'] != null) {
        _selectedPeriode = DateTime(
            int.tryParse(data['tahun'].toString()) ?? DateTime.now().year,
            int.tryParse(data['bulan'].toString()) ?? DateTime.now().month);
        _priodeController.text =
            DateFormat('MMMM yyyy').format(_selectedPeriode!);
      }

      // Ambil ID dari data tagihan
      _selectedPenghuniId = data['penghuni_id'];
      _selectedKamarId = data['kamar_id'];
    }
  }

  void _simpanPembayaran() async {
    if (!_formKey.currentState!.validate()) return;

    String cleanAmount =
        _jumlahcontroller.text.replaceAll(RegExp(r'[^0-9]'), '');

    String fullText = _penghuniController.text;
    String namaOnly = fullText.split(' (')[0];
    String roomOnly = fullText.contains('Kamar ')
        ? fullText.split('Kamar ')[1].replaceAll(')', '')
        : '';
    Pembayaran dataBaru = Pembayaran(
      namaPenghuniPembayaran: namaOnly,
      nomorKamarPembayar: roomOnly,
      jumlahPembayaran: double.parse(cleanAmount),
      metodeBayar: _selectedTypepembayaran ?? 'Tunai',
      periodePembayaran: _selectedPeriode != null
          ? _selectedPeriode!.toIso8601String()
          : DateTime.now().toIso8601String(),
      tanggalPembayaran: _selectedDate != null
          ? _selectedDate!.toIso8601String()
          : DateTime.now().toIso8601String(),
      statusPembayaran: 'Lunas',
      kamarId: _selectedKamarId,
      penghuniId: _selectedPenghuniId,
    );

    try {
      await DatabaseHelper().insertPembayaran(dataBaru);
      if (mounted) {
        Navigator.pop(context, true);
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Pembayaran Berhasil!",
          ),
        );
      }
    } catch (e) {
      debugPrint("Error simpan: $e");
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: "Pembayaran Gagal!",
        ),
      );
    }
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
          child: Form(
            key: _formKey,
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
                          readOnly: true,
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Pilih metode pembayaran'; // Pesan error jika kosong
                            }
                            return null;
                          },
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
                                  onPressed: _simpanPembayaran,
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
              // Handle bar
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
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: DatabaseHelper()
                      .getPenghuniAktif(), // Ambil data langsung
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("Tidak ada penghuni aktif"));
                    }

                    final dataPenghuni = snapshot.data!;

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: dataPenghuni.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final p = dataPenghuni[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorsApp.primary.withOpacity(0.1),
                            child: Text(p['nomor_kamar'].toString(),
                                style: TextStyle(
                                    color: colorsApp.primary,
                                    fontWeight: FontWeight.bold)),
                          ),
                          title: Text(p['nama_penghuni'],
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600)),
                          subtitle: Text("Tipe: ${p['type_kamar']}"),
                          trailing: Text(
                            NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp ',
                                    decimalDigits: 0)
                                .format(p['harga_kamar']),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.green,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedPenghuniId = p['id'];
                              _selectedKamarId = p[
                                  'kamar_id']; // Jika Anda perlu simpan ID Kamar juga
                              _jumlahcontroller.text =
                                  p['harga_kamar'].toInt().toString();
                              _penghuniController.text =
                                  "${p['nama_penghuni']} (Kamar ${p['nomor_kamar']})";
                            });
                            Navigator.pop(context);
                          },
                        );
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
