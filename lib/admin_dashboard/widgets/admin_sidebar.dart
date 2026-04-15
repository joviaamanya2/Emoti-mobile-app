import 'package:flutter/material.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {"title": "Dashboard Home", "icon": Icons.home},
      {"title": "Emotions", "icon": Icons.mood},
      {"title": "Recommendations", "icon": Icons.playlist_add},
      {"title": "Feedbacks", "icon": Icons.feedback},
      {"title": "Counselors", "icon": Icons.people},
      {"title": "Appointments", "icon": Icons.calendar_today},
      {"title": "Settings", "icon": Icons.settings},
      {"title": "Logout", "icon": Icons.logout},
    ];

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 50),
          const Text(
            "EMOTI ADMIN",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, color: Colors.green),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];
                final isSelected = index == selectedIndex;
                return ListTile(
                  leading: Icon(
                    item["icon"] as IconData,
                    color: isSelected ? Colors.green : Colors.grey[700],
                  ),
                  title: Text(
                    item["title"] as String,
                    style: TextStyle(
                        color: isSelected ? Colors.green : Colors.grey[800],
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal),
                  ),
                  onTap: () => onItemSelected(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}