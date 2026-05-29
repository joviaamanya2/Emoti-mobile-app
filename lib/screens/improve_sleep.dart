import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/rating_services.dart';

// ================= STORY MODEL =================
class StoryModel {
  final String title;
  final String author;
  final String reader;
  final String image;
  final List<String> pages;
  StoryModel({
    required this.title,
    required this.author,
    required this.reader,
    required this.image,
    required this.pages,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      reader: json['reader'] ?? '',
      image: json['image'] ?? '',
      pages: List<String>.from(json['pages'] ?? []),
    );
  }
}

// ================= FALLBACK STORIES =================
List<StoryModel> get fallbackStories => [
      StoryModel(
        title: "The Moon's Lullaby",
        author: "Eleanor Whitmore",
        reader: "Calm Voice",
        image:
            "https://images.unsplash.com/photo-1532693322450-2cb5c511067d?auto=format&fit=crop&w=800&q=80",
        pages: [
          "Chapter 1: The Little Star\n\nOnce upon a time, in a sky full of twinkling stars, there lived a little star named Luna. She was the smallest star in the entire galaxy, but she had the biggest dream of all.\n\nLuna wanted to sing a lullaby that could help every child on Earth fall asleep peacefully.",
          "Every night, Luna would watch the children below. She saw them tossing and turning, their eyes wide open in the dark. Some were afraid of the shadows on their walls. Others simply couldn't quiet their busy little minds.\n\n'I wish I could help them,' Luna whispered to herself, her light flickering softly.",
          "The old Moon heard Luna's wish and smiled warmly. 'Dear little one,' he said in a voice as gentle as a summer breeze, 'you don't need to be the biggest or the brightest to make a difference.'\n\n'But I'm so small,' Luna replied sadly. 'No one would hear my song.'",
          "The Moon chuckled softly. 'Close your eyes, Luna. Listen to the world below.'\n\nLuna closed her eyes and listened. She heard the whisper of wind through the trees, the distant hush of ocean waves, and the quiet breathing of sleeping animals.\n\n'Those are the quietest sounds in the world,' said the Moon, 'and yet they bring the most peace.'",
          "That night, Luna tried something new. Instead of singing loudly, she hummed the softest melody. It was so gentle that it blended with the wind and the waves.\n\nAnd something wonderful happened. One by one, the children below began to close their eyes. Their breathing slowed. Their bodies relaxed.",
          "A little girl named Mia looked up at her window and saw Luna's tiny glow. 'Goodnight, little star,' she whispered, and drifted off to sleep with a smile.\n\nLuna felt warmth spread through her tiny body. She didn't need to be the biggest star. She just needed to be the kindest one.",
          "Chapter 2: The Dream Garden\n\nBeyond the clouds, where the sky meets the edge of sleep, there is a garden that only blooms at night. It is called the Dream Garden, and its flowers are unlike any you have ever seen.\n\nEach petal holds a different dream, waiting to be carried to a sleeping child.",
          "The garden is tended by an old owl named Oliver, who wears tiny spectacles and carries a lantern made of moonlight. Every evening, Oliver walks through the rows of flowers, checking each one.\n\n'This one is a dream about flying,' he would say, patting a blue flower gently. 'And this one is about swimming with dolphins in a warm sea.'",
          "Oliver's favorite flower was a small golden one in the very center of the garden. It held the most special dream of all, a dream where nothing bad could ever happen, where everyone you loved was near, and where you felt completely safe.\n\nHe called it the Peaceful Dream, and he saved it for the children who needed it most.",
          "That night, Oliver noticed a small boy named Sam who was crying softly in his bed. Sam had had a difficult day, and his heart felt heavy.\n\nOliver picked the golden flower carefully and carried it on the gentlest breeze down to Sam's window. The flower floated in like a tiny boat on an invisible river of air.",
          "As the golden petals touched Sam's cheek, his tears dried. His breathing became slow and even. A small smile appeared on his face as the Peaceful Dream wrapped around him like a warm blanket.\n\n'There you go, little one,' whispered Oliver from above. 'Sleep well.'",
          "And so, every night, Luna sings her soft lullaby from the sky, and Oliver tends his Dream Garden, and children all over the world drift into peaceful sleep, carried by the gentle hands of those who care.\n\nThe End.\n\nClose your eyes now. Let the quiet come. You are safe, you are warm, and the little star is watching over you.\n\nGoodnight.",
        ],
      ),
      StoryModel(
        title: "The Sleepy Forest",
        author: "Thomas Hazelwood",
        reader: "Calm Voice",
        image:
            "https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=800&q=80",
        pages: [
          "Chapter 1: When the Sun Says Goodbye\n\nDeep in a valley between two soft green hills, there was a forest where every creature knew how to sleep. Not just sleep, but truly rest, the kind of rest that makes you feel brand new when morning comes.\n\nThe forest was called Whisperwood, and it had a secret.",
          "When the sun began to set, painting the sky in shades of pink and lavender, the trees of Whisperwood would begin to hum. It was a low, soft sound, like a mother humming to her baby.\n\nThe first to notice was always the little rabbit named Clover.",
          "Clover lived in a burrow beneath the oldest oak tree. Every evening, she would poke her nose out and feel the change in the air. The wind would shift from warm to cool, and the humming would begin.\n\n'Time to get ready for bed,' she would say to herself, and hop inside to fluff her nest of dried grass and soft moss.",
          "Next was Barnaby the bear. He was a big bear, but he had the gentlest heart in all of Whisperwood. As the humming grew louder, Barnaby would find his favorite spot by the stream and lie down on a bed of fallen leaves.\n\n'I'll just close my eyes for a moment,' he would say. And that moment would last until morning.",
          "The birds were the last to settle. They would fly in circles above the treetops, singing their final songs of the day. Each song was slower than the last, like a music box winding down.\n\nWhen the last note faded, the birds would tuck their heads under their wings and fall silent.",
          "Chapter 2: The Night Helper\n\nThere was one creature in Whisperwood who never slept. His name was Pip, and he was a firefly with a special gift. His light didn't blink like other fireflies. It glowed with a steady, warm pulse, like a tiny heartbeat made of gold.",
          "Pip's job was to visit every sleeping creature and make sure they were comfortable. If a bird's nest was too cold, Pip would hover nearby and add his warmth. If a fox seemed restless, Pip would dance slowly in front of its nose until its breathing steadied.",
          "Nobody had asked Pip to do this. He simply knew it was what he was meant to do. 'Some of us are meant to sleep,' he thought, 'and some of us are meant to help others sleep. Both are important.'",
          "One night, a new animal arrived in Whisperwood. It was a young deer named Fern, who had traveled far and was too anxious to rest. She kept jumping at every sound, her eyes wide and nervous.\n\nPip found her standing alone in a clearing, trembling.\n\n'You're safe here,' Pip's light seemed to say, as he drifted closer.",
          "Fern watched the little firefly's gentle glow. It pulsed slowly, like the rhythm of a calm heart. Without meaning to, Fern found her own heartbeat matching the rhythm of Pip's light.\n\nSlowly, her legs stopped trembling. Her breathing deepened. She lowered herself to the soft grass and closed her eyes.",
          "Pip stayed with her until he was sure she was deeply asleep, then moved on to his other friends. By the time the first light of dawn appeared, every creature in Whisperwood was at peace.\n\nAnd Pip, finally, allowed himself to rest inside a hollow log, his light dimming to the faintest glow.\n\nThe forest was quiet. The world was still. And everything was exactly as it should be.\n\nGoodnight, little one. The forest is sleeping, and so should you.\n\nThe End.",
        ],
      ),
      StoryModel(
        title: "Cloud Nine Express",
        author: "Lily Songbird",
        reader: "Calm Voice",
        image:
            "https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=800&q=80",
        pages: [
          "Chapter 1: The Ticket\n\nThere was a train that only appeared at bedtime. It didn't run on tracks made of steel. It ran on clouds, floating softly through the night sky.\n\nThe train was called the Cloud Nine Express, and it had one simple purpose: to carry sleepy children to the land of dreams.\n\nYou couldn't buy a ticket with money. You earned it simply by being tired and letting your eyes grow heavy.",
          "A girl named Rosie discovered the train one night when she couldn't sleep. She was lying in bed, staring at her ceiling, when she noticed something strange. A soft golden light was seeping through her window.\n\nShe pulled back the curtain and gasped. There, floating just above the treetops, was the most beautiful train she had ever seen.",
          "It was made of clouds that shimmered like pearl. Its windows glowed with warm amber light. And on its side, written in letters that seemed to be made of tiny stars, were the words: Cloud Nine Express.\n\nA small conductor stood at the door. He was no taller than a pencil and wore a uniform the color of midnight. His hat had a tiny crescent moon pinned to it.",
          "'All aboard,' he called out, his voice as soft as velvet. 'Next stop, Dreamland.'\n\nRosie didn't hesitate. She climbed onto the soft cloud-step and found herself inside the most comfortable train carriage she had ever seen.",
          "The seats were made of what felt like warm clouds. The air smelled faintly of lavender and vanilla. Tiny lights floated near the ceiling like lazy fireflies.\n\n'Welcome,' said the conductor, appearing beside her. 'Please make yourself comfortable. The journey takes exactly as long as it needs to.'",
          "Chapter 2: The Journey\n\nThe train began to move, but there was no bumping or rattling. It glided so smoothly that Rosie felt like she was floating, which, in a way, she was.\n\nThrough the window, she saw the world below. Houses with lights going out one by one. Rivers that looked like ribbons of silver. Mountains sleeping under blankets of snow.",
          "'Where do the other passengers come from?' Rosie asked.\n\n'From everywhere,' the conductor replied. 'From cities and farms, from islands and deserts. Every child who is ready for sleep finds their way here.'",
          "Rosie looked around and noticed other children in the carriage. Some were already asleep, their heads resting peacefully on the cloud-pillows. Others were gazing out the windows with heavy-lidded eyes.\n\nA little boy across from her was holding a stuffed rabbit and fighting to keep his eyes open. Every few seconds, his head would nod forward, then snap back up.\n\n'Just let go,' Rosie whispered to him. 'It's okay.'\n\nThe boy looked at her, smiled sleepily, and let his eyes close. Within moments, he was asleep.",
          "The conductor walked through the carriage, gently tucking blankets around each child. The blankets were made of something weightless and warm, like a hug that you could feel but not see.\n\nWhen he reached Rosie, he smiled. 'You're doing wonderfully,' he said. 'There's nothing you need to do. Nothing you need to figure out tonight. Just let the train carry you.'",
          "Rosie leaned back into her cloud-seat and felt the warmth wrap around her. The train's gentle motion rocked her like a cradle. The soft hum of the engine was like a lullaby she had known all her life but somehow forgotten.\n\nOutside, the stars began to blur into soft streaks of light. The train was picking up speed, but it didn't feel fast. It felt like floating in warm water.\n\nRosie's eyes closed. Her breathing became slow and deep. The last thing she felt was the conductor placing a cloud-blanket over her and whispering, 'Sweet dreams, little traveler.'\n\nThe End.\n\nYour train is here. Close your eyes and step aboard.\n\nGoodnight.",
        ],
      ),
      StoryModel(
        title: "The Ocean of Dreams",
        author: "Marina Deepwater",
        reader: "Calm Voice",
        image:
            "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
        pages: [
          "Chapter 1: Below the Waves of Sleep\n\nFar beneath the surface of the ocean, where the water is as calm as still air and the light is the color of twilight, there is a place called the Ocean of Dreams.\n\nIt is not like the ocean you know. There are no storms here, no crashing waves, no sharp rocks. Everything is soft and round and gentle.\n\nThe fish here don't swim quickly. They drift, like leaves on a quiet pond.",
          "A small whale named Pearl lived in this ocean. She was not a great big whale, not yet. She was young, with skin the color of the sky just after sunset, all purples and pinks and soft blues.\n\nEvery night, Pearl would sing a song that traveled all the way up through the water, past the fish and the coral, past the waves, and into the ears of children lying in their beds.",
          "The song had no words. It was a series of long, slow notes that rose and fell like breathing. Each note was so low and deep that you didn't so much hear it as feel it, like a warm vibration in your chest.\n\nChildren who heard Pearl's song would feel their bodies grow heavy in a good way, the way your body feels when you sink into a warm bath.",
          "One night, Pearl noticed something different. A small boy named Leo was floating above the ocean in a little boat made of moonlight. He wasn't asleep. He was looking down into the water with curious eyes.\n\n'Hello,' Pearl said, her voice echoing softly through the water.\n\nLeo leaned over the edge of his boat. 'I can hear you singing,' he said. 'It makes me feel calm.'",
          "'That's the whole point,' Pearl said with a gentle smile. 'Would you like to see where the song comes from?'\n\nLeo nodded, and Pearl breathed a circle of bubbles around him. The bubbles lifted him gently off his boat and carried him down, down, down into the Ocean of Dreams.",
          "Chapter 2: The Deep Quiet\n\nAs Leo sank deeper, the world above disappeared. There was no sky, no surface, just an endless blue that grew softer and darker and more peaceful with every meter.\n\nHe could still breathe. The water here wasn't like regular water. It was thicker, warmer, like floating in liquid silk.\n\n'Where are we going?' Leo asked, his voice sounding slow and far away.\n\n'To the deepest part,' Pearl said. 'The quietest place in the world.'",
          "They passed gardens of coral that glowed softly in shades of pink and green. They passed schools of jellyfish that pulsed with light like slow-motion fireworks. Everything moved slowly here, as if time itself had decided to take a deep breath and relax.\n\nFinally, they reached the bottom. It was completely flat and covered in something that looked like soft white sand but felt like the softest pillow you could imagine.\n\nLeo sank into it and felt his whole body let go. Every muscle, every thought, every worry dissolved into the warmth beneath him.",
          "'This is where I come to sing,' Pearl said, settling beside him. 'The quiet here makes the song stronger.'\n\nLeo closed his eyes and listened. Pearl's song filled the ocean around him, and he understood now why it made children sleepy.\n\nIt wasn't just the notes. It was the feeling behind them. The feeling that everything was okay. That nothing bad could happen here. That there was nowhere else he needed to be and nothing else he needed to do.",
          "Pearl sang on and on, and Leo drifted further and further into the most peaceful sleep he had ever known. The ocean held him safely, warmly, like a mother holding her child.\n\nAnd far above, on the surface, Leo's body lay in his bed, a small smile on his face, while Pearl's song echoed in his dreams.\n\nThe End.\n\nLet yourself sink now. The water is warm. The song is playing. You are safe.\n\nGoodnight.",
        ],
      ),
    ];

