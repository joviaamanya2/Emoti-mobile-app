import 'package:flutter/material.dart';
import '../widgets/overview_card.dart';
import '../widgets/recent_activity_tile.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 1200) crossAxisCount = 4;
        else if (constraints.maxWidth > 800) crossAxisCount = 3;

        final cards = [
          OverviewCard(title: "Total Users", value: "1200", icon: Icons.people, color: Colors.blue),
          OverviewCard(title: "Active Users Today", value: "350", icon: Icons.check, color: Colors.green),
          OverviewCard(title: "Moods Recorded", value: "2450", icon: Icons.mood, color: Colors.purple),
          OverviewCard(title: "Recommendations", value: "78", icon: Icons.playlist_add, color: Colors.orange),
          OverviewCard(title: "Journals", value: "540", icon: Icons.book, color: Colors.pink),
          OverviewCard(title: "Appointments Today", value: "18", icon: Icons.calendar_today, color: Colors.teal),
        ];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cards.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (_, index) => cards[index],
              ),
              const SizedBox(height: 40),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(child: Text("Charts Placeholder")),
              ),
              const SizedBox(height: 40),
              const Text("Recent Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const RecentActivityTile(title: "John Doe", subtitle: "Created a new journal", icon: Icons.book),
              const RecentActivityTile(title: "Jane Smith", subtitle: "Submitted feedback", icon: Icons.feedback),
              const RecentActivityTile(title: "Mark Wilson", subtitle: "Booked counseling appointment", icon: Icons.calendar_today),
            ],
          ),
        );
      },
    );
  }
}