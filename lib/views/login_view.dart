import 'package:flutter/material.dart';
import 'package:project_toko/services/user.dart';
import 'package:project_toko/widget/alert.dart';
import 'package:project_toko/models/user_login.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final UserService user = UserService();
  final formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isLoading = false;
  bool showpass = true;
  bool isRememberMe = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  // ================= INPUT STYLE (DARK) =================
  InputDecoration darkInput(String hint, IconData icon, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.white54, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFF1F222A), // Warna abu gelap input
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE50914), width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20), // Background utama gelap
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Login to your\nAccount",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 40),

              // ===== FORM LOGIN =====
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: email,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: darkInput("Email", Icons.email_outlined),
                      validator: (v) => v!.isEmpty ? 'Email wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: password,
                      style: const TextStyle(color: Colors.white),
                      obscureText: showpass,
                      decoration: darkInput(
                        "Password",
                        Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            showpass ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white54,
                            size: 20,
                          ),
                          onPressed: () => setState(() => showpass = !showpass),
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? 'Password wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),

                    // ===== REMEMBER ME =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: isRememberMe,
                          activeColor: const Color(0xFFE50914),
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          side: const BorderSide(color: Color(0xFFE50914), width: 2),
                          onChanged: (v) => setState(() => isRememberMe = v!),
                        ),
                        const Text(
                          "Remember me",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ===== BUTTON LOGIN =====
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE50914),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 8,
                          shadowColor: const Color(0xFFE50914).withOpacity(0.4),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ===== DIVIDER =====
              Row(
                children: const [
                  Expanded(child: Divider(color: Colors.white10, thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "or continue with",
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.white10, thickness: 1)),
                ],
              ),

              const SizedBox(height: 24),

              // ===== SOCIAL BUTTONS =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _socialCard(Icons.facebook, Colors.blue),
                  _socialCard(Icons.g_mobiledata_rounded, Colors.white),
                  _socialCard(Icons.apple, Colors.white),
                ],
              ),

              const SizedBox(height: 40),

              // ===== LINK REGISTER =====
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.white60),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color: Color(0xFFE50914),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialCard(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F222A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Icon(icon, color: color, size: 30),
    );
  }

  // ================= LOGIC LOGIN =================
  Future<void> _handleLogin() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final result = await user.loginUser({
        "email": email.text,
        "password": password.text,
      });

      if (!mounted) return;

      if (result.status == true) {
        final token = result.data["token"];
        final userData = result.data["user"];

        await UserLogin(
          status: true,
          token: token,
          id: userData["id"],
          name: userData["nama_user"],
          email: userData["email"],
          role: userData["role"],
        ).prefs();

        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        AlertMessage().showAlert(
          context,
          result.message ?? "Login gagal",
          false,
        );
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      AlertMessage().showAlert(context, "Terjadi kesalahan", false);
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}