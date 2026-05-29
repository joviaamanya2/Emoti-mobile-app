// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../services/rating_service.dart';

// /// Call this from any screen after a session completes:
// ///
// /// ```dart
// /// SessionRatingDialog.show(
// ///   context,
// ///   sessionType: "Meditation",
// ///   sessionTitle: "Morning Calm",
// ///   moodAtStart: "Stressed",
// /// );
// /// ```
// ///
// /// It handles everything: display, animation, save to DB, dismiss.
// class SessionRatingDialog extends StatefulWidget {
//   final String sessionType;
//   final String sessionTitle;
//   final String? moodAtStart;

//   const SessionRatingDialog({
//     super.key,
//     required this.sessionType,
//     required this.sessionTitle,
//     this.moodAtStart,
//   });

//   /// Static show method — call this from anywhere
//   static Future<void> show(
//     BuildContext context, {
//     required String sessionType,
//     required String sessionTitle,
//     String? moodAtStart,
//   }) async {
//     // Prevent multiple dialogs
//     if (ModalRoute.of(context)?.isCurrent != true && Navigator.of(context).canPop() == false) return;

//     await showGeneralDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierLabel: "Session Rating",
//       barrierColor: Colors.black.withOpacity(0.6),
//       transitionDuration: const Duration(milliseconds: 400),
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return ScaleTransition(
//           scale: CurvedAnimation(
//             parent: animation,
//             curve: Curves.elasticOut,
//           ),
//           child: FadeTransition(
//             opacity: CurvedAnimation(
//               parent: animation,
//               curve: Curves.easeOut,
//             ),
//             child: child,
//           ),
//         );
//       },
//       pageBuilder: (context, _, __) {
//         return SessionRatingDialog(
//           sessionType: sessionType,
//           sessionTitle: sessionTitle,
//           moodAtStart: moodAtStart,
//         );
//       },
//     );
//   }

//   @override
//   State<SessionRatingDialog> createState() => _SessionRatingDialogState();
// }

// class _SessionRatingDialogState extends State<SessionRatingDialog> with SingleTickerProviderStateMixin {
//   int _emojiRating = 0;
//   int _starRating = 0;
//   bool _hoveringStar = false;
//   int _hoverStarIndex = 0;
//   final TextEditingController _feedbackController = TextEditingController();
//   bool _isSubmitting = false;
//   bool _isSubmitted = false;

//   late AnimationController _successController;
//   late Animation<double> _successScale;
//   late Animation<double> _checkOpacity;

//   // Visual config per session type
//   IconData get _sessionIcon {
//     switch (widget.sessionType.toLowerCase()) {
//       case 'meditation': return Icons.self_improvement_rounded;
//       case 'fitness': return Icons.fitness_center_rounded;
//       case 'counseling': return Icons.chat_bubble_rounded;
//       case 'video': case 'youtube': return Icons.play_circle_rounded;
//       case 'breathing': return Icons.air_rounded;
//       case 'sleep': return Icons.bedtime_rounded;
//       case 'focus': return Icons.center_focus_strong_rounded;
//       case 'stress': return Icons.spa_rounded;
//       default: return Icons.check_circle_rounded;
//     }
//   }

//   Color get _sessionColor {
//     switch (widget.sessionType.toLowerCase()) {
//       case 'meditation': return const Color(0xFF7C4DFF);
//       case 'fitness': return const Color(0xFFFF6B6B);
//       case 'counseling': return const Color(0xFF63EB68);
//       case 'video': case 'youtube': return const Color(0xFFFF0000);
//       case 'breathing': return const Color(0xFF5C7CFA);
//       case 'sleep': return const Color(0xFF667EEA);
//       case 'focus': return const Color(0xFFFF922B);
//       case 'stress': return const Color(0xFF5CC6A9);
//       default: return const Color(0xFF63EB68);
//     }
//   }

//   final List<Map<String, dynamic>> _emojiOptions = [
//     {'emoji': '😫', 'label': 'Terrible'},
//     {'emoji': '😟', 'label': 'Bad'},
//     {'emoji': '😐', 'label': 'Okay'},
//     {'emoji': '😊', 'label': 'Good'},
//     {'emoji': '🤩', 'label': 'Amazing'},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _successController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     _successScale = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
//     );
//     _checkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _successController, curve: Curves.easeIn),
//     );
//   }

//   @override
//   void dispose() {
//     _feedbackController.dispose();
//     _successController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitRating() async {
//     if (_emojiRating == 0) {
//       HapticFeedback.heavyImpact();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please select how you feel first"),
//           behavior: SnackBarBehavior.floating,
//           shape: StadiumBorder(),
//         ),
//       );
//       return;
//     }

//     HapticFeedback.mediumImpact();
//     setState(() => _isSubmitting = true);

//     final success = await RatingService.submitRating(
//       sessionType: widget.sessionType,
//       sessionTitle: widget.sessionTitle,
//       emojiRating: _emojiRating,
//       starRating: _starRating,
//       feedbackText: _feedbackController.text,
//       moodAtStart: widget.moodAtStart,
//     );

//     if (success) {
//       setState(() => _isSubmitted = true);
//       _successController.forward();
//       await Future.delayed(const Duration(seconds: 2));
//       if (mounted) Navigator.of(context).pop();
//     } else {
//       setState(() => _isSubmitting = false);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Couldn't save. Check your connection."),
//             behavior: SnackBarBehavior.floating,
//             shape: StadiumBorder(),
//           ),
//         );
//       }
//     }
//   }

//   void _skipRating() {
//     HapticFeedback.lightImpact();
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     if (_isSubmitted) {
//       return Center(
//         child: AnimatedBuilder(
//           animation: _successController,
//           builder: (context, child) {
//             return Transform.scale(
//               scale: _successScale.value,
//               child: Opacity(
//                 opacity: _checkOpacity.value,
//                 child: child,
//               ),
//             );
//           },
//           child: Container(
//             width: size.width * 0.8,
//             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(32),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF63EB68).withOpacity(0.3),
//                   blurRadius: 30,
//                   offset: const Offset(0, 15),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF63EB68).withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.check_rounded, color: Color(0xFF63EB68), size: 48),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   "Thank You!",
//                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50)),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "Your feedback helps us improve\nyour experience",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade500, height: 1.5),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     return Center(
//       child: Container(
//         width: size.width * 0.88,
//         constraints: BoxConstraints(maxHeight: size.height * 0.82),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(32),
//           boxShadow: [
//             BoxShadow(
//               color: _sessionColor.withOpacity(0.15),
//               blurRadius: 40,
//               offset: const Offset(0, 20),
//             ),
//           ],
//         ),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // ── Header ──
//               Container(
//                 width: 56,
//                 height: 56,
//                 decoration: BoxDecoration(
//                   color: _sessionColor.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(_sessionIcon, color: _sessionColor, size: 28),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Session Complete!",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50)),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 widget.sessionTitle,
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _sessionColor),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 28),

