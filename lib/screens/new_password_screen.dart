// ================= NEW PASSWORD SCREEN =================
import 'package:flutter/material.dart';
import 'package:emoti_app/services/auth_service.dart';
import './home_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;
  final String code;
  const NewPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final ApiService _authService = ApiService();

  bool _isLoading = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final Color kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);

  // Password strength tracking
  double _passwordStrength = 0;
  String _strengthLabel = "";
  Color _strengthColor = Colors.grey;

  void _checkPasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0;
        _strengthLabel = "";
        _strengthColor = Colors.grey;
      });
      return;
    }

    double strength = 0;
    if (password.length >= 8) strength += 0.25;
    if (password.length >= 12) strength += 0.1;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.25;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.2;

    strength = strength.clamp(0.0, 1.0);

    String label;
    Color color;
    if (strength < 0.3) {
      label = "Weak";
      color = Colors.red;
    } else if (strength < 0.6) {
      label = "Fair";
      color = Colors.orange;
    } else if (strength < 0.8) {
      label = "Good";
      color = Colors.blue;
    } else {
      label = "Strong";
      color = kPrimaryGreen;
    }

    setState(() {
      _passwordStrength = strength;
      _strengthLabel = label;
      _strengthColor = color;
    });
  }

  Future<void> _resetPassword() async {
    if (newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a new password"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (newPasswordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be at least 8 characters"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.resetPassword({
        "email": widget.email,
        "code": widget.code,
        "password": newPasswordController.text,
        "password_confirmation": confirmPasswordController.text,
      });

      if (mounted) {
        if (result != null) {
          final statusCode = result['statusCode'];
          final message = result['message'] ?? "Password reset successful";

          if (statusCode == 200 || statusCode == 201) {
            // Extract user name from API response
            final userData = result['data'];
            final String userName = userData?['name'] ?? "User";

            _showSuccessDialog(userName);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        } else {
          throw Exception("No response from server");
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = e.toString();
        if (errorMessage.contains("SocketException") || errorMessage.contains("Failed host lookup")) {
          errorMessage = "No internet connection";
        } else if (errorMessage.contains("expired") || errorMessage.contains("invalid")) {
          errorMessage = "Verification code expired. Please request a new one.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog(String userName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kPrimaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child:  Icon(
                  Icons.check_circle_rounded,
                  size: 70,
                  color: kPrimaryGreen,
                ),
              ),

              const SizedBox(height: 24),

              // Title
              const Text(
                "Password Reset!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                "Your password has been successfully reset. You can now login with your new password.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.pop(context);
                    // Clear entire stack and go to gender selection
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GenderSelectionScreen(userName: userName),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "CONTINUE",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 40,
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Icon
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: kPrimaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.key_rounded,
                size: 70,
                color: kPrimaryGreen,
              ),
            ),

            const SizedBox(height: 36),

            // Title
            const Text(
              "Set New Password",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              "Create a strong password with at least 8 characters, including uppercase, numbers, and symbols.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),

            const SizedBox(height: 36),

            // New Password
            TextField(
              controller: newPasswordController,
              obscureText: !_isNewPasswordVisible,
              onChanged: _checkPasswordStrength,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "New password",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.lock_outlined, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPasswordVisible
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
                  }),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimaryGreen, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),

            // Password Strength Indicator
            if (_passwordStrength > 0) ...[
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Password Strength",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _strengthLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: _strengthColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _passwordStrength,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(_strengthColor),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20),

            // Confirm Password
            TextField(
              controller: confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _isLoading ? null : _resetPassword(),
              decoration: InputDecoration(
                hintText: "Confirm new password",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.lock_outlined, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  }),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimaryGreen, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),

            // Password match indicator
            if (confirmPasswordController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    newPasswordController.text == confirmPasswordController.text
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    size: 16,
                    color: newPasswordController.text == confirmPasswordController.text
                        ? kPrimaryGreen
                        : Colors.red,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    newPasswordController.text == confirmPasswordController.text
                        ? "Passwords match"
                        : "Passwords don't match",
                    style: TextStyle(
                      fontSize: 12,
                      color: newPasswordController.text == confirmPasswordController.text
                          ? kPrimaryGreen
                          : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 36),

            // Reset Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: kPrimaryGreen.withOpacity(0.3),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        "RESET PASSWORD",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}