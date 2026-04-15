import 'package:emoti_app/screens/reset_password.dart';
import 'package:flutter/material.dart';
import 'reset_password.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;

  const VerifyCodeScreen({super.key, required this.email});

  @override
  State<VerifyCodeScreen> createState() =>
      _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {

  final TextEditingController codeController =
      TextEditingController();

  bool loading = false;

  void verifyCode() async {
    setState(() => loading = true);

    /// 🔵 VERIFY CODE API
    await Future.delayed(const Duration(seconds: 2));

    setState(() => loading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ResetPasswordScreen(email: widget.email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(title: const Text("Verification Code")),

      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [

            const SizedBox(height: 40),

            Text(
              "Enter the code sent to\n${widget.email}",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter Code",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: loading ? null : verifyCode,
              child: loading
                  ? const CircularProgressIndicator(
                      color: Colors.white)
                  : const Text("VERIFY"),
            ),
          ],
        ),
      ),
    );
  }
}