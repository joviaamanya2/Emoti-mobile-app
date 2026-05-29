import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import 'package:emoti_app/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  
  // This listens to the global theme toggle from main.dart
  @override
  void initState() {
    super.initState();
    ThemeNotifier.isDarkMode.addListener(_themeListener);
  }

  @override
  void dispose() {
    ThemeNotifier.isDarkMode.removeListener(_themeListener);
    super.dispose();
  }

  void _themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  // Quick shortcut to check dark mode status
  bool get _isDark => ThemeNotifier.isDarkMode.value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.iconTheme.color),
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
                title: 'Dark Mode',
                trailing: Switch(
                  value: _isDark,
                  onChanged: (val) {
                    ThemeNotifier.isDarkMode.value = val; 
                    // Keep this line if SettingsProvider saves to local storage (SharedPreferences)
                    // SettingsProvider.setDarkMode(val); 
                  },
                ),
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
                icon: _isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                title: _isDark ? 'Switch to Light' : 'Switch to Dark',
                trailing: Switch(
                  value: _isDark,
                  onChanged: (val) {
                    ThemeNotifier.isDarkMode.value = val;
                  },
                ),
              ),
              _buildDivider(),
              _buildSettingsTile(
                icon: Icons.text_fields_rounded,
                title: 'Font Size',
                trailingText: SettingsProvider.fontScale.toStringAsFixed(1),
                onTap: _chooseFontSize,
              ),
              _buildDivider(),
              _buildSettingsTile(
                icon: Icons.apps_outlined,
                title: 'App Icon',
                trailingText: SettingsProvider.appIcon,
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
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color ?? Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // PROFILE
  Widget _buildUserProfile() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: const Color.fromARGB(255, 92, 198, 101).withOpacity(_isDark ? 0.2 : 0.1),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Color(0xFF5CC6A9),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Alex Johnson", style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  "alex.johnson@example.com",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // COMPONENTS
  Widget _buildSectionHeader(String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.bodyMedium?.color ?? Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isDark
            ? null
            : [
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
    Color? textColor,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(
        icon,
        color: iconColor == Colors.grey ? theme.iconTheme.color : iconColor,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: textColor ?? theme.textTheme.bodyLarge?.color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null)
                Text(
                  trailingText,
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color ?? Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
              if (trailingText != null) const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: theme.textTheme.bodyMedium?.color ?? Colors.grey.shade400,
                size: 20,
              ),
            ],
          ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    final theme = Theme.of(context);

    return Divider(
      color: theme.dividerColor,
      height: 1,
      indent: 60,
      endIndent: 20,
    );
  }

  // INTERACTIONS

  void _editProfile() {
    final nameController = TextEditingController(text: "Alex Johnson");
    final emailController = TextEditingController(text: "alex.johnson@example.com");
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Edit Profile", style: theme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5CC6A9)),
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void _linkDevice() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Link a Device", style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bluetooth, color: Colors.blue),
              title: const Text("Bluetooth Device"),
              onTap: () {
                _showSnack("Bluetooth Device linked successfully");
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _chooseFontSize() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
      title: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: () {
        SettingsProvider.setFontScale(scale);
        Navigator.pop(context);
      },
    );
  }

  void _chooseAppIcon() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconOption("Default"),
          _iconOption("Green"),
          _iconOption("Dark"),
        ],
      ),
    );
  }

  Widget _iconOption(String label) {
    return ListTile(
      title: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: () {
        SettingsProvider.setAppIcon(label);
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
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Sign Out", style: Theme.of(context).textTheme.titleLarge),
        content: Text(
          "Are you sure you want to sign out?",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnack("User Signed Out");
            },
            child: const Text("Sign Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}