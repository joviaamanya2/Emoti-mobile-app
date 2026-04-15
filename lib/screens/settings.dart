import 'package:flutter/material.dart';

// Removed the 'MyApp' wrapper and 'main()' function to prevent conflicts with your main app structure.

/// ================= SETTINGS SCREEN =================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  /// USER DATA (Dynamic)
  String userName = "Alex Johnson";
  String email = "alex.johnson@example.com";
  String fontLabel = "Medium";
  String selectedIcon = "Default";
  
  // Local state for the UI toggle (In a real app, use Provider/GetX for global state)
  bool isDarkMode = false; 

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    // Check current brightness
    final Brightness brightness = Theme.of(context).brightness;
    // Using a static color for now to ensure visibility, or use Theme colors
    final Color primaryColor = const Color.fromARGB(255, 99, 235, 104);

    return Scaffold(
      backgroundColor: brightness == Brightness.dark ? Colors.black : const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfile(),

            const SizedBox(height: 30),

            _buildSectionHeader("ACCOUNT"),
            _buildSettingsGroup([
              _buildSettingsTile(
                icon: Icons.person_outline_rounded,
                title: 'Personal Info',
                onTap: _editProfile,
              ),
              _buildDivider(),
              _buildSettingsTile(
                icon: Icons.switch_account_outlined,
                title: 'Switch Account',
                onTap: _switchAccount,
              ),
              _buildDivider(),
              _buildSettingsTile(
                icon: Icons.security_outlined,
                title: 'Security',
                onTap: () => _showSnack("Security settings coming soon"),
              ),
              _buildDivider(),
              _buildSettingsTile(
                icon: Icons.devices_outlined,
                title: 'Link a Device',
                onTap: _linkDevice,
              ),
            ]),

            const SizedBox(height: 30),

            _buildSectionHeader("APPEARANCE"),
            _buildSettingsGroup([
              _buildSettingsTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                // Visual toggle only. Global theme change requires state management (Provider/GetX)
                trailing: Switch(
                  value: isDarkMode,
                  activeColor: primaryColor,
                  onChanged: (val) {
                    setState(() {
                      isDarkMode = val;
                    });
                    // Ideally: Provider.of<ThemeProvider>(context, listen: false).toggleTheme(val);
                  },
                ),
              ),
              _buildDivider(),
              _buildSettingsTile(
                icon: Icons.text_fields_rounded,
                title: 'Font Size',
                trailingText: fontLabel,
                onTap: _chooseFontSize,
              ),
              _buildDivider(),
              _buildSettingsTile(
                icon: Icons.apps_outlined,
                title: 'App Icon',
                trailingText: selectedIcon,
                onTap: _chooseAppIcon,
              ),
            ]),

            const SizedBox(height: 30),

            _buildSectionHeader("OTHER"),
            _buildSettingsGroup([
              _buildSettingsTile(
                icon: Icons.logout,
                title: 'Sign Out',
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: _showSignOutDialog,
              ),
            ]),

            const SizedBox(height: 30),

            Center(
              child: Text(
                'Emoti App v1.0.0',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= PROFILE =================
  Widget _buildUserProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: const Color.fromARGB(255, 99, 235, 104).withOpacity(0.2),
            child: const Icon(Icons.person, size: 40, color: Color.fromARGB(255, 99, 235, 104)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(email, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= COMPONENTS =================
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
           BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    String? trailingText,
    Color iconColor = Colors.grey,
    Color textColor = Colors.black87,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: iconColor, size: 24),
      title: Text(title,
          style: TextStyle(
              fontSize: 16, color: textColor, fontWeight: FontWeight.w500)),
      trailing: trailing ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null)
                Text(trailingText,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
              if (trailingText != null) const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade200,
      height: 1,
      indent: 60, // Indent to align with text, not icon
      endIndent: 20,
    );
  }

  /// ================= INTERACTIONS =================

  void _editProfile() {
    final nameController = TextEditingController(text: userName);
    final emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 99, 235, 104)),
            onPressed: () {
              setState(() {
                userName = nameController.text;
                email = emailController.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void _switchAccount() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Switch Account"),
        content: const Text("Do you want to switch to a different account?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 99, 235, 104)),
            onPressed: () {
              _showSnack("Switched to another account");
              Navigator.pop(context);
            },
            child: const Text("Switch"),
          ),
        ],
      ),
    );
  }

  void _linkDevice() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Link a Device"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.watch, color: Color.fromARGB(255, 99, 235, 104)),
              title: const Text("Smart Watch"),
              onTap: () {
                _showSnack("Smart Watch linked successfully");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bluetooth, color: Colors.blue),
              title: const Text("Bluetooth Device"),
              onTap: () {
                _showSnack("Bluetooth Device linked successfully");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.orange),
              title: const Text("Safe Bundle"),
              onTap: () {
                _showSnack("Safe Bundle linked successfully");
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ],
      ),
    );
  }

  void _chooseFontSize() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _fontOption("Small", 0.9),
          _fontOption("Medium", 1.0),
          _fontOption("Large", 1.2),
        ],
      ),
    );
  }

  Widget _fontOption(String label, double scale) {
    return ListTile(
      title: Text(label, textAlign: TextAlign.center),
      onTap: () {
        setState(() => fontLabel = label);
        Navigator.pop(context);
        // widget.onFontChanged(scale); // Removed dependency
      },
    );
  }

  void _chooseAppIcon() {
    showModalBottomSheet(
      context: context,
       backgroundColor: Colors.white,
       shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconOption("Default"),
          _iconOption("Green Zen"),
          _iconOption("Minimal"),
        ],
      ),
    );
  }

  Widget _iconOption(String label) {
    return ListTile(
      title: Text(label, textAlign: TextAlign.center),
      onTap: () {
        setState(() => selectedIcon = label);
        Navigator.pop(context);
      },
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.grey[800]),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnack("User Signed Out");
              // Add actual logout logic here (e.g., Navigator.pushReplacementNamed('/login'))
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}