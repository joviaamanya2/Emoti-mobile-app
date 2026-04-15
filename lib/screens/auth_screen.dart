// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/home_screen.dart'; // Import the Gender Selection screen
import 'forgot_password_screen.dart';
import '../admin_dashboard/screens/admin_login.dart';

class AuthScreen extends StatefulWidget {
  final int initialTabIndex;
  const AuthScreen({super.key, this.initialTabIndex = 0});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final signupNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupContactController = TextEditingController();
  final signupAddressController = TextEditingController();

  bool isLoadingLogin = false;
  bool isLoadingSignup = false;

  bool isLoginPasswordVisible = false;
  bool isSignupPasswordVisible = false;

  final ApiService _authService = ApiService();

  // Theme Color
  final Color kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signupNameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupContactController.dispose();
    signupAddressController.dispose();
    super.dispose();
  }

  // ================= LOGIN LOGIC =================
  Future<void> _handleLogin() async {
    if (loginEmailController.text.isEmpty ||
        loginPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() => isLoadingLogin = true);

    try {
      final result = await _authService.login({
        "email": loginEmailController.text.trim(),
        "password": loginPasswordController.text,
      });

      final message = result['message'];
      final statusCode = result['statusCode'];
      
      // FIX: Extract user data to get the name
      // Depending on your API, the name might be in result['data']['name'] or result['data']['user']['name']
      final userData = result['data'];
      final String userName = userData['name'] ?? userData['user']?['name'] ?? "User";

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));

        if (statusCode == 200 || statusCode == 201) {
          // UPDATED: Pass the fetched userName to GenderSelectionScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => GenderSelectionScreen(
              userName: userName, 
            )),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => isLoadingLogin = false);
      }
    }
  }

  // ================= SIGN UP LOGIC =================
  Future<void> _handleSignUp() async {
    if (signupNameController.text.isEmpty ||
        signupEmailController.text.isEmpty ||
        signupPasswordController.text.isEmpty ||
        signupContactController.text.isEmpty ||
        signupAddressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoadingSignup = true);

    try {
      final result = await _authService.register({
        "name": signupNameController.text.trim(),
        "email": signupEmailController.text.trim(),
        "password": signupPasswordController.text,
        "contact": signupContactController.text.trim(),
        "address": signupAddressController.text.trim(),
      });

      final message = result['message'];
      final statusCode = result['statusCode'];

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));

        if (statusCode == 200 || statusCode == 201) {
          // UPDATED: Pass the name to Gender Selection Screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => GenderSelectionScreen(
                userName: signupNameController.text,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => isLoadingSignup = false);
      }
    }
  }

  // ================= SOCIAL LOGIN (SIMULATION) =================
  void _handleSocialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Connecting to $provider...")),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Ensure the scaffold resizes when the keyboard appears
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // Apply SafeArea ONLY to the header, not the scrollable content
          SafeArea(
            bottom: false, // Don't reserve padding at the bottom
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Emoti",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.admin_panel_settings, color: kPrimaryGreen),
                        tooltip: "Admin Dashboard",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTabs(),
                  const SizedBox(height: 15),
                  Text(
                    _tabController.index == 0
                        ? "Welcome Back! Please sign in."
                        : "Create an account to get started.",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _loginTab(),
                _signupTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _tabItem("LOGIN", 0),
        const SizedBox(width: 30),
        _tabItem("SIGN UP", 1),
      ],
    );
  }

  Widget _tabItem(String title, int index) {
    bool selected = _tabController.index == index;

    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align indicator to start
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected ? kPrimaryGreen : Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: selected ? 30 : 0, // Width of the underline
            decoration: BoxDecoration(
              color: kPrimaryGreen,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  // ================= LOGIN TAB =================
  Widget _loginTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 24, 
        right: 24, 
        // Pushes the content up when keyboard opens
        bottom: MediaQuery.of(context).viewInsets.bottom + 20, 
      ),
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          _input("Email", Icons.email, loginEmailController),
          const SizedBox(height: 20),
          _input(
            "Password",
            Icons.lock,
            loginPasswordController,
            isPassword: true,
            isVisible: isLoginPasswordVisible,
            onToggle: () {
              setState(() {
                isLoginPasswordVisible = !isLoginPasswordVisible;
              });
            },
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                );
              },
              child: Text(
                "Forgot password?",
                style: TextStyle(color: kPrimaryGreen, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          isLoadingLogin
              ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(225, 51, 255, 0)))
              : _button("LOGIN", _handleLogin),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[300])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("or connect with", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ),
              Expanded(child: Divider(color: Colors.grey[300])),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialButton(Icons.g_mobiledata, "Google"),
              const SizedBox(width: 15),
              _socialButton(Icons.facebook, "Facebook"),
              const SizedBox(width: 15),
              _socialButton(Icons.apple, "Apple"),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
              GestureDetector(
                onTap: () => _tabController.animateTo(1),
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryGreen,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= SIGNUP TAB =================
  Widget _signupTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 24, 
        right: 24, 
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _input("Full Name", Icons.person, signupNameController),
          const SizedBox(height: 15),
          _input("Email", Icons.email, signupEmailController),
          const SizedBox(height: 15),
          _input(
            "Password",
            Icons.lock,
            signupPasswordController,
            isPassword: true,
            isVisible: isSignupPasswordVisible,
            onToggle: () {
              setState(() {
                isSignupPasswordVisible = !isSignupPasswordVisible;
              });
            },
          ),
          const SizedBox(height: 15),
          _input("Contact", Icons.phone, signupContactController),
          const SizedBox(height: 15),
          _input("Address", Icons.home, signupAddressController),
          const SizedBox(height: 20),
          isLoadingSignup
              ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(232, 93, 228, 60)))
              : _button("SIGN UP", _handleSignUp),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _input(
    String hint,
    IconData icon,
    TextEditingController controller, {
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !isVisible : false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500]),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[600],
                ),
                onPressed: onToggle,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kPrimaryGreen, width: 1.5),
        ),
      ),
    );
  }

  Widget _button(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _socialButton(IconData icon, String providerName) {
    return InkWell(
      onTap: () => _handleSocialLogin(providerName),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 28, color: Colors.grey[700]),
      ),
    );
  }
}