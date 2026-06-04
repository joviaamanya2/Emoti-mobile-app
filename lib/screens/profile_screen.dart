import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:emoti_app/services/auth_service.dart';
import 'package:emoti_app/screens/auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  final String? userGender;
  final String? userRole;

  const ProfileScreen({
    super.key,
    this.userName,
    this.userEmail,
    this.userGender,
    this.userRole,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);
  final AuthService _authService = AuthService();

  final String supportEmail = "support@emoti.com";
  final String supportPhone = "+1 234 567 8900";

  String userName = "";
  String userEmail = "";
  String userGender = "";
  String userRole = "user";
  String profileImage = "https://ui-avatars.com/api/?name=User&background=63eb68&color=fff&bold=true";
  bool _isLoadingProfile = true;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _currentPassController;
  late TextEditingController _newPassController;
  late TextEditingController _confirmPassController;

  @override
  void initState() {
    super.initState();

    userName = widget.userName ?? "User";
    userEmail = widget.userEmail ?? "";
    userGender = widget.userGender ?? "";
    userRole = widget.userRole ?? "user";

    profileImage = "https://ui-avatars.com/api/?name=${Uri.encodeComponent(userName)}&background=63eb68&color=fff&bold=true";

    _nameController = TextEditingController(text: userName);
    _emailController = TextEditingController(text: userEmail);
    _currentPassController = TextEditingController();
    _newPassController = TextEditingController();
    _confirmPassController = TextEditingController();

    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final result = await _authService.getUser();

      if (mounted && result != null) {
        final String? name = result['name'];
        final String? email = result['email'];
        final String? gender = result['gender'];
        final String? role = result['role'];

        setState(() {
          if (name != null && name.isNotEmpty) userName = name;
          if (email != null && email.isNotEmpty) userEmail = email;
          if (gender != null && gender.isNotEmpty) userGender = gender;
          if (role != null && role.isNotEmpty) userRole = role;

          _nameController.text = userName;
          _emailController.text = userEmail;

          profileImage = "https://ui-avatars.com/api/?name=${Uri.encodeComponent(userName)}&background=63eb68&color=fff&bold=true";
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingProfile = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  String get _roleDisplay {
    switch (userRole.toLowerCase()) {
      case 'admin':
        return 'Admin';
      case 'counselor':
        return 'Counselor';
      default:
        return 'User';
    }
  }

  IconData get _roleIcon {
    switch (userRole.toLowerCase()) {
      case 'admin':
        return Icons.admin_panel_settings_rounded;
      case 'counselor':
        return Icons.psychology_rounded;
      default:
        return Icons.person_rounded;
    }
  }

  Color get _roleColor {
    switch (userRole.toLowerCase()) {
      case 'admin':
        return const Color(0xFFE53935);
      case 'counselor':
        return const Color(0xFF7C4DFF);
      default:
        return kPrimaryGreen;
    }
  }

  String get _genderDisplay {
    if (userGender.isEmpty) return '';
    return userGender[0].toUpperCase() + userGender.substring(1).toLowerCase();
  }

  void _showContactOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Contact Support",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.green[50],
                child: Icon(Icons.email, color: kPrimaryGreen),
              ),
              title: const Text("Email Us", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(supportEmail),
              onTap: () {
                Navigator.pop(context);
                _launchEmail();
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.green[50],
                child: Icon(Icons.phone, color: kPrimaryGreen),
              ),
              title: const Text("Call Us", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(supportPhone),
              onTap: () {
                Navigator.pop(context);
                _launchPhone();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: 'subject=Support Request from Emoti App&body=User: $userName ($userEmail)',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Opening Email Client... ($supportEmail)")),
        );
      }
    }
  }

  void _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: supportPhone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Dialing $supportPhone...")),
        );
      }
    }
  }

  void _showEditProfileSheet() {
    _nameController.text = userName;
    _emailController.text = userEmail;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          bool isSaving = false;

          return Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Edit Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : () async {
                        if (_nameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Name cannot be empty")),
                          );
                          return;
                        }
                        if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Enter a valid email")),
                          );
                          return;
                        }

                        setModalState(() => isSaving = true);

                        try {
                          final result = await _authService.updateProfile({
                            "name": _nameController.text.trim(),
                            "email": _emailController.text.trim(),
                          });

                          Navigator.pop(context);

                          if (mounted) {
                            final statusCode = result['statusCode'];
                            final message = result['message'] ?? 'Profile updated';

                            if (statusCode == 200 || statusCode == 201) {
                              setState(() {
                                userName = _nameController.text.trim();
                                userEmail = _emailController.text.trim();
                                profileImage = "https://ui-avatars.com/api/?name=${Uri.encodeComponent(userName)}&background=63eb68&color=fff&bold=true";
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor: kPrimaryGreen,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
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
                          }
                        } catch (e) {
                          Navigator.pop(context);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Failed to update profile. Check your connection."),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setModalState(() => isSaving = false);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryGreen,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showChangePasswordDialog() {
    _currentPassController.clear();
    _newPassController.clear();
    _confirmPassController.clear();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          bool isUpdating = false;

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Change Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _currentPassController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Current Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _newPassController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "New Password (min 8 chars)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPassController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm New Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: isUpdating ? null : () async {
                  if (_currentPassController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter current password")),
                    );
                    return;
                  }
                  if (_newPassController.text.length < 8) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("New password must be at least 8 characters")),
                    );
                    return;
                  }
                  if (_newPassController.text != _confirmPassController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("New passwords do not match")),
                    );
                    return;
                  }

                  setDialogState(() => isUpdating = true);

                  try {
                    final result = await _authService.changePassword({
                      "current_password": _currentPassController.text,
                      "password": _newPassController.text,
                      "password_confirmation": _confirmPassController.text,
                    });

                    Navigator.pop(context);

                    if (mounted) {
                      final statusCode = result['statusCode'];
                      final message = result['message'] ?? 'Password changed';

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          backgroundColor: statusCode == 200 ? kPrimaryGreen : Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  } catch (e) {
                    Navigator.pop(context);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                          content: Text("Failed to change password. Check your connection."),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          duration:  Duration(seconds: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  } finally {
                    if (mounted) {
                      setDialogState(() => isUpdating = false);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: isUpdating
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text("Update"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);

              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF63eb68)),
                ),
              );

              try {
                await _authService.logout();
              } catch (e) {
                debugPrint("Logout error: $e");
              }

              if (mounted) {
                // Use pushAndRemoveUntil instead of pushNamedAndRemoveUntil
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text("Yes", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoadingProfile
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF63eb68)))
          : SingleChildScrollView(
              child: Column(
        children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileImage),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _roleColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _roleColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_roleIcon, size: 14, color: _roleColor),
                            const SizedBox(width: 5),
                            Text(
                              _roleDisplay,
                              style: TextStyle(
                                color: _roleColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_genderDisplay.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blueGrey.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.wc_rounded, size: 14, color: Colors.blueGrey),
                              const SizedBox(width: 5),
                              Text(
                                _genderDisplay,
                                style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _showEditProfileSheet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 2,
                      ),
                      child: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.lock_outline,
                    title: "Change Password",
                    onTap: _showChangePasswordDialog,
                  ),
                  _buildSettingsTile(
                    icon: Icons.support_agent_outlined,
                    title: "Help & Support",
                    onTap: _showContactOptions,
                  ),
                  const SizedBox(height: 20),
                  _buildSettingsTile(
                    icon: Icons.logout,
                    title: "Log Out",
                    color: Colors.red,
                    onTap: _handleLogout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, spreadRadius: 1)
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? kPrimaryGreen),
        title: Text(title, style: TextStyle(color: color ?? Colors.black87, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}