// ================= SLEEP TIPS DATA =================
final List<Map<String, dynamic>> _sleepTipsData = [
  {
    "icon": Icons.phone_android_rounded,
    "title": "Reduce blue light exposure",
    "description": "Turn off electronic screens at least 1 hour before bed to help your brain produce melatonin naturally",
    "color": Color(0xFF64FFDA),
  },
  {
    "icon": Icons.schedule_rounded,
    "title": "Maintain consistency",
    "description": "Go to sleep and wake up at the same time every day, even on weekends, to regulate your body's internal clock",
    "color": Color(0xFF7C4DFF),
  },
  {
    "icon": Icons.ac_unit_rounded,
    "title": "Cool bedroom environment",
    "description": "Keep your bedroom temperature around 65°F (18°C) for optimal sleep conditions",
    "color": Color(0xFF42A5F5),
  },
  {
    "icon": Icons.coffee_rounded,
    "title": "Limit caffeine intake",
    "description": "Avoid caffeine at least 6 hours before bedtime as it can stay in your system for hours",
    "color": Color(0xFFAB47BC),
  },
  {
    "icon": Icons.dark_mode_rounded,
    "title": "Create dark environment",
    "description": "Use blackout curtains or an eye mask to eliminate light that can disrupt your sleep cycle",
    "color": Color(0xFF5C6BC0),
  },
  {
    "icon": Icons.self_improvement_rounded,
    "title": "Practice relaxation",
    "description": "Try deep breathing, meditation, or gentle stretching before bed to calm your mind and body",
    "color": Color(0xFF26A69A),
  },
];

