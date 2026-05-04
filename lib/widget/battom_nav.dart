import 'package:flutter/material.dart';
import 'package:project_toko/models/user_login.dart';

class BottomNav extends StatefulWidget {
  final int activePage;

  const BottomNav(this.activePage, {super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  UserLogin userLogin = UserLogin();
  String? role;
  bool isChecking = true;

  // ================= GET DATA LOGIN =================
  Future<void> getDataLogin() async {
    var user = await userLogin.getUserLogin();

    if (!mounted) return;

    if (user.status == true) {
      setState(() {
        role = user.role;
        isChecking = false;
      });
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getDataLogin();
  }

  // ================= NAVIGATION =================
  void getLink(int index) {
    if (role == "admin") {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/produk');
      }
    } else if (role == "kasir") {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/transaksi');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Saat masih cek login, jangan tampilkan apa-apa dulu
    if (isChecking) {
      return const SizedBox();
    }

    // Warna tema gelap
    const Color darkBgColor = Color(0xFF1F222A); 
    const Color activeColor = Color(0xFFE50914);
    const Color inactiveColor = Colors.white38;

    if (role == "admin") {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Penting agar background warna muncul penuh
        backgroundColor: darkBgColor, // Mengubah warna putih jadi gelap
        selectedItemColor: activeColor,
        unselectedItemColor: inactiveColor,
        currentIndex: widget.activePage,
        onTap: getLink,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits_sharp),
            label: 'Produk',
          ),
        ],
      );
    }

    if (role == "kasir") {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: darkBgColor,
        selectedItemColor: activeColor,
        unselectedItemColor: inactiveColor,
        currentIndex: widget.activePage,
        onTap: getLink,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Pesan',
          ),
        ],
      );
    }

    return const SizedBox();
  }
}