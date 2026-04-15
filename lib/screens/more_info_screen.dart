import 'package:flutter/material.dart';

// Top-level constant for topics
const List<Map<String, String>> topics = [
  {
    "title": "Understanding Emotions",
    "description":
        "Emotions are signals that help us understand our needs, desires, and reactions. Recognizing them is the first step toward emotional wellness.",
    "image": "assets/images/emotions.png"
  },
  {
    "title": "Common Mental Health Challenges",
    "description":
        "Stress, anxiety, sadness, and anger are common mental health challenges. When not addressed, they can affect sleep, productivity, and relationships. It's important to recognize the signs early and take proactive steps.",
    "image": "assets/images/challenges.png"
  },
  {
    "title": "Consequences of Ignored Emotions",
    "description":
        "Ignoring emotions can lead to chronic stress, mood swings, depression, and physical health problems like headaches or high blood pressure. Being mindful and addressing emotions is key to long-term well-being.",
    "image": "assets/images/consequences.png"
  },
  {
    "title": "Healthy Coping Strategies",
    "description":
        "Exercise, journaling, meditation, talking to someone you trust, and engaging in hobbies are proven strategies to manage emotions. Developing a toolkit of coping strategies helps reduce stress and improves mood.",
    "image": "assets/images/copying.png"
  },
  {
    "title": "Seeking Support",
    "description":
        "Reaching out for support is a sign of strength. Friends, family, support groups, and professional counselors can help process emotions, provide guidance, and prevent feelings from overwhelming you.",
    "image": "assets/images/support.png"
  },
  {
    "title": "Daily Mental Health Practices",
    "description":
        "Maintain routines, sleep well, eat nutritious meals, practice gratitude, and take breaks when needed. Consistent daily practices create resilience and help maintain emotional balance.",
    "image": "assets/images/daily.png"
  },
];

class MoreInfoScreen extends StatelessWidget {
  const MoreInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "More About Mental Health",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A1F44),
      ),
      body: Container(
        color: const Color(0xFFE8F5E9), // light green background
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: topics.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final topic = topics[index];
            return OverviewCard(topic: topic);
          },
        ),
      ),
    );
  }
}

// Card widget
class OverviewCard extends StatelessWidget {
  final Map<String, String> topic;
  const OverviewCard({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  topic["image"]!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  topic["title"]!,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            topic["description"]!,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A1F44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullDetailScreen(topic: topic)),
                );
              },
              child: const Text("Read More",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

// Full detail screen
class FullDetailScreen extends StatelessWidget {
  final Map<String, String> topic;
  const FullDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic["title"]!, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0A1F44),
      ),
      body: Container(
        color: Colors.white, // white background
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  topic["image"]!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                topic["title"]!,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 12),
              Text(
                topic["description"]!,
                style: const TextStyle(
                    fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 20),
              const Text(
                "Detailed Notes",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 12),
              const Text(
                "Emotions and mental health are complex. Here’s a detailed breakdown of how to understand and manage them:",
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.check_circle_outline, color: Colors.green),
                    title: Text(
                      "Identify your feelings honestly and label them.",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.check_circle_outline, color: Colors.green),
                    title: Text(
                      "Understand what triggers certain emotions.",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.check_circle_outline, color: Colors.green),
                    title: Text(
                      "Develop coping strategies like journaling, exercise, or meditation.",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.check_circle_outline, color: Colors.green),
                    title: Text(
                      "Seek support from friends, family, or professionals when needed.",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Practical Tips",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.lightbulb_outline, color: Colors.orange),
                    title: Text(
                      "Set aside 10 minutes daily for reflection or meditation.",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.lightbulb_outline, color: Colors.orange),
                    title: Text(
                      "Keep a gratitude journal to track positive moments.",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.lightbulb_outline, color: Colors.orange),
                    title: Text(
                      "Engage in physical activity regularly to manage stress.",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}