//               // ── Divider ──
//               Container(height: 1, color: Colors.grey.shade100),
//               const SizedBox(height: 24),

//               // ── Emoji Rating ──
//               const Text(
//                 "How do you feel now?",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2C3E50)),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 "Tap the face that matches your mood",
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade400),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(5, (index) {
//                   final isSelected = _emojiRating == index + 1;
//                   return GestureDetector(
//                     onTap: () {
//                       HapticFeedback.selectionClick();
//                       setState(() => _emojiRating = index + 1);
//                     },
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 200),
//                       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: isSelected ? _sessionColor.withOpacity(0.1) : Colors.transparent,
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: isSelected ? _sessionColor : Colors.transparent,
//                           width: 2,
//                         ),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           AnimatedScale(
//                             scale: isSelected ? 1.3 : 1.0,
//                             duration: const Duration(milliseconds: 200),
//                             child: Text(
//                               _emojiOptions[index]['emoji'],
//                               style: const TextStyle(fontSize: 32, height: 1.0, fontFamily: 'Segoe UI Emoji'),
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           AnimatedDefaultTextStyle(
//                             duration: const Duration(milliseconds: 200),
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
//                               color: isSelected ? _sessionColor : Colors.grey.shade400,
//                             ),
//                             child: Text(_emojiOptions[index]['label']),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//               const SizedBox(height: 28),

//               // ── Star Rating ──
//               const Text(
//                 "Rate this session",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2C3E50)),
//               ),
//               const SizedBox(height: 14),
//               MouseRegion(
//                 onEnter: (_) => setState(() => _hoveringStar = true),
//                 onExit: (_) => setState(() => _hoveringStar = false),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(5, (index) {
//                     final filled = _hoveringStar ? index < _hoverStarIndex : index < _starRating;
//                     return GestureDetector(
//                       onTap: () {
//                         HapticFeedback.selectionClick();
//                         setState(() => _starRating = index + 1);
//                       },
//                       onHorizontalDragUpdate: (details) {
//                         // Calculate which star based on drag position
//                         final box = context.findRenderObject() as RenderBox?;
//                         if (box != null) {
//                           final starWidth = box.size.width / 5;
//                           final localPos = details.localPosition;
//                           int newRating = (localPos.dx / starWidth).round().clamp(1, 5);
//                           if (newRating != _starRating) {
//                             setState(() => _starRating = newRating);
//                           }
//                         }
//                       },
//                       child: AnimatedScale(
//                         scale: filled ? 1.15 : 1.0,
//                         duration: const Duration(milliseconds: 150),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 4),
//                           child: Icon(
//                             filled ? Icons.star_rounded : Icons.star_outline_rounded,
//                             size: 36,
//                             color: filled ? const Color(0xFFFFD700) : Colors.grey.shade300,
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//               if (_starRating > 0) ...[
//                 const SizedBox(height: 4),
//                 Text(
//                   ["", "Poor", "Fair", "Good", "Very Good", "Excellent"][_starRating],
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFFFFD700)),
//                 ),
//               ],
//               const SizedBox(height: 24),

