import 'package:flutter/material.dart';
import 'package:project_toko/models/user_login.dart';
import 'package:project_toko/services/user.dart';
import 'package:project_toko/widget/battom_nav.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final UserLogin userLogin = UserLogin();

  String? nama;
  String? role;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserLogin();
  }

  Future<void> getUserLogin() async {
    final user = await userLogin.getUserLogin();
    if (!mounted) return;
    print("USER LOGIN: ${user}");
    if (user.status == true) {
      setState(() {
        nama = user.name;
        role = user.role;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> handleLogout() async {
    await userLogin.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20), // Background gelap utama

      // ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'kasir',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: 'apps',
                style: TextStyle(
                  color: Color(0xFFE50914),
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1F222A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout,
                color: Color(0xFFE50914),
                size: 20,
              ),
            ),
            onPressed: handleLogout,
          ),
          const SizedBox(width: 12),
        ],
      ),

      // ===== BODY =====
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE50914)),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== HEADER CARD =====
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F222A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white12,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0xFF2A1518),
                          child: Text(
                            (nama != null && nama!.isNotEmpty)
                                ? nama![0].toUpperCase()
                                : '-',
                            style: const TextStyle(
                              color: Color(0xFFE50914),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Halo, ${nama ?? '-'}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A1518),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "Role: ${role ?? '-'}",
                                  style: const TextStyle(
                                    color: Color(0xFFE50914),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ===== SECTION TITLE =====
                  const Text(
                    "Ringkasan",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ===== SUMMARY =====
                  Row(
                    children: [
                      _summaryCard(
                        title: "Produk",
                        value: "120",
                        icon: Icons.inventory_2_outlined,
                        color: const Color(0xFF2A1518),
                        iconColor: const Color(0xFFE50914),
                      ),
                      const SizedBox(width: 16),
                      _summaryCard(
                        title: "Transaksi",
                        value: "57",
                        icon: Icons.receipt_long_outlined,
                        color: const Color(0xFF2A1518),
                        iconColor: const Color(0xFFE50914),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ===== ACCOUNT INFO =====
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F222A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white12,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Informasi Akun",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _infoRow("Nama", nama ?? "-"),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: Colors.white12),
                        ),
                        _infoRow("Role", role ?? "-"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ===== LOGOUT BUTTON =====
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: handleLogout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE50914),
                        side: const BorderSide(
                          color: Color(0xFFE50914),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text(
                        "KELUAR (LOGOUT)",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

      // ===== BOTTOM NAV =====
      bottomNavigationBar: BottomNav(0),
    );
  }

  // ===== SUMMARY CARD =====
  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1F222A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== INFO ROW =====
  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}