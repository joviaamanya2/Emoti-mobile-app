import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//  MODELS 
class SessionType {
  final String title;
  final String subtitle;
  final int minutes;
  final IconData icon;
  final Color color;
  final List<Map<String, String>> tips;

  SessionType({
    required this.title,
    required this.subtitle,
    required this.minutes,
    required this.icon,
    required this.color,
    required this.tips,
  });
}

//  MAIN SCREEN 
class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  // ── Timer Logic ──
  Timer? _timer;
  int _currentSeconds = 25 * 60;
  int _totalDuration = 25 * 60;
  bool _isRunning = false;
  bool _isCompleted = false;

  // ── Session Presents ──
  late List<SessionType> _sessions;
  int _selectedSessionIndex = 2;

  // ── Custom Timer ──
  bool _isCustom = false;
  final List<int> _customOptions = [10, 15, 20, 30];
  int? _selectedCustomMinutes;

  // ── Tip Feedback: true = Yes (worked), false = No (didn't work), null = not answered ──
  Map<String, bool?> _tipFeedback = {};

  final Color kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);
  final Color kNoRed = const Color(0xFFDC2626);

  @override
  void initState() {
    super.initState();
    _sessions = [
      SessionType(
        title: "Quick Reset",
        subtitle: "5 min • Breathe & Center",
        minutes: 5,
        icon: Icons.restore,
        color: Colors.blue,
        tips: [
          {"title": "Look at", "desc": "Pick one single object on your desk and stare at it until your mind completely clears."},
          {"title": "Spot", "desc": "Notice 3 distinct colors in your immediate field of vision right now."},
          {"title": "Soften", "desc": "Soften your gaze by looking slightly past your screen to relax your eye muscles."},
        ],
      ),
      SessionType(
        title: "Anxiety Relief",
        subtitle: "10 min • Calm Down",
        minutes: 10,
        icon: Icons.self_improvement,
        color: Colors.teal,
        tips: [
          {"title": "Find", "desc": "Find 5 objects you can see around you and mentally trace their outer edges."},
          {"title": "Look away", "desc": "Find the furthest thing you can see outside a window and stare at it for 10 seconds."},
          {"title": "Focus on", "desc": "Focus on the physical sensation of your feet resting flat on the floor."},
        ],
      ),
      SessionType(
        title: "Deep Work",
        subtitle: "25 min • Focus Flow",
        minutes: 25,
        icon: Icons.psychology,
        color: kPrimaryGreen,
        tips: [
          {"title": "Look at", "desc": "Look at a blank wall or a plain notecard next to your keyboard when thinking."},
          {"title": "See", "desc": "Close all browser tabs except the exact one you need. Hide your taskbar."},
          {"title": "Watch", "desc": "Watch your breathing pattern for 30 seconds before writing the first line of code."},
          {"title": "Pro tip", "desc": "Drink a full glass of water before hitting start. Even a 2% hydration drop directly impairs concentration."},
        ],
      ),
      SessionType(
        title: "Long Flow",
        subtitle: "50 min • Project Zone",
        minutes: 50,
        icon: Icons.hourglass_full,
        color: Colors.orange,
        tips: [
          {"title": "Look at", "desc": "Adjust your screen brightness to perfectly match the room lighting to reduce eye strain."},
          {"title": "See", "desc": "Keep a physical timer or clock in your peripheral vision to ground your sense of time."},
          {"title": "Focus on", "desc": "Follow the 20-20-20 rule: Look at something 20 feet away every 20 minutes for 20 seconds."},
          {"title": "Pro tip", "desc": "Write down exactly one sentence defining what 'done' looks like for this session, and tape it to your monitor."},
        ],
      ),
    ];
    _setSession(2);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //  TIMER LOGIC 
  void _toggleTimer() {
    _isRunning ? _pauseTimer() : _startTimer();
  }

  void _startTimer() {
    if (_currentSeconds <= 0) {
      _resetTimer();
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        setState(() => _currentSeconds--);
      } else {
        _completeSession();
      }
    });
    setState(() {
      _isRunning = true;
      _isCompleted = false;
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _currentSeconds = _totalDuration;
      _isRunning = false;
      _isCompleted = false;
    });
  }

  void _completeSession() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isCompleted = true;
    });
    _showCompletionDialog();
  }

  //  SESSION SETTERS 
  void _setSession(int index) {
    _timer?.cancel();
    final session = _sessions[index];
    setState(() {
      _selectedSessionIndex = index;
      _isCustom = false;
      _selectedCustomMinutes = null;
      _totalDuration = session.minutes * 60;
      _currentSeconds = _totalDuration;
      _isRunning = false;
      _isCompleted = false;
      // Clears feedback when switching sessions
      _tipFeedback = {};
    });
  }

  void _setCustomTimer(int minutes) {
    _timer?.cancel();
    setState(() {
      _isCustom = true;
      _selectedCustomMinutes = minutes;
      _totalDuration = minutes * 60;
      _currentSeconds = _totalDuration;
      _isRunning = false;
      _isCompleted = false;
      // Clear feedback for custom
      _tipFeedback = {};
    });
  }

  //  TIP FEEDBACK 
  void _setTipFeedback(String tipTitle, bool? value) {
    setState(() {
      _tipFeedback[tipTitle] = value;
    });
  }

  int get _yesCount => _tipFeedback.values.where((v) => v == true).length;
  int get _noCount => _tipFeedback.values.where((v) => v == false).length;
  int get _answeredCount => _tipFeedback.values.where((v) => v != null).length;

  //  DERIVED VALUES 
  String get _timerText {
    final m = (_currentSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_currentSeconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  double get _progress => _totalDuration > 0 ? _currentSeconds / _totalDuration : 0;

  Color get _activeColor {
    if (_isCustom) return kPrimaryGreen;
    return _sessions[_selectedSessionIndex].color;
  }

  String get _activeTitle {
    if (_isCustom) return "${_selectedCustomMinutes ?? 0} min Custom";
    return _sessions[_selectedSessionIndex].title;
  }

  int get _activeMinutes {
    if (_isCustom) return _selectedCustomMinutes ?? 0;
    return _sessions[_selectedSessionIndex].minutes;
  }

  List<Map<String, String>> get _activeTips {
    if (_isCustom) return [];
    return _sessions[_selectedSessionIndex].tips;
  }

  //  COMPLETION DIALOG 
  void _showCompletionDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Container(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: kPrimaryGreen.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle_rounded, color: kPrimaryGreen, size: 60),
                ),
                const SizedBox(height: 22),
                const Text(
                  "Session Complete!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Text(
                  "Great job! You focused for $_activeMinutes minutes.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
                ),

                // Feedback summary
                if (_answeredCount > 0) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSummaryStat(
                          label: 'Worked',
                          count: _yesCount,
                          color: kPrimaryGreen,
                          icon: Icons.thumb_up_rounded,
                        ),
                        Container(width: 1, height: 40, color: Colors.grey.shade200),
                        _buildSummaryStat(
                          label: "Didn't",
                          count: _noCount,
                          color: kNoRed,
                          icon: Icons.thumb_down_rounded,
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Done",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryStat({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  //  BUILD 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text("Mindful Timer", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              //  TIMER CIRCLE 
              _buildTimerCircle(),
              const SizedBox(height: 36),

              //  SESSION CHIPS 
              _buildSessionChips(),

              //  CUSTOM TIME OPTIONS 
              if (_isCustom) ...[
                const SizedBox(height: 16),
                _buildCustomTimeOptions(),
              ],

              const SizedBox(height: 32),

              //  CONTROLS 
              _buildControls(),

              //  STATUS NOTICE 
              if (_isRunning) ...[
                const SizedBox(height: 28),
                _buildRunningNotice(),
              ] else if (_isCompleted) ...[
                const SizedBox(height: 28),
                _buildCompletedNotice(),
              ],

              //  TIPS SECTION WITH YES/NO 
              if (_activeTips.isNotEmpty) ...[
                const SizedBox(height: 36),
                _buildTipsSection(),
              ],

              //  FEEDBACK SUMMARY BAR (when any answered) 
              if (_answeredCount > 0) ...[
                const SizedBox(height: 28),
                _buildFeedbackSummaryBar(),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  //  TIMER CIRCLE 
  Widget _buildTimerCircle() {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 260,
            height: 260,
            child: CustomPaint(
              painter: _TimerPainter(progress: _progress, color: _activeColor, isCompleted: _isCompleted),
              child: const Center(),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _timerText,
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                  color: _isCompleted ? _activeColor : Colors.black87,
                  letterSpacing: -2,
                  height: 1,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _isCompleted ? _activeColor : _activeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _isCompleted ? "Done!" : _activeTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _isCompleted ? Colors.white : _activeColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //  SESSION CHIPS 
  Widget _buildSessionChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ..._sessions.asMap().entries.map((entry) {
            final idx = entry.key;
            final session = entry.value;
            final isSelected = !_isCustom && _selectedSessionIndex == idx;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: _isRunning ? null : () => _setSession(idx),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? session.color : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? session.color : Colors.grey.shade200, width: isSelected ? 2 : 1),
                    boxShadow: isSelected
                        ? [BoxShadow(color: session.color.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))]
                        : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(session.icon, color: isSelected ? Colors.white : session.color, size: 18),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(session.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: isSelected ? Colors.white : Colors.black87)),
                          Text(session.subtitle, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isSelected ? Colors.white.withOpacity(0.8) : Colors.grey.shade500)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: GestureDetector(
              onTap: _isRunning ? null : () => _setCustomTimer(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _isCustom ? kPrimaryGreen : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _isCustom ? kPrimaryGreen : Colors.grey.shade200, width: _isCustom ? 2 : 1),
                  boxShadow: _isCustom
                      ? [BoxShadow(color: kPrimaryGreen.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))]
                      : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tune_rounded, color: _isCustom ? Colors.white : kPrimaryGreen, size: 18),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Custom", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _isCustom ? Colors.white : Colors.black87)),
                        Text("Set your time", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _isCustom ? Colors.white.withOpacity(0.8) : Colors.grey.shade500)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  CUSTOM TIME OPTIONS 
  Widget _buildCustomTimeOptions() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
      child: Container(
        key: const ValueKey('customOptions'),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _customOptions.map((mins) {
            final isSelected = _selectedCustomMinutes == mins;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: _isRunning ? null : () => _setCustomTimer(mins),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimaryGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isSelected ? [BoxShadow(color: kPrimaryGreen.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))] : null,
                  ),
                  child: Text(
                    "${mins}m",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: isSelected ? Colors.white : Colors.grey.shade500),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  //  CONTROLS 
  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildControlBtn(icon: Icons.refresh_rounded, color: Colors.grey.shade400, onTap: _resetTimer),
        const SizedBox(width: 30),
        GestureDetector(
          onTap: _toggleTimer,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: _isCompleted ? kPrimaryGreen.withOpacity(0.15) : _activeColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _isCompleted ? kPrimaryGreen.withOpacity(0.15) : _activeColor.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              _isCompleted ? Icons.replay_rounded : (_isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
              color: _isCompleted ? _activeColor : Colors.white,
              size: 38,
            ),
          ),
        ),
        const SizedBox(width: 80),
      ],
    );
  }

  Widget _buildControlBtn({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
        ),
        child: Icon(icon, color: color),
      ),
    );
  }

  //  STATUS NOTICES 
  Widget _buildRunningNotice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: _activeColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _activeColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: _activeColor.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(Icons.sensors_rounded, color: _activeColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Session in progress", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _activeColor)),
                const SizedBox(height: 2),
                Text("Stay focused. Mark tips below as you go.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade500, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedNotice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: kPrimaryGreen.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kPrimaryGreen.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: kPrimaryGreen.withOpacity(0.15), shape: BoxShape.circle),
            child: const Icon(Icons.celebration_rounded, color: Colors.green, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Session complete!", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.green)),
                const SizedBox(height: 2),
                Text("Review your tip feedback below, then tap Done.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade500, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //  FEEDBACK SUMMARY BAR 
  Widget _buildFeedbackSummaryBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: kPrimaryGreen.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.pie_chart_rounded, color: Colors.green, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Your Feedback", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black87)),
                const SizedBox(height: 2),
                Text("$_answeredCount of ${_activeTips.length} tips rated", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Yes count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: kPrimaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                const SizedBox(width: 6),
                Text(_yesCount.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.green)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // No count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: kNoRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cancel_rounded, color: Colors.red, size: 16),
                const SizedBox(width: 6),
                Text(_noCount.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kNoRed)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //  TIPS SECTION 
  Widget _buildTipsSection() {
    final tips = _activeTips;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 6),
          child: Text("Boost your focus", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 16),
          child: Text("Did these work for you? Rate each one.", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
        ),
        ...tips.map((tip) => _buildTipCard(
              title: tip['title']!,
              desc: tip['desc']!,
              icon: tip['title'] == 'Pro tip' ? Icons.lightbulb_rounded : Icons.visibility_rounded,
              color: _activeColor,
            )),
      ],
    );
  }

  Widget _buildTipCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
  }) {
    final isProTip = title == 'Pro tip';
    final feedback = _tipFeedback[title]; 
    final isSelectedYes = feedback == true;
    final isSelectedNo = feedback == false;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelectedYes
            ? kPrimaryGreen.withOpacity(0.04)
            : (isSelectedNo
                ? kNoRed.withOpacity(0.04)
                : (isProTip ? color.withOpacity(0.05) : Colors.white)),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelectedYes
              ? kPrimaryGreen
              : (isSelectedNo ? kNoRed : (isProTip ? color.withOpacity(0.2) : Colors.grey.shade100)),
          width: isSelectedYes || isSelectedNo ? 2 : 1,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: icon + title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelectedYes
                      ? kPrimaryGreen.withOpacity(0.15)
                      : (isSelectedNo ? kNoRed.withOpacity(0.15) : color.withOpacity(0.1)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelectedYes
                      ? kPrimaryGreen
                      : (isSelectedNo ? kNoRed : color),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: isSelectedYes
                            ? kPrimaryGreen
                            : (isSelectedNo ? kNoRed : (isProTip ? color : Colors.black87)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelectedYes
                            ? kPrimaryGreen.withOpacity(0.7)
                            : (isSelectedNo ? kNoRed.withOpacity(0.7) : Colors.grey.shade700),
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Yes/No boxes row
          Row(
            children: [
              const Spacer(),
              // NO box
              GestureDetector(
                onTap: () => _setTipFeedback(title, isSelectedNo ? null : false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelectedNo ? kNoRed : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelectedNo ? kNoRed : Colors.grey.shade200,
                      width: isSelectedNo ? 2 : 1,
                    ),
                    boxShadow: isSelectedNo ? [BoxShadow(color: kNoRed.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3))] : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.close_rounded,
                        color: isSelectedNo ? Colors.white : Colors.grey.shade400,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "No",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isSelectedNo ? Colors.white : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // YES box
              GestureDetector(
                onTap: () => _setTipFeedback(title, isSelectedYes ? null : true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelectedYes ? kPrimaryGreen : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelectedYes ? kPrimaryGreen : Colors.grey.shade200,
                      width: isSelectedYes ? 2 : 1,
                    ),
                    boxShadow: isSelectedYes ? [BoxShadow(color: kPrimaryGreen.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3))] : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_rounded,
                        color: isSelectedYes ? Colors.white : Colors.grey.shade400,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Worked",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isSelectedYes ? Colors.white : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //  HELPERS 
}

//  CUSTOM PAINTER 
class _TimerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isCompleted;

  _TimerPainter({required this.progress, required this.color, this.isCompleted = false});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 15;
    const strokeWidth = 12.0;

    final bgPaint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    if (isCompleted) {
      final glowPaint = Paint()
        ..color = color.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 8
        ..strokeCap = StrokeCap.round;
      canvas.drawCircle(center, radius, glowPaint);

      final fullPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawCircle(center, radius, fullPaint);
    } else {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress;

      if (sweepAngle > 0) {
        final gradient = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: [color, color.withOpacity(0.6)],
        );

        final fgPaint = Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

        canvas.drawArc(rect, startAngle, sweepAngle, false, fgPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TimerPainter oldDelegate) => true;
}