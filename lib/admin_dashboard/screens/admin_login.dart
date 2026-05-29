import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {

  Future<void> _openDashboard() async {
    // IMPORTANT: Use 8000 for Laravel, NOT 5173 (which is React/Node)
    final Uri url = Uri.parse("http://127.0.0.1:8001/admin");

    if (!await launchUrl(
      url,
      mode: LaunchMode.platformDefault, // Opens in browser on mobile, new tab on web
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not launch dashboard. Is Laravel running?"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: const Color.fromARGB(255, 99, 235, 104),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.admin_panel_settings,
              size: 100,
              color: Color.fromARGB(255, 99, 235, 104),
            ),
            const SizedBox(height: 40),
            const Text(
              "Click below to access the Admin Dashboard",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            // Simple button to open the browser
            SizedBox(
              width: 250,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _openDashboard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 99, 235, 104),
                  foregroundColor: Colors.black,
                ),
                icon: const Icon(Icons.open_in_browser, size: 24),
                label: const Text(
                  "OPEN DASHBOARD",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}