import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DatabaseService {
  // Save mood locally as a backup
  static Future<bool> saveMoodLocally(String mood, String emoji) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing moods or create new list
      List<String> existingMoods = prefs.getStringList('mood_history') ?? [];
      
      // Add new mood entry
      final moodEntry = json.encode({
        'mood': mood,
        'emoji': emoji,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      existingMoods.add(moodEntry);
      
      // Save back to preferences
      await prefs.setStringList('mood_history', existingMoods);
      return true;
    } catch (e) {
      print('Error saving mood locally: $e');
      return false;
    }
  }
  
  // Get local mood history
  static Future<List<Map<String, dynamic>>> getLocalMoodHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> moodStrings = prefs.getStringList('mood_history') ?? [];
      
      return moodStrings.map((moodStr) => json.decode(moodStr) as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting local mood history: $e');
      return [];
    }
  }
  
  // Save testimonials locally for offline access
  static Future<bool> saveTestimonialsLocally(List<Map<String, dynamic>> testimonials) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final testimonialsJson = testimonials.map((t) => json.encode(t)).toList();
      await prefs.setStringList('testimonials', testimonialsJson);
      return true;
    } catch (e) {
      print('Error saving testimonials locally: $e');
      return false;
    }
  }
  
  // Get local testimonials
  static Future<List<Map<String, dynamic>>> getLocalTestimonials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> testimonialsStrings = prefs.getStringList('testimonials') ?? [];
      
      return testimonialsStrings.map((tStr) => json.decode(tStr) as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting local testimonials: $e');
      return [];
    }
  }
}