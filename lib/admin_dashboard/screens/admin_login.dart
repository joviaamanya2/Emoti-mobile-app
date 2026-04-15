import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;

  /// ===============================
  /// OPEN FILAMENT ADMIN DASHBOARD
  /// ===============================
  Future<void> _openFilamentDashboard() async {

    /// ✅ CHANGE THIS TO YOUR COMPUTER IP
    /// Example:
    /// http://192.168.1.124:8000/admin
    final Uri url = Uri.parse(
      "http://127.0.0.1:8000/admin",
    );

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception("Could not open Filament dashboard");
    }
  }

  /// ===============================
  /// ADMIN LOGIN FUNCTION
  /// ===============================
  Future<void> _adminLogin() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter admin credentials")),
      );
      return;
    }

    setState(() => isLoading = true);

    // simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    /// TEMP ADMIN AUTH
    if (emailController.text.trim() == "admin@emoti.com" &&
        passwordController.text == "admin123") {

      /// ✅ OPEN LARAVEL FILAMENT DASHBOARD
      await _openFilamentDashboard();

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid admin credentials")),
      );
    }

    setState(() => isLoading = false);
  }

  /// ===============================
  /// UI
  /// ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Login"),
        backgroundColor: const Color.fromARGB(255, 99, 235, 104),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.admin_panel_settings,
              size: 70,
              color: Color.fromARGB(255, 99, 235, 104),
            ),

            const SizedBox(height: 20),

            /// EMAIL FIELD
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Admin Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 20),

            /// PASSWORD FIELD
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// LOGIN BUTTON
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _adminLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 99, 235, 104),
                      ),
                      child: const Text("ADMIN LOGIN"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}