import 'package:flutter/material.dart';
import '../widgets/admin_sidebar.dart';
import 'dashboard_home.dart';
import 'emotions_screen.dart';
import 'recommendations_screen.dart';
import 'feedback_screen.dart';
import 'counselors_screen.dart';
import 'appointments.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;
  bool isSidebarOpen = true;

  final List<Widget> pages = [
    AdminHome(),
    EmotionsScreen(),
    RecommendationsScreen(),
    FeedbackScreen(),
    CounselorsScreen(),
    AppointmentsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              backgroundColor: Colors.green,
              title: const Text("EMOTI ADMIN"),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  setState(() => isSidebarOpen = !isSidebarOpen);
                },
              ),
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar
            if (!isMobile || isSidebarOpen)
              SizedBox(
                width: 250,
                child: AdminSidebar(
                  selectedIndex: selectedIndex,
                  onItemSelected: (index) {
                    if (index == 7) {
                      Navigator.pop(context); // Logout
                    } else if (index == 6) {
                      // Settings
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Settings"),
                          content: const Text("Settings coming soon!"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Close"))
                          ],
                        ),
                      );
                    } else {
                      setState(() => selectedIndex = index);
                      if (isMobile) isSidebarOpen = false;
                    }
                  },
                ),
              ),

            // Main content
            Expanded(
              child: Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Header + Breadcrumb
                    if (!isMobile)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dashboard",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.settings),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Settings"),
                                      content:
                                          const Text("Settings coming soon!"),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Close"))
                                      ],
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.logout),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    // Dashboard content cards (example for Home page)
                    if (selectedIndex == 0)
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: isMobile ? 1 : 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            _buildStatCard(
                                "Users", 120, Colors.green, Icons.person),
                            _buildStatCard("Emotions Logged", 345,
                                Colors.orange, Icons.insert_chart),
                            _buildStatCard("Appointments", 32, Colors.blue,
                                Icons.calendar_today),
                            _buildStatCard("Feedbacks", 45, Colors.red,
                                Icons.feedback),
                          ],
                        ),
                      )
                    else
                      // Load other pages
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: pages[selectedIndex],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build statistic cards
  Widget _buildStatCard(
      String title, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color)),
              const SizedBox(height: 8),
              Text(count.toString(),
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ],
          )
        ],
      ),
    );
  }
}