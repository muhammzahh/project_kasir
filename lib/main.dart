import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'package:project_toko/views/dashboard_view.dart';
import 'package:project_toko/views/produk_view.dart';
import 'package:project_toko/views/register_user_view.dart';
import 'package:project_toko/views/transaksi_view.dart';
import 'package:project_toko/views/login_view.dart';
import 'package:project_toko/views/cart_screen.dart';
import 'package:project_toko/views/history_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ===== FIX SQLITE UNTUK WINDOWS/LINUX/MACOS =====
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/register',
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterUserView(),
        '/dashboard': (context) => const DashboardView(),
        '/produk': (context) => const ProdukView(),
        '/transaksi': (context) => const TransaksiView(),
        '/cartScreen': (context) => const CartScreen(),
        '/history': (context) => const HistoryView(),
      },
    );
  }
}