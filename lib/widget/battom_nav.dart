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
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, '/history');
      }
    } else if (role == "user") {
      // ===== Sesuai modul: Dashboard → Pesan → History =====
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/transaksi');
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, '/history');
      }
    }
  }

  // ===== CLAMP: pastikan index tidak melebihi jumlah item =====
  int _safeIndex(int itemCount) {
    return widget.activePage.clamp(0, itemCount - 1);
  }

  @override
  Widget build(BuildContext context) {
    if (isChecking) return const SizedBox();

    const Color darkBgColor = Color(0xFF1F222A);
    const Color activeColor = Color(0xFFE50914);
    const Color inactiveColor = Colors.white38;

    // ===== ADMIN: Dashboard + Produk (2 item, index 0-1) =====
    if (role == "admin") {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: darkBgColor,
        selectedItemColor: activeColor,
        unselectedItemColor: inactiveColor,
        currentIndex: _safeIndex(2),
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

    // ===== KASIR: Dashboard + Pesan + History (3 item, index 0-2) =====
    if (role == "kasir") {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: darkBgColor,
        selectedItemColor: activeColor,
        unselectedItemColor: inactiveColor,
        currentIndex: _safeIndex(3),
        onTap: getLink,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      );
    }

    // ===== USER: Dashboard + Pesan + History (3 item, index 0-2) — sesuai modul =====
    if (role == "user") {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: darkBgColor,
        selectedItemColor: activeColor,
        unselectedItemColor: inactiveColor,
        currentIndex: _safeIndex(3),
        onTap: getLink,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      );
    }

    return const SizedBox();
  }
}