# Laravel <-> Flutter sync checklist (Mood + Testimonials)

## Flutter (this repo)
- [x] Point API base URL to `http://127.0.0.1:8001/api`
- [x] Add `lib/services/api_service.dart` implementing:
  - [ ] `sendMood(label, emoji)`
  - [ ] `fetchTestimonials(moodFilter)`
- [ ] Ensure `emotion_dashboard.dart` imports `api_service.dart`
- [ ] Run `flutter analyze` / `flutter run`

## Laravel (backend)
- [ ] Create migrations:
  - `moods` table (user_id, mood, emoji, created_at)
  - `testimonials` table (mood, name, avatar_url, content, what_worked, days_ago, rating)
- [ ] Create models + controllers:
  - `MoodController@store`
  - `TestimonialController@index`
- [ ] Add routes in `routes/api.php`:
  - `POST /api/moods`
  - `GET /api/testimonials?mood=...`
- [ ] Seed testimonials
- [ ] Test endpoints with curl/postman

