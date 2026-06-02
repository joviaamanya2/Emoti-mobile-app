import 'dart:convert';
import 'package:http/http.dart' as http;
import 'database_service.dart';
import 'api_service.dart';


class RatingService {
  // ── XAMPP Base URL (Ratings, Stats — not yet migrated) ──
  static const String _baseUrl = "http://10.0.2.2/emoti_api";
  
  // ── Laravel Base URL (Storybooks) ──
  static const String _laravelBaseUrl = "http://127.0.0.1:8001/api";

  // ── SAVE SESSION RATING (still on XAMPP) ──
  static Future<bool> submitRating({
    required String userId,
    required String sessionType,
    required int emojiRating,
    required int starRating,
    String? feedbackText,
    String? sessionTitle,
    String? moodAtStart,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/save_rating.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "session_type": sessionType,
          "session_title": sessionTitle ?? "",
          "emoji_rating": emojiRating,
          "star_rating": starRating,
          "feedback_text": feedbackText ?? "",
          "mood_at_start": moodAtStart ?? "",
        }),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return data["success"] == true;
    } catch (e) {
      print("❌ Failed to save rating: $e");
      return false;
    }
  }

  // ══════════════════════════════════════════════════════
  // ── SAVE TESTIMONIAL  ✅ NOW ON LARAVEL ──
  // ══════════════════════════════════════════════════════
  static Future<bool> submitTestimonial({
    required String userId,
    required String userName,
    required String whatWorked,
    required String description,
    required int starRating,
    required String sessionType,
    required String moodWhenItWorked,
    required bool consentForPublic,
    required String displayNameType,
  }) async {
    try {
      final moodEmojis = {
        'stressed': '😰',
        'anxious': '😟',
        'sad': '😢',
        'lonely': '😔',
        'neutral': '😐',
        'calm': '😌',
        'happy': '😊',
        'energized': '⚡',
      };

      final emoji = moodEmojis[moodWhenItWorked.toLowerCase()] ?? '😊';

      final success = await ApiService().saveTestimonial(
        mood: moodWhenItWorked,
        emoji: emoji,
        text: description.isNotEmpty ? '$whatWorked. $description' : whatWorked,
      );

      if (success) {
        // Cache locally for instant UI refresh
        try {
          String cachedName = "Anonymous";
          if (consentForPublic && userName.isNotEmpty) {
            if (displayNameType == "full_name") {
              cachedName = userName;
            } else if (displayNameType == "first_name") {
              cachedName = userName.split(' ').first;
            }
          }

          final cached = [
            {
              "user_name": cachedName,
              "session_type": sessionType,
              "what_worked": whatWorked,
              "description": description,
              "star_rating": starRating,
              "mood_when_it_worked": moodWhenItWorked,
              "consent_for_public": consentForPublic ? 1 : 0,
              "display_name_type": displayNameType,
              "name": cachedName,
              "content": description,
              "mood": moodWhenItWorked,
              "whatWorked": whatWorked,
              "rating": starRating,
              "daysAgo": 0,
              "helpful_count": 0,
            },
          ];
          await DatabaseService.saveTestimonialsLocally(cached.cast<Map<String, dynamic>>());
        } catch (_) {}

        return true;
      }

      return false;
    } catch (e) {
      print("❌ Failed to save testimonial: $e");
      return false;
    }
  }

  // ══════════════════════════════════════════════════════
  // ── GET TESTIMONIALS  ✅ NOW ON LARAVEL ──
  // ══════════════════════════════════════════════════════
    static Future<List<Map<String, dynamic>>> getTestimonials({
    int limit = 10,
    String? sessionType,
    String? mood,
  }) async {
    try {
      final testimonials = await ApiService().fetchTestimonials(
        moodFilter: mood,
      );

      return testimonials.map((t) {
        return {
          'id': t['id'],
          'user_name': t['name'] ?? 'Anonymous',
          'avatar': t['avatar'] ?? '',
          'mood_when_it_worked': t['mood'] ?? 'Great',
          'what_worked': t['whatWorked'] ?? '',
          'description': t['content'] ?? '',
          'session_type': t['whatWorked'] ?? 'General',
          'star_rating': t['rating'] ?? 5,
          'daysAgo': t['daysAgo'] ?? 0,
          'helpful_count': 0,
          'display_name_type': 'anonymous',
          'name': t['name'] ?? 'Anonymous',
          'content': t['content'] ?? '',
          'mood': t['mood'] ?? 'Great',
          'whatWorked': t['whatWorked'] ?? '',
          'rating': t['rating'] ?? 5,
        };
      }).toList();
    } catch (e) {
      print("❌ Failed to get testimonials: $e");
    }

    return [];
  }

  // ── MARK AS HELPFUL (still on XAMPP) ──
  static Future<bool> markHelpful(int testimonialId) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/mark_helpful.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"testimonial_id": testimonialId}),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return data["success"] == true;
    } catch (e) {
      print("❌ Failed to mark helpful: $e");
      return false;
    }
  }

  // ── GET STORYBOOKS (Laravel on port 8001) ──
  static Future<List<Map<String, dynamic>>> getStorybooks({
    int limit = 20,
    String? category,
  }) async {
    try {
      String url = "$_laravelBaseUrl/stories?limit=$limit";
      
      if (category != null && category.isNotEmpty) {
        url += "&category=${Uri.encodeComponent(category)}";
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      
      if (data["data"] != null) {
        return List<Map<String, dynamic>>.from(data["data"]);
      }
      
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      
      return [];
    } catch (e) {
      print("❌ Failed to get stories: $e");
      return [];
    }
  }

  // ── GET SESSION STATS (still on XAMPP) ──
  static Future<Map<String, dynamic>> getSessionStats(String sessionType) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/get_stats.php?session_type=$sessionType"),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      if (data["success"] == true) {
        return {
          "avg_emoji": data["avg_emoji"] ?? 0.0,
          "avg_star": data["avg_star"] ?? 0.0,
          "total": data["total"] ?? 0,
        };
      }
    } catch (e) {
      print("❌ Failed to get stats: $e");
    }
    return {"avg_emoji": 0.0, "avg_star": 0.0, "total": 0};
  }
}