import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_service.dart';
import '../screens/home_screen.dart';
import 'forgot_password_screen.dart';
import './home_screen.dart';
import './home_screen.dart';

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
  final signupConfirmPasswordController = TextEditingController();
  final signupContactController = TextEditingController();
  final signupAddressController = TextEditingController();

  bool isLoadingLogin = false;
  bool isLoadingSignup = false;

  bool isLoginPasswordVisible = false;
  bool isSignupPasswordVisible = false;

  final AuthService _authService = AuthService();

  final Color kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);

  // Role selection
  String selectedRole = 'user';

  final List<Map<String, dynamic>> _roles = [
    {
      "value": "user",
      "label": "User",
      "icon": Icons.person_rounded,
      "description": "Standard account access",
    },
    {
      "value": "counselor",
      "label": "Counselor",
      "icon": Icons.psychology_rounded,
      "description": "Help & guide others",
    },
  ];

  final String laravelBaseUrl = 'http://127.0.0.1:8001';

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
    signupConfirmPasswordController.dispose();
    signupContactController.dispose();
    signupAddressController.dispose();
    super.dispose();
  }

  // Method to open Laravel login page
  Future<void> _openLaravelLogin() async {
    final Uri loginUrl = Uri.parse('$laravelBaseUrl/login');

    if (!await launchUrl(
      loginUrl,
      mode: LaunchMode.externalApplication,
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open login page")),
        );
      }
    }
  }

  // LOGIN
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

      final userData = result['data'];
      final String userName =
          userData?['name'] ?? userData?['user']?['name'] ?? "User";

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));

        if (statusCode == 200 || statusCode == 201) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => GenderSelectionScreen(userName: userName),
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
      if (mounted) setState(() => isLoadingLogin = false);
    }
  }

  // SIGNUP
  Future<void> _handleSignUp() async {
    if (signupNameController.text.isEmpty ||
        signupEmailController.text.isEmpty ||
        signupPasswordController.text.isEmpty ||
        signupConfirmPasswordController.text.isEmpty ||
        signupContactController.text.isEmpty ||
        signupAddressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (signupPasswordController.text !=
        signupConfirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => isLoadingSignup = true);

    try {
      final result = await _authService.register({
        "name": signupNameController.text.trim(),
        "email": signupEmailController.text.trim(),
        "password": signupPasswordController.text,
        "password_confirmation": signupConfirmPasswordController.text,
        "contact": signupContactController.text.trim(),
        "address": signupAddressController.text.trim(),
        "role": selectedRole,
      });

      final message = result['message'];
      final statusCode = result['statusCode'];

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));

        if (statusCode == 200 || statusCode == 201) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  GenderSelectionScreen(userName: signupNameController.text),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Signup Error: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup Failed: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoadingSignup = false);
    }
  }

  //  UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Emoti",
                      style: TextStyle(
                          fontSize: 42, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 20),
                  _buildTabs(),
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

  //  LOGIN TAB
  Widget _loginTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _input("Email", Icons.email, loginEmailController),
          const SizedBox(height: 15),
          _input("Password", Icons.lock, loginPasswordController,
              isPassword: true,
              isVisible: isLoginPasswordVisible,
              onToggle: () => setState(() {
                    isLoginPasswordVisible = !isLoginPasswordVisible;
                  })),
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
                "Forgot Password?",
                style: TextStyle(color: kPrimaryGreen),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _button("LOGIN", _handleLogin),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[400])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Or continue with",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[400])),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _socialButton(Icons.g_mobiledata, "Google"),
              _socialButton(Icons.apple, "Apple"),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // SIGNUP TAB
  Widget _signupTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _input("Full Name", Icons.person, signupNameController),
          const SizedBox(height: 15),
          _input("Email", Icons.email, signupEmailController),
          const SizedBox(height: 15),
          _input("Password", Icons.lock, signupPasswordController,
              isPassword: true,
              isVisible: isSignupPasswordVisible,
              onToggle: () => setState(() {
                    isSignupPasswordVisible = !isSignupPasswordVisible;
                  })),
          const SizedBox(height: 15),
          _input(
              "Confirm Password",
              Icons.lock,
              signupConfirmPasswordController,
              isPassword: true,
              isVisible: isSignupPasswordVisible,
              onToggle: () => setState(() {
                    isSignupPasswordVisible = !isSignupPasswordVisible;
                  })),
          const SizedBox(height: 15),
          _input("Contact", Icons.phone, signupContactController),
          const SizedBox(height: 15),
          _input("Address", Icons.home, signupAddressController),
          const SizedBox(height: 20),

          // Role Selection
          _buildRoleSection(),

          const SizedBox(height: 24),
          _button("SIGN UP", _handleSignUp),
        ],
      ),
    );
  }

  // ROLE SELECTION SECTION
  Widget _buildRoleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.shield_rounded, color: kPrimaryGreen, size: 20),
            const SizedBox(width: 6),
            const Text(
              "Select Your Role",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "*",
              style: TextStyle(color: Colors.red[400], fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "Choose the account type that fits you best",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        ..._roles.map((role) => _buildRoleCard(role)),
      ],
    );
  }

  Widget _buildRoleCard(Map<String, dynamic> role) {
    final isSelected = selectedRole == role['value'];
    final color = _getRoleColor(role['value']);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => selectedRole = role['value']),
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.08) : Colors.grey[50],
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? color : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isSelected ? color : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    role['icon'],
                    color: isSelected ? Colors.white : Colors.grey[500],
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role['label'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? color : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role['description'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? color.withOpacity(0.7)
                              : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? color : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? color : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'counselor':
        return const Color(0xFF7C4DFF);
      default:
        return kPrimaryGreen;
    }
  }

  // HELPERS
  Widget _socialButton(IconData icon, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: OutlinedButton.icon(
          onPressed: () {
            debugPrint("Pressed $label");
          },
          icon: Icon(icon, color: Colors.black54),
          label: Text(label, style: const TextStyle(color: Colors.black54)),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey[300]!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

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
        prefixIcon: Icon(icon),
        hintText: hint,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: onToggle,
              )
            : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        filled: true,
      ),
    );
  }

  Widget _button(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _tabItem("LOGIN", 0),
        const SizedBox(width: 20),
        _tabItem("SIGN UP", 1),
      ],
    );
  }

  Widget _tabItem(String title, int index) {
    bool selected = _tabController.index == index;
    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: selected ? kPrimaryGreen : Colors.grey,
          fontSize: 18,
        ),
      ),
    );
  }
}