// ================= STORY BOOK SCREEN =================
class StoryBookScreen extends StatefulWidget {
  final StoryModel story;
  const StoryBookScreen({super.key, required this.story});

  @override
  State<StoryBookScreen> createState() => _StoryBookScreenState();
}

class _StoryBookScreenState extends State<StoryBookScreen>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isBookOpen = false;

  late PageController _pageController;
  int _currentPageIndex = 0;

  final FlutterTts _tts = FlutterTts();
  bool _isReading = false;
  bool _isTtsReady = false;
  bool _isPreparingVoice = false;
  double _speechRate = 0.35;

  late AnimationController _waveController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
        duration: const Duration(milliseconds: 1100), vsync: this);
    _flipAnimation = Tween<double>(begin: 0, end: -math.pi).animate(
      CurvedAnimation(
          parent: _flipController, curve: Curves.easeInOutCubic),
    );

    _pageController = PageController();

    _waveController = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this)
      ..repeat();

    _pulseController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this)
      ..repeat(reverse: true);

    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage("en-US");
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(0.72);
      await _tts.setVolume(0.9);
      await _tts.awaitSpeakCompletion(false);

      _tts.setStartHandler(() {
        if (mounted) {
          setState(() {
            _isReading = true;
            _isPreparingVoice = false;
          });
        }
      });

      _tts.setCompletionHandler(() {
        if (!mounted) return;
        if (_currentPageIndex < widget.story.pages.length - 1) {
          Future.delayed(const Duration(milliseconds: 900), () {
            if (mounted && _isReading) {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut);
            }
          });
        } else {
          setState(() => _isReading = false);
        }
      });

      _tts.setErrorHandler((msg) {
        debugPrint("TTS Error: $msg");
        if (mounted) {
          setState(() {
            _isReading = false;
            _isPreparingVoice = false;
          });
        }
      });

      if (mounted) setState(() => _isTtsReady = true);
    } catch (e) {
      debugPrint("TTS Init Error: $e");
      if (mounted) setState(() => _isTtsReady = false);
    }
  }

  Future<void> _speakCurrentPage() async {
    if (!_isTtsReady) return;
    try {
      await _tts.speak(widget.story.pages[_currentPageIndex]);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isReading = false;
          _isPreparingVoice = false;
        });
      }
    }
  }

  void _startCalmReading() {
    if (!_isTtsReady) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Voice reading not available on this device"),
        backgroundColor: Colors.orangeAccent,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() => _isPreparingVoice = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted && _isPreparingVoice) {
        _speakCurrentPage();
      }
    });
  }

  void _toggleReading() {
    if (!_isTtsReady) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Voice reading not available on this device"),
        backgroundColor: Colors.orangeAccent,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    if (_isReading) {
      _tts.stop();
      setState(() {
        _isReading = false;
        _isPreparingVoice = false;
      });
    } else {
      _startCalmReading();
    }
  }

  void _openBook() {
    _flipController.forward().then((_) {
      if (mounted) {
        setState(() => _isBookOpen = true);
        // Voice is NOT started automatically - user must tap the button
      }
    });
  }

  void _closeBook() {
    _tts.stop();
    setState(() {
      _isReading = false;
      _isPreparingVoice = false;
    });
    _flipController.reverse().then((_) {
      if (mounted) Navigator.pop(context);
    });
  }

  void _cycleSpeed() {
    setState(() {
      if (_speechRate == 0.35) {
        _speechRate = 0.45;
      } else if (_speechRate == 0.45) {
        _speechRate = 0.25;
      } else {
        _speechRate = 0.35;
      }
    });
    _tts.setSpeechRate(_speechRate);
  }

  String get _speedLabel {
    if (_speechRate == 0.35) return "Calm";
    if (_speechRate == 0.45) return "Normal";
    return "Slow";
  }

  @override
  void dispose() {
    _tts.stop();
    _flipController.dispose();
    _pageController.dispose();
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bookW = size.width * 0.92;
    final bookH = size.height * 0.82;

    return Scaffold(
      backgroundColor: const Color(0xFF080E1A),
      body: SafeArea(
        child: Stack(
          children: [
            if (_isBookOpen)
              Positioned.fill(
                  child: AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    colors: [
                      (_isReading
                              ? const Color(0xFFFFF8E1)
                              : const Color(0xFF1A237E))
                          .withOpacity(_isReading ? 0.09 : 0.04),
                      Colors.transparent,
                    ],
                    radius: 0.7,
                  ),
                ),
              )),

            if (!_isBookOpen)
              Positioned.fill(
                  child: IgnorePointer(
                      child:
                          CustomPaint(painter: _StarPainter(), size: Size.infinite))),

            if (_isBookOpen)
              Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle),
                    child: IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white70, size: 20),
                        onPressed: _closeBook),
                  )),

            if (_isBookOpen)
              Positioned(
                  top: 18,
                  left: 0,
                  right: 0,
                  child: Text(
                    widget.story.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5),
                  )),

            Center(
              child: SizedBox(
                width: bookW,
                height: bookH,
                child: Stack(
                  children: [
                    _buildReadingView(bookW, bookH),
                    AnimatedBuilder(
                      animation: _flipAnimation,
                      builder: (context, child) {
                        final a = _flipAnimation.value;
                        return Transform(
                          alignment: Alignment.centerLeft,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.0012)
                            ..rotateY(a),
                          child: Opacity(
                            opacity: a.abs() > math.pi / 2 ? 0.0 : 1.0,
                            child: _buildCover(bookW, bookH),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 40,
              offset: const Offset(0, 20)),
          BoxShadow(
              color: const Color(0xFF64FFDA).withOpacity(0.08), blurRadius: 60),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(widget.story.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: const Color(0xFF1A237E))),
            Container(
                decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.75)
                  ],
                  stops: const [0.3, 1.0]),
            )),
            Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                    width: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent
                          ]),
                    ))),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isTtsReady)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF64FFDA).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF64FFDA).withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.headphones_rounded,
                              size: 14, color: Color(0xFF64FFDA)),
                          const SizedBox(width: 6),
                          const Text("Optional voice available",
                              style: TextStyle(
                                  color: Color(0xFF64FFDA),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                  Container(
                      width: 36,
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                          color: const Color(0xFF64FFDA),
                          borderRadius: BorderRadius.circular(2))),
                  Text(widget.story.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          height: 1.2)),
                  const SizedBox(height: 6),
                  Text("by ${widget.story.author}",
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text("${widget.story.pages.length} pages",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 28),
                  GestureDetector(
                    onTap: _openBook,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF64FFDA),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF64FFDA).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8))
                        ],
                      ),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.menu_book_rounded,
                                color: Color(0xFF0A1628), size: 20),
                            SizedBox(width: 8),
                            Text("Open Story",
                                style: TextStyle(
                                    color: Color(0xFF0A1628),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900)),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingView(double w, double h) {
    const pageColor = Color(0xFFFDF6E3);
    const textBrown = Color(0xFF3E2723);
    const accentBrown = Color(0xFF8D6E63);

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: pageColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 40,
              offset: const Offset(0, 20))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                    width: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.brown.withOpacity(0.18),
                            Colors.brown.withOpacity(0.06),
                            Colors.transparent
                          ],
                          stops: const [0.0, 0.4, 1.0]),
                    ))),
            Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                    width: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.transparent,
                        Colors.brown.withOpacity(0.06)
                      ]),
                    ))),

            PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.story.pages.length,
              onPageChanged: (idx) {
                final wasReading = _isReading;
                if (wasReading) _tts.stop();
                setState(() {
                  _currentPageIndex = idx;
                  _isPreparingVoice = false;
                });
                if (wasReading) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted && _isReading) _speakCurrentPage();
                  });
                }
              },
              itemBuilder: (context, idx) =>
                  _buildPageContent(idx, textBrown),
            ),

            if (_currentPageIndex > 0)
              Positioned(
                  left: 6,
                  top: 0,
                  bottom: 80,
                  child: GestureDetector(
                    onTap: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut),
                    child: Center(
                        child: _pageArrow(
                            Icons.chevron_left_rounded, textBrown)),
                  )),
            if (_currentPageIndex < widget.story.pages.length - 1)
              Positioned(
                  right: 6,
                  top: 0,
                  bottom: 80,
                  child: GestureDetector(
                    onTap: () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut),
                    child: Center(
                        child: _pageArrow(
                            Icons.chevron_right_rounded, textBrown)),
                  )),

            Positioned(
                bottom: 76,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.story.pages.length, (i) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentPageIndex == i ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentPageIndex == i
                            ? accentBrown
                            : accentBrown.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                )),

            Positioned(
                bottom: 92,
                right: 18,
                child: Text("${_currentPageIndex + 1}",
                    style: TextStyle(
                        color: textBrown.withOpacity(0.2),
                        fontSize: 11,
                        fontWeight: FontWeight.w700))),

            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFEBE9),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x1A5D4037),
                          blurRadius: 8,
                          offset: Offset(0, -1))
                    ],
                  ),
                  child: Row(
                    children: [
                      // Optional voice button
                      if (_isTtsReady)
                        GestureDetector(
                          onTap: _toggleReading,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _isReading
                                  ? accentBrown
                                  : _isPreparingVoice
                                      ? accentBrown.withOpacity(0.3)
                                      : accentBrown.withOpacity(0.12),
                              shape: BoxShape.circle,
                              boxShadow: _isReading
                                  ? [
                                      BoxShadow(
                                          color: accentBrown.withOpacity(0.35),
                                          blurRadius: 16)
                                    ]
                                  : null,
                            ),
                            child: _isPreparingVoice
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: accentBrown,
                                    ),
                                  )
                                : Icon(
                                    _isReading
                                        ? Icons.pause_rounded
                                        : Icons.headphones_rounded,
                                    color: _isReading
                                        ? Colors.white
                                        : accentBrown,
                                    size: 21),
                          ),
                        ),
                      if (_isTtsReady) const SizedBox(width: 14),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isPreparingVoice
                                ? "Preparing voice…"
                                : _isReading
                                    ? "Listening with voice…"
                                    : _isTtsReady
                                        ? "Optional: Tap 👈 for voice"
                                        : "Reading silently",
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: _isReading || _isPreparingVoice
                                    ? const Color(0xFF4E342E)
                                    : const Color(0xFF4E342E)
                                        .withOpacity(0.45)),
                          ),
                          const SizedBox(height: 3),
                          SizedBox(
                            height: 14,
                            child: _isReading
                                ? AnimatedBuilder(
                                    animation: _waveController,
                                    builder: (c, _) => Row(
                                        children: List.generate(12, (i) {
                                          final phase =
                                              _waveController.value *
                                                  2 *
                                                  math.pi +
                                                  i * 0.55;
                                          return Container(
                                            margin:
                                                const EdgeInsets.only(right: 1.8),
                                            width: 2.4,
                                            height: 2.5 +
                                                (math.sin(phase) + 1) * 5,
                                            decoration: BoxDecoration(
                                              color: accentBrown
                                                  .withOpacity(0.45),
                                              borderRadius:
                                                  BorderRadius.circular(1.5),
                                            ),
                                          );
                                        })))
                                : _isPreparingVoice
                                    ? AnimatedBuilder(
                                        animation: _pulseController,
                                        builder: (c, _) => Row(
                                            children: List.generate(12, (i) {
                                              final phase =
                                                  _pulseController.value *
                                                      math.pi +
                                                      i * 0.3;
                                              return Container(
                                                margin:
                                                    const EdgeInsets.only(
                                                        right: 1.8),
                                                width: 2.4,
                                                height: 2.5 +
                                                    math.max(
                                                        0, math.sin(phase)) *
                                                        3,
                                                decoration: BoxDecoration(
                                                  color: accentBrown
                                                      .withOpacity(0.25),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1.5),
                                                ),
                                              );
                                            })))
                                    : Row(
                                        children: List.generate(12, (i) {
                                          return Container(
                                            margin:
                                                const EdgeInsets.only(right: 1.8),
                                            width: 2.4,
                                            height: 2.5,
                                            decoration: BoxDecoration(
                                              color: accentBrown
                                                  .withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(1.5),
                                            ),
                                          );
                                        })),
                          ),
                        ],
                      )),
                      if (_isTtsReady && _isReading)
                        GestureDetector(
                          onTap: _cycleSpeed,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: accentBrown.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: accentBrown.withOpacity(0.15)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _speedLabel,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: accentBrown,
                                      letterSpacing: 0.5),
                                ),
                                Text(
                                  "${_speechRate.toStringAsFixed(2)}x",
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: accentBrown),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _pageArrow(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: Colors.brown.withOpacity(0.08), shape: BoxShape.circle),
      child: Icon(icon, color: color.withOpacity(0.45), size: 26),
    );
  }

  Widget _buildPageContent(int idx, Color textColor) {
    final text = widget.story.pages[idx];
    final lines = text.split('\n');

    return Padding(
      padding: const EdgeInsets.only(
          left: 42, right: 28, top: 44, bottom: 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Container(
                  width: 36,
                  height: 1.2,
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                      color: const Color(0xFF8D6E63).withOpacity(0.25),
                      borderRadius: BorderRadius.circular(1)))),
          Expanded(
              child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines.map((line) {
                if (line.startsWith("Chapter")) {
                  return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Center(
                          child: Text(line,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF5D4037),
                                  letterSpacing: 2.5))));
                }
                if (line.trim().isEmpty) return const SizedBox(height: 12);
                final isDialogue = line.trim().startsWith("'") ||
                    line.trim().startsWith('"') ||
                    line.trim().startsWith('\u2018');
                return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(line,
                        style: TextStyle(
                            fontSize: 16.5,
                            height: 1.75,
                            letterSpacing: 0.15,
                            fontWeight:
                                isDialogue ? FontWeight.w600 : FontWeight.w500,
                            color: textColor)));
              }).toList(),
            ),
          )),
          Center(
              child: Container(
                  width: 18,
                  height: 1.2,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                      color: const Color(0xFF8D6E63).withOpacity(0.18),
                      borderRadius: BorderRadius.circular(1)))),
        ],
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    for (int i = 0; i < 60; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = rng.nextDouble() * 1.2 + 0.3;
      canvas.drawCircle(
          Offset(x, y),
          r,
          Paint()
            ..color =
                Colors.white.withOpacity(rng.nextDouble() * 0.4 + 0.1));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ================= SLEEP SCREEN =================
class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  int _selectedTab = 0;

  List<StoryModel> _stories = [];
  bool _isLoadingStories = true;

  // Timer variables
  Timer? _sleepTimer;
  int _selectedHours = 8;
  int _remainingSeconds = 0;
  bool _isTimerRunning = false;
  bool _timerCompleted = false;

  final List<int> _hourOptions = [6, 7, 8, 9, 10, 11, 12];

  final Map<int, List<Map<String, String>>> _youtubeData = {
    1: [
      {
        "title": "Heavy Rain for Sleep",
        "subtitle": "10 Hours • Black Screen",
        "image":
            "https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?auto=format&fit=crop&w=800&q=80",
        "youtubeId": "eKFTSSKCzWA"
      },
      {
        "title": "Ocean Waves at Night",
        "subtitle": "8 Hours • 4K",
        "image":
            "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
        "youtubeId": "tN2ZsEGLy5g"
      },
      {
        "title": "Thunderstorm Sleep Sounds",
        "subtitle": "8 Hours • HD",
        "image":
            "https://images.unsplash.com/photo-1505953585279-90e7f4254f4c?auto=format&fit=crop&w=800&q=80",
        "youtubeId": "W0LHTWG-UmQ"
      },
      {
        "title": "Forest Rain & Wind",
        "subtitle": "10 Hours • Loop",
        "image":
            "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&q=80",
        "youtubeId": "2OEL4P1Rz04"
      },
    ],
    2: [
      {
        "title": "Guided Sleep Meditation",
        "subtitle": "20 mins • Deep Sleep",
        "image":
            "https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=800&q=80",
        "youtubeId": "inpok4MKVLM"
      },
      {
        "title": "Body Scan for Sleep",
        "subtitle": "15 mins • Relaxation",
        "image":
            "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
        "youtubeId": "i8MxI8MNcJk"
      },
      {
        "title": "Let Go of Anxiety",
        "subtitle": "25 mins • Calm Mind",
        "image":
            "https://images.unsplash.com/photo-1473448912268-2022ce9509d8?auto=format&fit=crop&w=800&q=80",
        "youtubeId": "eKcGx_3f7vg"
      },
    ],
    3: [
      {
        "title": "Whispered Bedtime Story",
        "subtitle": "Soft Spoken • 30 mins",
        "image":
            "https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=800&q=80",
        "youtubeId": "Lw5eB18sUQg"
      },
      {
        "title": "Gentle Tapping & Brushing",
        "subtitle": "ASMR • No Talking",
        "image":
            "https://images.unsplash.com/photo-1500462918059-b1a0cb512f1d?auto=format&fit=crop&w=800&q=80",
        "youtubeId": "bJVGQiXQoAI"
      },
      {
        "title": "Page Turning ASMR",
        "subtitle": "Book Sounds • Relaxing",
        "image":
            "https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?auto=format&fit=crop&w=800&q=80",
        "youtubeId": "mX2RRHhOYqE"
      },
    ],
  };

  final List<String> _tabTitles = [
    "Stories",
    "White Noise",
    "Meditation",
    "ASMR",
    "Tips"
  ];
  final List<IconData> _tabIcons = [
    Icons.auto_stories_rounded,
    Icons.water_drop_rounded,
    Icons.self_improvement_rounded,
    Icons.hearing_rounded,
    Icons.lightbulb_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadStories() async {
    setState(() => _isLoadingStories = true);
    final data = await RatingService.getStorybooks(limit: 20);
    if (mounted) {
      setState(() {
        final parsed = data.map((j) => StoryModel.fromJson(j)).toList();
        _stories = parsed.isNotEmpty ? parsed : fallbackStories;
        _isLoadingStories = false;
      });
    }
  }

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  void _showTimerPicker() {
    int tempSelected = _selectedHours;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF1A237E),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(Icons.bedtime_rounded, color: Color(0xFF64FFDA), size: 22),
                        SizedBox(width: 10),
                        Text(
                          "Set Sleep Timer",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Minimum 6 hours recommended for adults",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Hour selector
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(28),
                              onTap: () {
                                if (tempSelected > 6) {
                                  setModalState(() => tempSelected--);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.remove_circle_outline_rounded,
                                  color: Color(0xFF64FFDA),
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Column(
                            children: [
                              Text(
                                "$tempSelected",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 52,
                                  fontWeight: FontWeight.w900,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "HOURS",
                                style: TextStyle(
                                  color: Color(0xFF64FFDA),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(28),
                              onTap: () {
                                if (tempSelected < 12) {
                                  setModalState(() => tempSelected++);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: Color(0xFF64FFDA),
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Quick select options
                    const Text(
                      "Quick Select",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _hourOptions.map((hours) {
                        final isSelected = tempSelected == hours;
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => setModalState(() => tempSelected = hours),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? const Color(0xFF64FFDA)
                                    : Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF64FFDA)
                                      : Colors.white.withOpacity(0.15),
                                ),
                              ),
                              child: Text(
                                "${hours}h",
                                style: TextStyle(
                                  color: isSelected 
                                      ? const Color(0xFF0A1628)
                                      : Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  "Cancel",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() => _selectedHours = tempSelected);
                                Navigator.pop(context);
                                _startTimer();
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF64FFDA),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF64FFDA).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.play_arrow_rounded, color: Color(0xFF0A1628), size: 20),
                                    SizedBox(width: 6),
                                    Text(
                                      "Start Timer",
                                      style: TextStyle(
                                        color: Color(0xFF0A1628),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _startTimer() {
    _timerCompleted = false;
    _remainingSeconds = _selectedHours * 3600;

    _sleepTimer?.cancel();
    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        setState(() {
          _isTimerRunning = false;
          _timerCompleted = true;
          _remainingSeconds = 0;
        });
        _showCompletionNotification();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });
    });

    setState(() {
      _isTimerRunning = true;
    });
    
    // Show a snackbar to let user know timer started
    // They can choose to browse content or just sleep
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.timer_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Sleep timer started! Browse content below or just relax.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF64FFDA),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _stopTimer() {
    _sleepTimer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _remainingSeconds = 0;
      _timerCompleted = false;
    });
  }

  void _showCompletionNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.bedtime_rounded, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Sleep timer completed! Time to wake up refreshed.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF64FFDA),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _openYouTube(String videoId) async {
    final uri = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Could not open YouTube."),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgGradient = LinearGradient(
        colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle),
                      child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context)),
                    ),
                    const SizedBox(width: 20),
                    const Text("Improve Sleep",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              ),

              // Sleep Goal Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.06),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bedtime_rounded,
                              color: Color(0xFF64FFDA), size: 16),
                          SizedBox(width: 6),
                          Text("SLEEP GOAL",
                              style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text("$_selectedHours hours",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Text("/ $_selectedHours hours Goal",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _isTimerRunning ? 1.0 - (_remainingSeconds / (_selectedHours * 3600)) : 0.0,
                          minHeight: 5,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation(
                              Color(0xFF64FFDA)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Timer Display
                      if (_isTimerRunning)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _stopTimer,
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: const Color(0xFF64FFDA).withOpacity(0.2)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.timer_rounded,
                                          color: Color(0xFF64FFDA), size: 20),
                                      const SizedBox(width: 10),
                                      Text(
                                        _formatDuration(_remainingSeconds),
                                        style: const TextStyle(
                                          color: Color(0xFF64FFDA),
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.stop_rounded,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else if (_timerCompleted)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _showTimerPicker,
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF64FFDA).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: const Color(0xFF64FFDA).withOpacity(0.3)),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_rounded,
                                      color: Color(0xFF64FFDA), size: 22),
                                  SizedBox(width: 10),
                                  Text(
                                    "Great job! Set new timer",
                                    style: TextStyle(
                                      color: Color(0xFF64FFDA),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _showTimerPicker,
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF64FFDA).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: const Color(0xFF64FFDA).withOpacity(0.2)),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.timer_rounded,
                                      color: Color(0xFF64FFDA), size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    "Set Sleep Timer",
                                    style: TextStyle(
                                      color: Color(0xFF64FFDA),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: List.generate(_tabTitles.length, (i) {
                    final active = _selectedTab == i;
                    return Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => setState(() => _selectedTab = i),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: active
                                  ? Colors.white.withOpacity(0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: active
                                      ? const Color(0xFF64FFDA)
                                      : Colors.transparent,
                                  width: 1),
                            ),
                            child: Column(children: [
                              Icon(_tabIcons[i],
                                  color: active
                                      ? const Color(0xFF64FFDA)
                                      : Colors.white54,
                                  size: active ? 22 : 18),
                              const SizedBox(height: 3),
                              Text(_tabTitles[i],
                                  style: TextStyle(
                                      color: active
                                          ? Colors.white
                                          : Colors.white54,
                                      fontWeight: active
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 10)),
                            ]),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),

              // Tab Content
              Expanded(
                  child: _selectedTab == 0
                      ? _buildStoriesList()
                      : _selectedTab == _tabTitles.length - 1
                          ? _buildSleepTips()
                          : _buildYouTubeList()),

              if (_selectedTab != 0 && _selectedTab != _tabTitles.length - 1)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.open_in_new_rounded,
                          size: 14,
                          color: Colors.white.withOpacity(0.4)),
                      const SizedBox(width: 6),
                      Text("Opens in YouTube for high quality audio",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoriesList() {
    if (_isLoadingStories) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF64FFDA)));
    }

    if (_stories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_stories_outlined,
                size: 48, color: Colors.white.withOpacity(0.2)),
            const SizedBox(height: 16),
            Text("No storybooks available",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text("Check back later for new stories",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.25), fontSize: 13)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _loadStories,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: const Color(0xFF64FFDA).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text("Refresh",
                    style: TextStyle(
                        color: Color(0xFF64FFDA),
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _stories.length,
      itemBuilder: (context, index) => _buildStoryCard(_stories[index]),
    );
  }

  Widget _buildStoryCard(StoryModel story) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => StoryBookScreen(story: story))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.04)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.network(story.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFF1A237E))),
              Container(
                  decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.25),
                      Colors.black.withOpacity(0.7)
                    ]),
              )),
              Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                      width: 22,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent
                        ]),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20)),
                      ))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(children: [
                          const Icon(Icons.auto_stories_rounded,
                              color: Color(0xFF64FFDA), size: 18),
                          const SizedBox(width: 6),
                          const Text("STORYBOOK",
                              style: TextStyle(
                                  color: Color(0xFF64FFDA),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5)),
                        ]),
                        const SizedBox(height: 10),
                        Text(story.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                height: 1.2)),
                        const SizedBox(height: 4),
                        Text("by ${story.author}",
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        Row(children: [
                          Icon(Icons.menu_book_rounded,
                              color: Colors.white.withOpacity(0.5), size: 13),
                          const SizedBox(width: 4),
                          Text(
                              "${story.pages.length} pages • Read or listen",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ]),
                      ],
                    )),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          color: const Color(0xFF64FFDA).withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF64FFDA)
                                  .withOpacity(0.4))),
                      child: const Icon(Icons.menu_book_rounded,
                          color: Color(0xFF64FFDA), size: 22),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYouTubeList() {
    final items = _youtubeData[_selectedTab] ?? [];
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => _openYouTube(item['youtubeId']!),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(item['image']!),
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    Color.fromRGBO(0, 0, 0, 0.4), BlendMode.darken),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item['title']!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text(item['subtitle']!,
                          style: const TextStyle(
                              color: Color(0xFF64FFDA),
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ],
                  )),
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.redAccent.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 30),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSleepTips() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _sleepTipsData.length,
      itemBuilder: (context, index) {
        final tip = _sleepTipsData[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (tip['color'] as Color).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: (tip['color'] as Color).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  tip['icon'] as IconData,
                  color: tip['color'] as Color,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tip['description'] as String,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}