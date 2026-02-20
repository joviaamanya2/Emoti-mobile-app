import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), 
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const SizedBox(height: 30),

           
Center(
  child: Container(
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.green.withOpacity(0.3),
          blurRadius: 20,
          spreadRadius: 5,
        ),
      ],
    ),
    child: ClipOval(
      child: Image.asset(
        "assets/images/emoti connect.png",
        fit: BoxFit.cover,
      ),
    ),
  ),
),

const SizedBox(height: 30),

                
                Text(
                  "Welcome To Emoti",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Your emotional & mental tracker",
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 8, 8, 8),
                  ),
                ),

                const SizedBox(height: 40),

                // Email Field
                _inputField(
                  hint: "EMAIL",
                  icon: Icons.email,
                ),

                const SizedBox(height: 18),

                // Password Field
                _inputField(
                  hint: "PASSWORD",
                  icon: Icons.lock,
                  obscure: true,
                ),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Login Button
                _mainButton(
                  label: "LOGIN",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateAccountScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------
// CREATE ACCOUNT SCREEN
// -----------------------------------------------

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "“Track your feelings”",
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 13, 14, 13),
                  ),
                ),

                const SizedBox(height: 40),

                _inputField(hint: "FULL NAME", icon: Icons.person),
                const SizedBox(height: 18),

                _inputField(hint: "EMAIL", icon: Icons.email),
                const SizedBox(height: 18),

                _inputField(hint: "PASSWORD", icon: Icons.lock, obscure: true),

                const SizedBox(height: 25),

                Text(
                  "By continuing, you agree to our Terms & Privacy Policy",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.green.shade900),
                ),

                const SizedBox(height: 25),

                _mainButton(
                  label: "SIGN UP",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                ),

                const SizedBox(height: 30),

                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// REUSABLE INPUT FIELD
// ---------------------------------------------------------

Widget _inputField({
  required String hint,
  required IconData icon,
  bool obscure = false,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.green.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 3),
        )
      ],
    ),
    child: TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 7, 7, 7)),
        hintText: hint,
        hintStyle: TextStyle(color: const Color.fromARGB(255, 2, 2, 2)),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 17),
      ),
    ),
  );
}

// ---------------------------------------------------------
// MAIN BUTTON (LOGIN / SIGNUP)
// ---------------------------------------------------------

Widget _mainButton({
  required String label,
  required VoidCallback onTap,
}) {
  return SizedBox(
    width: double.infinity,
    height: 53,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        backgroundColor: Colors.green.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
