import 'package:flutter/material.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  int selectedTab = 0;

  final List<String> tabs = [
    "Sleep Stories",
    "White Noise",
    "Meditation",
    "ASMR"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Improve Sleep",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.share, color: Colors.black),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _goalCard(),
            const SizedBox(height: 20),
            const Text(
              "Sleep-Inducing Audio",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _tabs(),
            const SizedBox(height: 16),
            _audioSection(),
            const SizedBox(height: 20),
            const Text(
              "Sleep Hygiene Tips",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _tipTile(Icons.phone_android, "Reduce blue light exposure",
                "Turn off screens at least 1 hour before bed to help your brain produce melatonin."),
            _tipTile(Icons.access_time, "Maintain consistency",
                "Try to go to sleep and wake up at the same time every day, even on weekends."),
            _tipTile(Icons.thermostat, "Cool bedroom environment",
                "The ideal temperature for sleep is around 65°F (18°C)."),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _goalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("TODAY'S GOAL",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Sleep Goal Progress",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDFF5E8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("6h 30m / 8h",
                    style: TextStyle(color: Colors.green)),
              )
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.81,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "You're 81% towards your goal today!",
            style: TextStyle(fontSize: 12, color: Colors.green),
          )
        ],
      ),
    );
  }

  Widget _tabs() {
    return Row(
      children: List.generate(tabs.length, (index) {
        final active = selectedTab == index;
        return GestureDetector(
          onTap: () => setState(() => selectedTab = index),
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Text(
                  tabs[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        active ? FontWeight.w600 : FontWeight.normal,
                    color: active ? Colors.black : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                if (active)
                  Container(
                    height: 3,
                    width: 20,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _audioSection() {
    switch (selectedTab) {
      case 0:
        return _audioCards();
      case 1:
        return const Text("White noise coming soon...");
      case 2:
        return const Text("Meditation content coming soon...");
      case 3:
        return const Text("ASMR content coming soon...");
      default:
        return _audioCards();
    }
  }

  Widget _audioCards() {
    return Row(
      children: [
        Expanded(
          child: _audioCard(
              "Deep Forest Rain",
              "45 mins • Nature",
              "https://images.unsplash.com/photo-1501785888041-af3ef285b470"),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _audioCard(
              "Midnight Cabin",
              "32 mins • Story",
              "https://images.unsplash.com/photo-1505691938895-1758d7feb511"),
        ),
      ],
    );
  }

  Widget _audioCard(String title, String subtitle, String image) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Playing $title...")),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(image,
                height: 120, fit: BoxFit.cover),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey))
        ],
      ),
    );
  }

  Widget _tipTile(IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5EE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(desc,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: 2,
      onTap: (index) {
        // You can add navigation here
      },
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "HOME"),
        BottomNavigationBarItem(icon: Icon(Icons.mood), label: "MOOD"),
        BottomNavigationBarItem(icon: Icon(Icons.nightlight), label: "SLEEP"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "PROFILE"),
      ],
    );
  }
}
