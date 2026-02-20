import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/mood_history_service.dart';

class MoodHistoryScreen extends StatelessWidget {
  const MoodHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counts = MoodHistoryService.instance.countsLastNDays(7);
    final items = counts.entries.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Mood History & Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const Text('Last 7 days', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(height: 180, child: items.isEmpty ? const Center(child: Text('No data yet')) : PieChart(PieChartData(sections: items.map((e) => PieChartSectionData(value: e.value.toDouble(), title: '${e.key} (${e.value})')).toList()))),
          const SizedBox(height: 16),
          Expanded(child: ListView(children: MoodHistoryService.instance.history.map((e) {
            final dt = DateTime.tryParse(e['time'] ?? '') ?? DateTime.now();
            final t = "${dt.year}-${dt.month.toString().padLeft(2,'0')}-${dt.day.toString().padLeft(2,'0')} ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
            return ListTile(leading: Text(e['emoji'] ?? ''), title: Text(e['mood'] ?? ''), subtitle: Text(t));
          }).toList())),
          ElevatedButton(onPressed: () => MoodHistoryService.instance.clear().then((_) => Navigator.pop(context)), child: const Text('Clear History'))
        ]),
      ),
    );
  }
}