//               // ── Feedback Text (Optional) ──
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.grey.shade200),
//                 ),
//                 child: TextField(
//                   controller: _feedbackController,
//                   maxLines: 3,
//                   maxLength: 200,
//                   textCapitalization: TextCapitalization.sentences,
//                   decoration: InputDecoration(
//                     hintText: "What worked? What didn't? (optional)",
//                     hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade400),
//                     counterStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade400),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 28),

//               // ── Submit Button ──
//               SizedBox(
//                 width: double.infinity,
//                 height: 54,
//                 child: ElevatedButton(
//                   onPressed: _isSubmitting ? null : _submitRating,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _sessionColor,
//                     elevation: 0,
//                     disabledBackgroundColor: _sessionColor.withOpacity(0.5),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                   ),
//                   child: _isSubmitting
//                       ? const SizedBox(
//                           width: 24, height: 24,
//                           child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
//                         )
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.send_rounded, size: 20, color: Colors.white),
//                             const SizedBox(width: 8),
//                             const Text("Submit Feedback", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
//                           ],
//                         ),
//                 ),
//               ),
//               const SizedBox(height: 14),

//               // ── Skip Link ──
//               GestureDetector(
//                 onTap: _skipRating,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Text(
//                     "Skip for now",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey.shade400,
//                       decoration: TextDecoration.underline,
//                       decorationColor: Colors.grey.shade300,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // AnimatedBuilder alias for older Flutter versions
// class AnimatedBuilder extends AnimatedWidget {
//   final Widget Function(BuildContext context, Widget? child) builder;
//   final Widget? child;

//   const AnimatedBuilder({
//     super.key,
//     required super.listenable,
//     required this.builder,
//     this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return builder(context, child);
//   }
// }