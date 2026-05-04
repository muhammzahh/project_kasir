import 'package:flutter/material.dart';
import 'package:project_toko/views/dashboard_view.dart';

import 'package:project_toko/views/produk_view.dart';
import 'package:project_toko/views/register_user_view.dart';
import 'package:project_toko/views/transaksi_view.dart';
import 'package:project_toko/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      },
    );
  }
}