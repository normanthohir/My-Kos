import 'package:flutter/material.dart';
import 'package:may_kos/data/databases/database_helper.dart';
import 'package:may_kos/page/dashboard/dashboard_page.dart';

void main() async {
  // binding Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // databases database untuk memicu fungsi _onCreate
  final dbHelper = DatabaseHelper();
  await dbHelper.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}
