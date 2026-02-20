import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MoodHistoryService {
  static const _key = 'mood_history_v1';
  static final MoodHistoryService instance = MoodHistoryService._();
  MoodHistoryService._();

  List<Map<String, String>> _history = [];

  List<Map<String, String>> get history => List.unmodifiable(_history);

  /// MUST be called once in main()
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw != null && raw.isNotEmpty) {
      try {
        final List decoded = jsonDecode(raw);
        _history = decoded
            .map<Map<String, String>>((e) => Map<String, String>.from(e))
            .toList();
      } catch (_) {
        _history = [];
      }
    } else {
      _history = [];
    }
  }

  /// ✅ METHOD YOUR DASHBOARD EXPECTS
  static Future<void> saveMood(String mood, {String? emoji}) async {
    await instance.recordMood(mood, emoji: emoji);
  }

  Future<void> recordMood(String mood, {String? emoji}) async {
    final now = DateTime.now().toIso8601String();

    _history.insert(0, {
      'mood': mood,
      'emoji': emoji ?? '',
      'time': now,
    });

    if (_history.length > 200) {
      _history = _history.sublist(0, 200);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_history));
  }

  Future<void> clear() async {
    _history.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Map<String, int> countsLastNDays(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final Map<String, int> counts = {};

    for (final e in _history) {
      final dt = DateTime.tryParse(e['time'] ?? '');
      if (dt != null && dt.isAfter(cutoff)) {
        final mood = e['mood'] ?? 'Unknown';
        counts[mood] = (counts[mood] ?? 0) + 1;
      }
    }
    return counts;
  }
}
