// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'library.dart'; // contains ArticleItem & ThumbnailType

// class ArticleScreen extends StatefulWidget {
//   final ArticleItem article;

//   const ArticleScreen({super.key, required this.article});

//   @override
//   State<ArticleScreen> createState() => _ArticleScreenState();
// }

// class _ArticleScreenState extends State<ArticleScreen> {
//   JournalEntry? journal;

//   void openJournal() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => JournalEditor(entry: journal),
//       ),
//     );

//     if (result != null && result is JournalEntry) {
//       setState(() => journal = result);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final article = widget.article;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(article.title),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Thumbnail
//             if (article.thumbnailType == ThumbnailType.image && article.imageUrl != null)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   article.imageUrl!,
//                   width: double.infinity,
//                   height: 200,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Container(
//                     height: 200,
//                     color: Colors.grey.shade300,
//                     child: const Icon(Icons.broken_image, size: 50),
//                   ),
//                 ),
//               )
//             else if (article.thumbnailType == ThumbnailType.icon && article.iconData != null)
//               Container(
//                 width: double.infinity,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: article.iconBackgroundColor ?? Colors.grey,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Center(
//                   child: Icon(article.iconData, size: 80, color: Colors.white),
//                 ),
//               ),
//             const SizedBox(height: 16),

//             // Title
//             Text(
//               article.title,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),

//             // Description
//             Text(
//               article.description,
//               style: const TextStyle(fontSize: 16, height: 1.4),
//             ),
//             const SizedBox(height: 16),

//             // Content
//             ..._buildContentWidgets(article.content),
//             const SizedBox(height: 24),

//             // Journal button
//             ElevatedButton.icon(
//               onPressed: openJournal,
//               icon: const Icon(Icons.edit),
//               label: const Text("Create Journal"),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//                 backgroundColor: const Color(0xFF4CAF50),
//               ),
//             ),

//             if (journal != null) ...[
//               const SizedBox(height: 20),
//               const Text("Your Journal",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               const SizedBox(height: 10),
//               _journalPreview(),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildContentWidgets(String content) {
//     return content
//         .split('\n\n')
//         .map(
//           (p) => Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Text(p, style: const TextStyle(fontSize: 16, height: 1.5)),
//           ),
//         )
//         .toList();
//   }

//   Widget _journalPreview() {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.bookmark),
//               const Spacer(),
//               IconButton(
//                 icon: Icon(journal!.favorite ? Icons.star : Icons.star_border),
//                 onPressed: () => setState(() => journal!.favorite = !journal!.favorite),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.share),
//                 onPressed: () => Share.share(journal!.text),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: openJournal,
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(journal!.text),
//         ],
//       ),
//     );
//   }
// }

// /// ===== Journal Model & Editor =====
// class JournalEntry {
//   String text;
//   bool favorite;

//   JournalEntry({required this.text, this.favorite = false});
// }

// class JournalEditor extends StatefulWidget {
//   final JournalEntry? entry;

//   const JournalEditor({super.key, this.entry});

//   @override
//   State<JournalEditor> createState() => _JournalEditorState();
// }

// class _JournalEditorState extends State<JournalEditor> {
//   late TextEditingController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = TextEditingController(text: widget.entry?.text ?? "");
//   }

//   void save() {
//     if (controller.text.trim().isEmpty) return;
//     Navigator.pop(
//         context,
//         JournalEntry(
//             text: controller.text.trim(),
//             favorite: widget.entry?.favorite ?? false));
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Journal"),
//         actions: [IconButton(icon: const Icon(Icons.save), onPressed: save)],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: TextField(
//           controller: controller,
//           maxLines: null,
//           expands: true,
//           textAlignVertical: TextAlignVertical.top,
//           decoration: const InputDecoration(
//             hintText: "Write your thoughts...",
//             border: OutlineInputBorder(),
//           ),
//         ),
//       ),
//     );
//   }
// }