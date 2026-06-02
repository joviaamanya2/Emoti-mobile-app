import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

const Color kPrimaryGreen = Color.fromARGB(255, 99, 235, 104);

// ================= DATA MODELS =================
class Counselor {
  final String id;
  final String name;
  final String gender;
  final String specialty;
  final String imageUrl;
  final double rating;
  final int sessions;
  final bool isAllocated;
  final bool isAvailable;
  final String preferredContact;

  Counselor({
    required this.id,
    required this.name,
    required this.gender,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.sessions,
    this.isAllocated = false,
    this.isAvailable = false,
    this.preferredContact = 'Video Call',
  });

  factory Counselor.fromJson(Map<String, dynamic> json) {
    return Counselor(
      id: json['id'].toString(),
      name: json['name'],
      gender: json['gender'],
      specialty: json['specialty'],
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150',
      rating: double.parse(json['rating'].toString()),
      sessions: json['sessions'] ?? 0,
      isAllocated: json['is_allocated'] ?? false,
      isAvailable: json['is_available'] ?? false,
      preferredContact: json['preferred_contact'] ?? 'Video Call',
    );
  }
}

class AllocationNotification {
  final String message;
  final String date;
  final String contactMethod;
  final String scheduleNote;
  final bool isRead;

  AllocationNotification({
    required this.message,
    required this.date,
    required this.contactMethod,
    required this.scheduleNote,
    this.isRead = false,
  });
}

class CounselorAppointment {
  final String id;
  final String patientName;
  final String patientPhone;
  final String patientEmail;
  final String service;
  final DateTime appointmentDate;
  final String appointmentTime;
  String status;
  final String? notes;
  final String? address;

  CounselorAppointment({
    required this.id,
    required this.patientName,
    required this.patientPhone,
    required this.patientEmail,
    required this.service,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    this.notes,
    this.address,
  });

  factory CounselorAppointment.fromJson(Map<String, dynamic> json) {
    return CounselorAppointment(
      id: json['id'].toString(),
      patientName: json['patient_name'] ?? '',
      patientPhone: json['patient_phone'] ?? '',
      patientEmail: json['patient_email'] ?? '',
      service: json['service'] ?? '',
      appointmentDate: DateTime.parse(json['appointment_date']),
      appointmentTime: json['appointment_time'] ?? '',
      status: json['status'] ?? 'pending',
      notes: json['notes'],
      address: json['address'],
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final appointment = DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day);
    final tomorrow = now.add(const Duration(days: 1));
    if (appointment.year == tomorrow.year && appointment.month == tomorrow.month && appointment.day == tomorrow.day) {
      return 'Tomorrow';
    }
    return DateFormat('MMM d, yyyy').format(appointmentDate);
  }

  bool get isTomorrow {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    return appointmentDate.year == tomorrow.year && appointmentDate.month == tomorrow.month && appointmentDate.day == tomorrow.day;
  }

  bool get isPast {
    final now = DateTime.now();
    final parts = appointmentTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final appointmentDateTime = DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day, hour, minute);
    return now.isAfter(appointmentDateTime);
  }
}

// ================= MAIN SCREEN =================
class CounselorsScreen extends StatefulWidget {
  const CounselorsScreen({super.key});

  @override
  State<CounselorsScreen> createState() => _CounselorsScreenState();
}

class _CounselorsScreenState extends State<CounselorsScreen> {
  String _selectedGender = 'All';
  bool _isCounselorsLoading = true;
  List<Counselor> _allCounselors = [];
  String? _counselorsError;
  AllocationNotification? _adminNotification;
  int _currentPage = 1;
  final int _itemsPerPage = 3;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _serviceController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final _formSectionKey = GlobalKey();
  bool _isSubmitting = false;
  bool _showFormSuccess = false;

  final _counselorFormKey = GlobalKey<FormState>();
  final _counselorNameController = TextEditingController();
  final _counselorEmailController = TextEditingController();
  final _counselorContactController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _specificationController = TextEditingController();
  final _sessionNotesController = TextEditingController();
  File? _screenshotFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isCounselorSubmitting = false;

  List<CounselorAppointment> _counselorAppointments = [];
  bool _isAppointmentsLoading = false;

  List<Map<String, dynamic>> _userAppointments = [];
  bool _isUserAppointmentsLoading = false;
  String? _userAppointmentsError;

  @override
  void initState() {
    super.initState();
    _fetchCounselorsFromApi();
    _loadCounselorAppointments();
    _loadUserAppointments();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _serviceController.dispose();
    _notesController.dispose();
    _counselorNameController.dispose();
    _counselorEmailController.dispose();
    _counselorContactController.dispose();
    _clientNameController.dispose();
    _specificationController.dispose();
    _sessionNotesController.dispose();
    super.dispose();
  }

  Future<void> _loadUserAppointments() async {
  setState(() {
    _isUserAppointmentsLoading = true;
    _userAppointmentsError = null;
  });

  try {
    final appointments = await ApiService().fetchUserAppointments();

    setState(() {
      _userAppointments = List<Map<String, dynamic>>.from(appointments);
      _isUserAppointmentsLoading = false;
    });
  } catch (e) {
    setState(() {
      _userAppointmentsError =
          'Failed to load your appointments. Please try again.';
      _isUserAppointmentsLoading = false;
    });
  }
}

  Future<void> _loadCounselorAppointments() async {
    setState(() => _isAppointmentsLoading = true);
    try {
      final appointments = await ApiService().fetchCounselorAppointments();
      setState(() {
        _counselorAppointments = appointments.map((json) => CounselorAppointment.fromJson(json)).toList();
        _isAppointmentsLoading = false;
      });
    } catch (e) {
      setState(() => _isAppointmentsLoading = false);
    }
  }

  Future<void> _fetchCounselorsFromApi() async {
    setState(() {
      _isCounselorsLoading = true;
      _counselorsError = null;
    });
    try {
      final data = await ApiService().fetchCounselors();
      setState(() {
        _allCounselors = data.map((json) => Counselor.fromJson(json)).toList();
        final allocated = _getAllocatedCounselor();
        if (allocated != null) {
          _adminNotification = AllocationNotification(
            message: 'Admin has assigned ${allocated.name} (${allocated.id}) as your dedicated counselor.',
            date: 'Today, ${DateFormat('h:mm a').format(DateTime.now().subtract(const Duration(minutes: 12)))}',
            contactMethod: allocated.preferredContact,
            scheduleNote: 'Sessions available Mon–Fri, 9 AM – 5 PM',
          );
        }
        _isCounselorsLoading = false;
      });
    } catch (e) {
      setState(() {
        _counselorsError = 'Failed to load counselors. Please check your connection.';
        _isCounselorsLoading = false;
      });
    }
  }

  Future<void> _submitAppointment() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
      );
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both date and time'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final formattedTime = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final allocatedCounselor = _getAllocatedCounselor();

      final appointmentData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'patientName': _nameController.text.trim(),
        'patientPhone': _contactController.text.trim(),
        'patientEmail': _emailController.text.trim(),
        'service': _serviceController.text.trim(),
        'address': _addressController.text.trim(),
        'appointmentDate': formattedDate,
        'appointmentTime': formattedTime,
        'status': 'pending',
        'notes': _notesController.text.trim(),
        'counselorId': allocatedCounselor?.id ?? 'pending_assignment',
        'submittedAt': DateTime.now().toIso8601String(),
      };

      try {
        print('Allocated counselor: ${allocatedCounselor?.name}');
        print('Allocated counselor ID: ${allocatedCounselor?.id}');
        final counselorId = allocatedCounselor?.id;
        final success = await ApiService().bookAppointment(
          counselorId: counselorId != null ? int.tryParse(counselorId.toString()) ?? 0 : 0,
          contactNumber: _contactController.text.trim(),
          email: _emailController.text.trim(),
          address: _addressController.text.trim(),
          notes: _notesController.text.trim(),
          service: _serviceController.text.trim(),
          appointmentDate: formattedDate,
          appointmentTime: formattedTime,
        );

        if (!success) {
          setState(() => _isSubmitting = false);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit appointment. Please try again.'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
          );
          return;
        }
      } catch (e) {
        setState(() => _isSubmitting = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit appointment: ${e.toString().replaceAll('Exception: ', '')}'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
        );
        return;
      }

      setState(() {
        _isSubmitting = false;
        _showFormSuccess = true;
        _userAppointments.insert(0, appointmentData);
      });

      _nameController.clear();
      _contactController.clear();
      _emailController.clear();
      _addressController.clear();
      _serviceController.clear();
      _notesController.clear();
      setState(() {
        _selectedDate = null;
        _selectedTime = null;
      });

      if (!mounted) return;
      _showAppointmentSuccessDialog(appointmentData, allocatedCounselor);

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showFormSuccess = false);
      });
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
      );
    }
  }

  void _showAppointmentSuccessDialog(Map<String, dynamic> appointment, Counselor? counselor) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: kPrimaryGreen.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, color: kPrimaryGreen, size: 48),
              ),
              const SizedBox(height: 20),
              const Text('Appointment Submitted!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black87), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(
                counselor != null
                    ? 'Your appointment request with ${counselor.name} has been submitted successfully.'
                    : 'Your appointment request has been submitted. An admin will assign a counselor to you shortly.',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryRow('Service', appointment['service'] ?? ''),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Date', DateFormat('MMM dd, yyyy').format(DateTime.parse(appointment['appointmentDate']))),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Time', _formatTime12Hour(appointment['appointmentTime'])),
                    if (appointment['notes'] != null && appointment['notes'].toString().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildSummaryRow('Notes', appointment['notes']),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
                        child: const Text('Close', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        _showMyAppointmentsSheet();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(color: kPrimaryGreen, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: kPrimaryGreen.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]),
                        child: const Text('View My Requests', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
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

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87))),
      ],
    );
  }

  void _acceptAppointment(String appointmentId) async {
    try {
      final success = await ApiService().updateAppointmentStatus(appointmentId, 'confirmed');
      if (success) {
        setState(() {
          final idx = _counselorAppointments.indexWhere((a) => a.id == appointmentId);
          if (idx != -1) _counselorAppointments[idx].status = 'confirmed';
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment accepted'), backgroundColor: kPrimaryGreen, behavior: SnackBarBehavior.floating));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update appointment status'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
    }
  }

  void _cancelAppointment(String appointmentId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Appointment?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to cancel this appointment? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep', style: TextStyle(fontWeight: FontWeight.w700))),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final success = await ApiService().updateAppointmentStatus(appointmentId, 'cancelled');
                if (success) {
                  setState(() => _counselorAppointments.removeWhere((a) => a.id == appointmentId));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment cancelled'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to cancel appointment'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
                }
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
              }
            },
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickScreenshot(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(source: source, imageQuality: 85);
      if (picked != null) setState(() => _screenshotFile = File(picked.path));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to pick image: $e'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
    }
  }

  void _removeScreenshot() => setState(() => _screenshotFile = null);

  Future<void> _submitCounselorSessionLog() async {
    if (!_counselorFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all required fields'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
      return;
    }
    if (_screenshotFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please upload a session screenshot'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
      return;
    }

    setState(() => _isCounselorSubmitting = true);
    try {
      final success = await ApiService().submitCounselorSessionLog(
        counselorName: _counselorNameController.text.trim(),
        counselorEmail: _counselorEmailController.text.trim(),
        counselorContact: _counselorContactController.text.trim(),
        clientName: _clientNameController.text.trim(),
        specification: _specificationController.text.trim(),
        sessionNotes: _sessionNotesController.text.trim(),
        screenshotFile: _screenshotFile!,
      );
      if (success) {
        _counselorNameController.clear();
        _counselorEmailController.clear();
        _counselorContactController.clear();
        _clientNameController.clear();
        _specificationController.clear();
        _sessionNotesController.clear();
        setState(() => _screenshotFile = null);
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session log submitted successfully!'), backgroundColor: kPrimaryGreen, behavior: SnackBarBehavior.floating));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to submit session log'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
    } finally {
      setState(() => _isCounselorSubmitting = false);
    }
  }

  Future<void> _callPatient(String phone) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(launchUri)) await launchUrl(launchUri);
  }

  Future<void> _emailPatient(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(launchUri)) await launchUrl(launchUri);
  }

  List<Counselor> get _filteredCounselors {
    if (_selectedGender == 'All') return _allCounselors.where((c) => !c.isAllocated).toList();
    return _allCounselors.where((c) => !c.isAllocated && c.gender == _selectedGender).toList();
  }

  List<Counselor> get _paginatedCounselors {
    final filtered = _filteredCounselors;
    final start = (_currentPage - 1) * _itemsPerPage;
    if (start >= filtered.length) return [];
    final end = (start + _itemsPerPage).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  int get _totalPages {
    final count = _filteredCounselors.length;
    if (count == 0) return 1;
    return (count / _itemsPerPage).ceil();
  }

  int get _pendingCount => _counselorAppointments.where((a) => a.status == 'pending').length;

  Counselor? _getAllocatedCounselor() {
    try {
      return _allCounselors.firstWhere((c) => c.isAllocated);
    } catch (e) {
      return null;
    }
  }

  void _scrollToForm() {
    final ctx = _formSectionKey.currentContext;
    if (ctx != null) Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
  }

  void _showCounselorAppointmentsPanel() {
    _loadCounselorAppointments().then((_) {
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => StatefulBuilder(
          builder: (context, setSheetState) => Container(
            height: MediaQuery.of(context).size.height * 0.92,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(color: Color(0xFF7C3AED), borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
                    child: Column(
                      children: [
                        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), borderRadius: BorderRadius.circular(4)))),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 22)),
                            const SizedBox(width: 14),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Tomorrow's Schedule", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)), const SizedBox(height: 2), Text('${_counselorAppointments.length} appointments', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.8)))])),
                            if (_pendingCount > 0) Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.pending_actions_rounded, color: Color(0xFFF59E0B), size: 14), const SizedBox(width: 4), Text('$_pendingCount pending', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFD97706)))])),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_adminNotification != null) Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), decoration: const BoxDecoration(color: Color(0xFFEFF6FF), border: Border(bottom: BorderSide(color: Color(0xFFBFDBFE)))), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(7), decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle), child: const Icon(Icons.notifications_active_rounded, color: Colors.white, size: 15)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Text('Admin Notification', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF1E40AF))), const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)), child: const Text('New', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF16A34A), letterSpacing: 0.5)))]), const SizedBox(height: 4), Text(_adminNotification!.message, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF334155), height: 1.45), maxLines: 2, overflow: TextOverflow.ellipsis), const SizedBox(height: 6), Text(_adminNotification!.date, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))]))])),
                  Expanded(child: _isAppointmentsLoading ? const Center(child: CircularProgressIndicator()) : _counselorAppointments.isEmpty ? _buildNoAppointmentsState() : ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), itemCount: _counselorAppointments.length, itemBuilder: (context, index) => _buildAppointmentCard(_counselorAppointments[index], setSheetState))),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showMyAppointmentsSheet() {
    _loadUserAppointments().then((_) {
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: Column(
              children: [
                Container(padding: const EdgeInsets.all(20), decoration: const BoxDecoration(color: kPrimaryGreen, borderRadius: BorderRadius.vertical(top: Radius.circular(28))), child: Column(children: [Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), borderRadius: BorderRadius.circular(4)))), const SizedBox(height: 16), Row(children: [const Icon(Icons.history_rounded, color: Colors.white, size: 24), const SizedBox(width: 12), const Text("My Appointment Requests", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)), const Spacer(), GestureDetector(onTap: () { Navigator.pop(context); _loadUserAppointments(); }, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18)))]), const SizedBox(height: 4), Text('${_userAppointments.length} total requests', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.8)))])),
                Expanded(child: _isUserAppointmentsLoading ? const Center(child: CircularProgressIndicator()) : _userAppointments.isEmpty ? _buildNoUserAppointments() : ListView.builder(padding: const EdgeInsets.all(16), itemCount: _userAppointments.length, itemBuilder: (context, index) => _buildUserAppointmentCard(_userAppointments[index]))),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNoUserAppointments() {
    return Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(children: [Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: kPrimaryGreen.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.event_available_rounded, size: 48, color: kPrimaryGreen)), const SizedBox(height: 20), const Text('No Appointments Yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)), const SizedBox(height: 8), const Text('Submit your first appointment request below!', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey)), if (_userAppointmentsError != null) ...[const SizedBox(height: 20), Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFFECACA))), child: Row(children: [const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 18), const SizedBox(width: 10), Expanded(child: Text(_userAppointmentsError!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF991B1B), height: 1.4))), GestureDetector(onTap: _loadUserAppointments, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFDC2626), borderRadius: BorderRadius.circular(8)), child: const Text('Retry', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800))))]))]])));
  }
Widget _buildUserAppointmentCard(Map<String, dynamic> appointment) {
  // ✅ Handle both snake_case and camelCase keys
  final status = (appointment['status'] ?? appointment['status'] ?? 'pending') as String;
  final isPending = status == 'pending';
  final isCancelled = status == 'cancelled';

  if (isCancelled) return const SizedBox.shrink();

  // ✅ Handle both date formats
  DateTime appointmentDate;
  try {
    final dateStr = appointment['appointmentDate'] ?? appointment['appointment_date'] ?? '';
    appointmentDate = DateTime.parse(dateStr);
  } catch (_) {
    appointmentDate = DateTime.now();
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: isPending ? const Color(0xFFFFFBEB) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: isPending ? const Color(0xFFFDE68A) : kPrimaryGreen, width: 1.5),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: isPending ? const Color(0xFFF59E0B) : kPrimaryGreen, borderRadius: BorderRadius.circular(8)),
                child: Text(isPending ? 'Pending' : 'Confirmed', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
              Text(
                DateFormat('MMM dd').format(appointmentDate),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(appointment['service'] ?? appointment['service'] ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                _formatTime12Hour(appointment['appointmentTime'] ?? appointment['appointment_time'] ?? ''),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
            ],
          ),
          if (appointment['notes'] != null && appointment['notes'].toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              appointment['notes'],
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade500, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    ),
  );
}
  Widget _buildNoAppointmentsState() {
    return Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(children: [Container(padding: const EdgeInsets.all(20), decoration: const BoxDecoration(color: Color(0xFFF8F7FF), shape: BoxShape.circle), child: const Icon(Icons.event_available_rounded, size: 48, color: Color(0xFF7C3AED))), const SizedBox(height: 20), const Text('No Appointments for Tomorrow', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)), const SizedBox(height: 8), const Text('Your schedule is clear for tomorrow.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey)), const SizedBox(height: 20), ElevatedButton.icon(onPressed: _loadCounselorAppointments, icon: const Icon(Icons.refresh_rounded, size: 18), label: const Text('Refresh', style: TextStyle(fontWeight: FontWeight.w800)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))])));
  }

  Widget _buildAppointmentCard(CounselorAppointment appointment, StateSetter setSheetState) {
    final isPending = appointment.status == 'pending';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: isPending ? const Color(0xFFFFFBEB) : null, borderRadius: BorderRadius.circular(20), border: Border.all(color: isPending ? const Color(0xFFFDE68A) : kPrimaryGreen, width: isPending ? 1.5 : 1), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: isPending ? const Color(0xFFF59E0B) : kPrimaryGreen, borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(isPending ? Icons.schedule_rounded : Icons.check_circle_rounded, color: Colors.white, size: 12), const SizedBox(width: 4), Text(_formatTime12Hour(appointment.appointmentTime), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white))])), const Spacer(), _buildStatusBadge(appointment.status)]),
          const SizedBox(height: 14),
          Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7C3AED),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFF7C3AED).withOpacity(0.1),
                    child: Text(
                      appointment.patientName
                          .split(' ')
                          .map((n) => n[0])
                          .take(2)
                          .join(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        appointment.service,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
           SizedBox(height: 14),
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)), child: Column(children: [GestureDetector(onTap: () => _callPatient(appointment.patientPhone), child: Row(children: [const Icon(Icons.phone_rounded, color: Color(0xFF16A34A), size: 16), const SizedBox(width: 10), Text(appointment.patientPhone, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF16A34A).withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.call_rounded, color: Color(0xFF16A34A), size: 12), SizedBox(width: 4), Text('Call', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF16A34A)))]))])), const SizedBox(height: 10), GestureDetector(onTap: () => _emailPatient(appointment.patientEmail), child: Row(children: [const Icon(Icons.email_rounded, color: Color(0xFF0369A1), size: 16), const SizedBox(width: 10), Expanded(child: Text(appointment.patientEmail, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87), overflow: TextOverflow.ellipsis)), Icon(Icons.open_in_new_rounded, color: Colors.grey.shade400, size: 14)]))]),
          ),if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[const SizedBox(height: 12), Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFFDE68A))), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.sticky_note_2_rounded, color: Color(0xFFD97706), size: 16), const SizedBox(width: 8), Expanded(child: Text(appointment.notes!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF92400E), height: 1.4)))]))],
          if (isPending) ...[const SizedBox(height: 16), Row(children: [Expanded(child: GestureDetector(onTap: () { _acceptAppointment(appointment.id); setSheetState(() {}); }, child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: kPrimaryGreen, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: kPrimaryGreen.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.check_circle_rounded, color: Colors.white, size: 18), SizedBox(width: 6), Text('Accept', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800))])))), const SizedBox(width: 12), Expanded(child: GestureDetector(onTap: () { _cancelAppointment(appointment.id); setSheetState(() {}); }, child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.shade300)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.cancel_rounded, color: Colors.red.shade400, size: 18), const SizedBox(width: 6), Text('Cancel', style: TextStyle(color: Colors.red.shade400, fontSize: 14, fontWeight: FontWeight.w800))]))))])],
        ]),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor, textColor;
    String label;
    switch (status) {
      case 'confirmed': bgColor = const Color(0xFFDCFCE7); textColor = const Color(0xFF16A34A); label = 'Confirmed'; break;
      case 'pending': bgColor = const Color(0xFFFEF3C7); textColor = const Color(0xFFD97706); label = 'Pending'; break;
      default: bgColor = Colors.grey.shade200; textColor = Colors.grey.shade600; label = status;
    }
    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)), child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: textColor)));
  }

  String _formatTime12Hour(String time24) {
    try {
      final parts = time24.split(':');
      if (parts.length < 2) return time24;
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$hour12:$minute $period';
    } catch (_) {
      return time24;
    }
  }

  void _showCounselorSessionLogSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        height: MediaQuery.of(context).size.height * 0.92,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)))),
                const SizedBox(height: 20),
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF7C3AED).withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.2))), child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF7C3AED), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.shield_rounded, color: Colors.white, size: 22)), const SizedBox(width: 14), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Counselor Session Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF7C3AED))), SizedBox(height: 2), Text('This form is for counselors only', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey))]))])),
                const SizedBox(height: 24),
                Form(key: _counselorFormKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _buildCounselorSectionLabel('Your Details', Icons.person_rounded, const Color(0xFF7C3AED)),
                  const SizedBox(height: 12), _buildCounselorFormLabel('Full Name *'), const SizedBox(height: 8),
                  _buildCounselorFormField(controller: _counselorNameController, hint: 'Enter your full name', icon: Icons.badge_rounded, validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null),
                  const SizedBox(height: 16), _buildCounselorFormLabel('Email Address *'), const SizedBox(height: 8),
                  _buildCounselorFormField(controller: _counselorEmailController, hint: 'your@email.com', icon: Icons.email_rounded, validator: (v) { if (v == null || v.trim().isEmpty) return 'Email is required'; if (!v.contains('@')) return 'Enter a valid email'; return null; }),
                  const SizedBox(height: 16), _buildCounselorFormLabel('Contact Number *'), const SizedBox(height: 8),
                  _buildCounselorFormField(controller: _counselorContactController, hint: 'Enter your phone number', icon: Icons.phone_rounded, validator: (v) => (v == null || v.trim().isEmpty) ? 'Contact number is required' : null),
                  const SizedBox(height: 24), _buildCounselorSectionLabel('Session Details', Icons.assignment_rounded, const Color(0xFF0369A1)),
                  const SizedBox(height: 12), _buildCounselorFormLabel('Client / Patient Name *'), const SizedBox(height: 8),
                  _buildCounselorFormField(controller: _clientNameController, hint: 'Name of the person you worked with', icon: Icons.person_search_rounded, validator: (v) => (v == null || v.trim().isEmpty) ? 'Client name is required' : null),
                  const SizedBox(height: 16), _buildCounselorFormLabel('Specification / Category *'), const SizedBox(height: 8),
                  _buildCounselorFormField(controller: _specificationController, hint: 'e.g., Anxiety, Depression, PTSD', icon: Icons.category_rounded, validator: (v) => (v == null || v.trim().isEmpty) ? 'Specification is required' : null),
                  const SizedBox(height: 16), _buildCounselorFormLabel('Session Notes'), const SizedBox(height: 8),
                  _buildCounselorFormField(controller: _sessionNotesController, hint: 'Brief summary...', icon: Icons.notes_rounded, maxLines: 3),
                  const SizedBox(height: 24), _buildCounselorSectionLabel('Session Screenshot *', Icons.screenshot_rounded, const Color(0xFF16A34A)),
                  const SizedBox(height: 4), Text('Upload proof of the completed session', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
                  const SizedBox(height: 12),
                  if (_screenshotFile != null) _buildScreenshotPreview() else _buildScreenshotUploadArea(),
                  const SizedBox(height: 32),
                  GestureDetector(onTap: _isCounselorSubmitting ? null : _submitCounselorSessionLog, child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 18), decoration: BoxDecoration(gradient: _isCounselorSubmitting ? LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade300]) : const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)]), borderRadius: BorderRadius.circular(18), boxShadow: _isCounselorSubmitting ? [] : [BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))]), child: Center(child: _isCounselorSubmitting ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.upload_rounded, color: Colors.white, size: 20), SizedBox(width: 8), Text('Submit Session Log', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900))])))),
                  const SizedBox(height: 20),
                ])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounselorSectionLabel(String title, IconData icon, Color color) {
    return Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 18)), const SizedBox(width: 10), Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87))]);
  }

  Widget _buildCounselorFormLabel(String text) => Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.black87));

  Widget _buildCounselorFormField({required TextEditingController controller, required String hint, required IconData icon, String? Function(String?)? validator, int maxLines = 1}) {
    return TextFormField(controller: controller, maxLines: maxLines, validator: validator, decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20), hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2)), errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.red)), isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)));
  }

  Widget _buildScreenshotUploadArea() {
    return Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 28), decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.grey.shade200, width: 2, strokeAlign: BorderSide.strokeAlignOutside)), child: Column(children: [Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF16A34A).withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.cloud_upload_rounded, color: Color(0xFF16A34A), size: 32)), const SizedBox(height: 14), const Text('Tap to upload screenshot', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black87)), const SizedBox(height: 4), Text('PNG, JPG up to 5MB', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade500)), const SizedBox(height: 16), Row(mainAxisAlignment: MainAxisAlignment.center, children: [_buildImageSourceButton(label: 'Camera', icon: Icons.camera_alt_rounded, onTap: () => _pickScreenshot(ImageSource.camera)), const SizedBox(width: 12), _buildImageSourceButton(label: 'Gallery', icon: Icons.photo_library_rounded, onTap: () => _pickScreenshot(ImageSource.gallery))])]));
  }

  Widget _buildImageSourceButton({required String label, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: const Color(0xFF16A34A), size: 16), const SizedBox(width: 6), Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87))])));
  }

  Widget _buildScreenshotPreview() {
    return Container(width: double.infinity, decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF16A34A), width: 2)), child: Column(children: [ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.file(_screenshotFile!, height: 200, width: double.infinity, fit: BoxFit.cover)), Padding(padding: const EdgeInsets.all(14), child: Row(children: [Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFF16A34A).withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Screenshot uploaded', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.grey.shade700)), Text(_screenshotFile!.path.split('/').last, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade400), overflow: TextOverflow.ellipsis)])), const SizedBox(width: 8), GestureDetector(onTap: _removeScreenshot, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)), child: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400, size: 20)))]))]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(margin: const EdgeInsets.only(left: 16), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]), child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20), onPressed: () => Navigator.pop(context))),
        title: const Text('Your Counselor', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 20)),
        centerTitle: true,
        actions: [
          GestureDetector(onTap: _showMyAppointmentsSheet, child: Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: kPrimaryGreen.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: kPrimaryGreen.withOpacity(0.3))), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.history_rounded, color: kPrimaryGreen, size: 18), if (_userAppointments.isNotEmpty) ...[const SizedBox(width: 6), Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: kPrimaryGreen, shape: BoxShape.circle), child: Text(_userAppointments.length.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)))]]))),
          GestureDetector(onTap: _showCounselorAppointmentsPanel, child: Container(margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: const Color(0xFF7C3AED), shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.3), blurRadius: 10)]), child: Stack(children: [const Padding(padding: EdgeInsets.all(12), child: Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20)), if (_pendingCount > 0) Positioned(right: 0, top: 0, child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xFFF59E0B), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), constraints: const BoxConstraints(minWidth: 18, minHeight: 18), child: Text(_pendingCount.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800))))]))),
          Container(margin: const EdgeInsets.only(right: 16), decoration: BoxDecoration(color: const Color(0xFF7C3AED).withOpacity(0.15), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.3))), child: IconButton(icon: const Icon(Icons.shield_rounded, color: Color(0xFF7C3AED), size: 20), onPressed: _showCounselorSessionLogSheet, tooltip: 'Session Log')),
        ],
      ),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildAppointmentSection(), const SizedBox(height: 32), _buildBookingFormSection(), const SizedBox(height: 36), _buildDirectorySection(), const SizedBox(height: 20)])),
    );
  }

  Widget _buildAppointmentSection() {
    if (_isCounselorsLoading) return _buildShimmerCard();
    final allocated = _getAllocatedCounselor();
    if (allocated != null) return _buildAllocatedCard(allocated);
    return _buildNoAllocationPlaceholder();
  }

  Widget _buildShimmerCard() {
    return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_shimmerBox(width: 220, height: 24, radius: 8), const SizedBox(height: 20), Row(children: [_shimmerCircle(radius: 32), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_shimmerBox(width: 140, height: 18, radius: 6), const SizedBox(height: 8), _shimmerBox(width: 100, height: 14, radius: 6), const SizedBox(height: 6), _shimmerBox(width: 80, height: 12, radius: 6)]))]), const SizedBox(height: 18), _shimmerBox(width: double.infinity, height: 48, radius: 14)]));
  }

  Widget _shimmerBox({required double width, required double height, required double radius}) => Container(width: width, height: height, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(radius)));
  Widget _shimmerCircle({required double radius}) => Container(width: radius * 2, height: radius * 2, decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle));

  Widget _buildNoAllocationPlaceholder() {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.hourglass_top_rounded,
                color: Colors.grey,
                size: 14,
              ),
              SizedBox(width: 6),
              Text(
                'Awaiting Assignment',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'Your counselor is being assigned',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "An admin is reviewing your profile and will assign a counselor shortly. You'll be notified once assigned.",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 20),

        GestureDetector(
          onTap: _scrollToForm,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: kPrimaryGreen,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryGreen.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_downward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Book Appointment Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),

        if (_counselorsError != null) ...[
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFFECACA),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  color: Color(0xFFDC2626),
                  size: 18,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Connection issue',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFDC2626),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        _counselorsError!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF991B1B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: _fetchCounselorsFromApi,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );
}
  Widget _buildAllocatedCard(Counselor counselor) {
    return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: LinearGradient(colors: [kPrimaryGreen.withOpacity(0.12), Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24), border: Border.all(color: kPrimaryGreen.withOpacity(0.3), width: 1.5), boxShadow: [BoxShadow(color: kPrimaryGreen.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: kPrimaryGreen, borderRadius: BorderRadius.circular(8)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.verified_user_rounded, color: Colors.white, size: 14), SizedBox(width: 4), Text('Your Assigned Counselor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12))])), const Spacer(), if (counselor.isAvailable) _buildAvailableBadge()]), const SizedBox(height: 18), Row(children: [Container(padding: const EdgeInsets.all(3), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: kPrimaryGreen, width: 2)), child: CircleAvatar(radius: 32, backgroundImage: NetworkImage(counselor.imageUrl))), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(counselor.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87)), const SizedBox(height: 4), Text(counselor.specialty, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade600)), const SizedBox(height: 4), Row(children: [const Icon(Icons.star_rounded, color: Colors.amber, size: 16), const SizedBox(width: 4), Text('${counselor.rating} • ${counselor.sessions} sessions', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black54))])]))]), const SizedBox(height: 16), Row(children: [const Text('Contact via:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)), const SizedBox(width: 8), _buildContactMethodBadge(counselor.preferredContact)])]));
  }

  Widget _buildBookingFormSection() {
    return Column(key: _formSectionKey, crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: kPrimaryGreen.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.calendar_today_rounded, color: kPrimaryGreen, size: 18)), const SizedBox(width: 12), const Text('Book an Appointment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87))]), const SizedBox(height: 6), Text('Fill in your details to request a session.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade500)), const SizedBox(height: 16), AnimatedContainer(duration: const Duration(milliseconds: 500), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: _showFormSuccess ? const Color(0xFFF0FDF4) : Colors.white, borderRadius: BorderRadius.circular(24), border: _showFormSuccess ? Border.all(color: kPrimaryGreen, width: 2) : null, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))]), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [if (_showFormSuccess) ...[Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(12)), child: const Row(children: [Icon(Icons.check_circle_rounded, color: kPrimaryGreen, size: 20), SizedBox(width: 10), Expanded(child: Text('Appointment submitted successfully! Check your requests above.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF166534))))])), const SizedBox(height: 16)], const SizedBox(height: 18), _buildFormLabel('Full Name *'), const SizedBox(height: 8), _buildFormField(controller: _nameController, hint: 'Enter your full name', icon: Icons.person_rounded, validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null), const SizedBox(height: 18), _buildFormLabel('Contact Number *'), const SizedBox(height: 8), _buildFormField(controller: _contactController, hint: 'Enter your phone number', icon: Icons.phone_rounded, validator: (v) => (v == null || v.trim().isEmpty) ? 'Phone number is required' : null), const SizedBox(height: 18), _buildFormLabel('Email Address'), const SizedBox(height: 8), _buildFormField(controller: _emailController, hint: 'your@email.com (optional)', icon: Icons.email_rounded, validator: (v) { if (v != null && v.trim().isNotEmpty && !v.contains('@')) return 'Enter a valid email'; return null; }), const SizedBox(height: 18), _buildFormLabel('Address *'), const SizedBox(height: 8), _buildFormField(controller: _addressController, hint: 'Enter your location / address', icon: Icons.location_on_rounded, maxLines: 2, validator: (v) => (v == null || v.trim().isEmpty) ? 'Address is required' : null), const SizedBox(height: 18), _buildFormLabel('Service / Reason *'), const SizedBox(height: 8), _buildFormField(controller: _serviceController, hint: 'e.g., Anxiety, Depression, Stress, Relationship issues...', icon: Icons.category_rounded, validator: (v) => (v == null || v.trim().isEmpty) ? 'Service or reason is required' : null), const SizedBox(height: 18), _buildFormLabel('Preferred Schedule *'), const SizedBox(height: 8), Row(children: [Expanded(child: GestureDetector(onTap: () async { final picked = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 1)), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 60)), builder: (context, child) => Theme(data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: kPrimaryGreen).copyWith(secondary: kPrimaryGreen)), child: child!)); if (picked != null) setState(() => _selectedDate = picked); }, child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _selectedDate != null ? kPrimaryGreen : Colors.grey.shade200, width: _selectedDate != null ? 2 : 1)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(_selectedDate != null ? DateFormat('MMM dd, yyyy').format(_selectedDate!) : 'Select Date', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _selectedDate != null ? Colors.black87 : Colors.grey)), Icon(Icons.calendar_month_rounded, color: _selectedDate != null ? kPrimaryGreen : Colors.grey, size: 18)])))), const SizedBox(width: 12), Expanded(child: GestureDetector(onTap: () async { final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now(), builder: (context, child) => Theme(data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: kPrimaryGreen).copyWith(secondary: kPrimaryGreen)), child: child!)); if (picked != null) setState(() => _selectedTime = picked); }, child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _selectedTime != null ? kPrimaryGreen : Colors.grey.shade200, width: _selectedTime != null ? 2 : 1)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(_selectedTime != null ? _selectedTime!.format(context) : 'Select Time', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _selectedTime != null ? Colors.black87 : Colors.grey)), Icon(Icons.access_time_rounded, color: _selectedTime != null ? kPrimaryGreen : Colors.grey, size: 18)]))))]), if (_selectedDate == null || _selectedTime == null) Padding(padding: const EdgeInsets.only(top: 8), child: Text('Please select both date and time', style: TextStyle(fontSize: 11, color: Colors.red.shade400, fontWeight: FontWeight.w600))), const SizedBox(height: 18), _buildFormLabel('Additional Notes'), const SizedBox(height: 8), _buildFormField(controller: _notesController, hint: 'Any additional information for the counselor...', icon: Icons.edit_note_rounded, maxLines: 3), const SizedBox(height: 28), GestureDetector(onTap: _isSubmitting ? null : _submitAppointment, child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 18), decoration: BoxDecoration(gradient: _isSubmitting ? LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade300]) : LinearGradient(colors: [kPrimaryGreen, const Color.fromARGB(255, 60, 200, 65)]), borderRadius: BorderRadius.circular(18), boxShadow: _isSubmitting ? [] : [BoxShadow(color: kPrimaryGreen.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))]), child: Center(child: _isSubmitting ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.send_rounded, color: Colors.white, size: 18), SizedBox(width: 8), Text('Submit Appointment Request', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900))]))))])))]);
  }

  Widget _buildDirectorySection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.people_rounded, color: Color(0xFF2563EB), size: 18)), const SizedBox(width: 12), const Text('Counselor Directory', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87))]), const SizedBox(height: 6), Text('Browse our team of professional counselors.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade500)), const SizedBox(height: 16), if (_isCounselorsLoading) const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 40), child: CircularProgressIndicator())), if (!_isCounselorsLoading && _counselorsError != null && _allCounselors.isEmpty) _buildDirectoryEmptyError(), if (!_isCounselorsLoading && _allCounselors.isNotEmpty) ...[if (_counselorsError != null) _buildCachedBanner(), _buildGenderFilter(), const SizedBox(height: 16), if (_filteredCounselors.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 12), child: Text('Showing ${_paginatedCounselors.length} of ${_filteredCounselors.length} counselors', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade500))), if (_filteredCounselors.isEmpty) _buildEmptyFilterState(), ..._paginatedCounselors.map((c) => _buildDirectoryCard(c)), if (_filteredCounselors.isNotEmpty && _totalPages > 1) ...[const SizedBox(height: 20), _buildPaginationControls()]]]);
  }

  Widget _buildDirectoryEmptyError() {
    return Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Column(children: [Icon(Icons.cloud_off_rounded, size: 48, color: Colors.grey.shade300), const SizedBox(height: 16), Text('Could not load directory', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey.shade600)), const SizedBox(height: 8), Text('Check your connection and try again', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade400)), const SizedBox(height: 20), ElevatedButton.icon(onPressed: _fetchCounselorsFromApi, icon: const Icon(Icons.refresh_rounded, size: 18), label: const Text('Retry', style: TextStyle(fontWeight: FontWeight.w800)), style: ElevatedButton.styleFrom(backgroundColor: kPrimaryGreen, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))])));
  }

  Widget _buildCachedBanner() {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 10,
    ),
    decoration: BoxDecoration(
      color: const Color(0xFFFFFBEB),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFFFDE68A),
      ),
    ),
    child: Row(
      children: [
        const Icon(
          Icons.warning_amber_rounded,
          color: Color(0xFFD97706),
          size: 16,
        ),

        const SizedBox(width: 8),

        const Expanded(
          child: Text(
            'Showing cached data. Tap to refresh.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF92400E),
            ),
          ),
        ),

        GestureDetector(
          onTap: _fetchCounselorsFromApi,
          child: const Icon(
            Icons.refresh_rounded,
            color: Color(0xFFD97706),
            size: 18,
          ),
        ),
      ],
    ),
  );
}

  Widget _buildEmptyFilterState() {
    return Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Column(children: [Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade300), const SizedBox(height: 16), Text('No counselors found', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey.shade600)), const SizedBox(height: 8), Text('Try changing the gender filter', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade400))])));
  }

  // ✅ FIXED: Complete _buildDirectoryCard method
  Widget _buildDirectoryCard(Counselor counselor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: counselor.isAvailable ? Colors.grey.shade100 : Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 26, backgroundImage: NetworkImage(counselor.imageUrl)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(counselor.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87))),
                    const SizedBox(width: 6),
                    Icon(counselor.gender == 'Male' ? Icons.male_rounded : Icons.female_rounded, color: counselor.gender == 'Male' ? Colors.blue.shade300 : Colors.pink.shade300, size: 15),
                  ],
                ),
                const SizedBox(height: 4),
                Text(counselor.specialty, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text('${counselor.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black54)),
                    const SizedBox(width: 12),
                    Text('${counselor.sessions} sessions', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade400)),
                    if (counselor.isAvailable) ...[
                      const SizedBox(width: 12),
                      _buildAvailableBadge(),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (!counselor.isAvailable)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(10)),
              child: const Text('Unavailable', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
            ),
      )],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]), child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [_buildPageArrow(icon: Icons.chevron_left_rounded, onTap: _currentPage > 1 ? () => setState(() => _currentPage--) : null, isActive: _currentPage > 1), const SizedBox(width: 8), ..._buildPageNumbers(), const SizedBox(width: 8), _buildPageArrow(icon: Icons.chevron_right_rounded, onTap: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null, isActive: _currentPage < _totalPages)]), const SizedBox(height: 8), Text('Page $_currentPage of $_totalPages', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade500))]));
  }

  List<Widget> _buildPageNumbers() {
    final total = _totalPages;
    final pages = <int?>[];
    if (total <= 5) {
      for (int i = 1; i <= total; i++) pages.add(i);
    } else {
      pages.add(1);
      if (_currentPage > 3) pages.add(null);
      for (int i = (_currentPage - 1).clamp(2, total - 1); i <= (_currentPage + 1).clamp(2, total - 1); i++) {
        if (!pages.contains(i)) pages.add(i);
      }
      if (_currentPage < total - 2) pages.add(null);
      if (!pages.contains(total)) pages.add(total);
    }
    return pages.map((page) {
      if (page == null) return const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('...', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey, fontSize: 14)));
      final isCurrent = page == _currentPage;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
          onTap: () => setState(() => _currentPage = page),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: isCurrent ? kPrimaryGreen : Colors.transparent, borderRadius: BorderRadius.circular(10), border: isCurrent ? null : Border.all(color: Colors.grey.shade200)),
            child: Center(child: Text('$page', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: isCurrent ? Colors.white : Colors.grey.shade600))),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildPageArrow({required IconData icon, required VoidCallback? onTap, required bool isActive}) {
    return GestureDetector(onTap: onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: 36, height: 36, decoration: BoxDecoration(color: isActive ? const Color(0xFFF3F4F6) : Colors.grey.shade100, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: isActive ? Colors.black87 : Colors.grey.shade400, size: 20)));
  }

  Widget _buildGenderFilter() {
    return Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)), child: Row(children: ['All', 'Female', 'Male'].map((gender) {
      final isSelected = _selectedGender == gender;
      return Expanded(child: GestureDetector(onTap: () => setState(() { _selectedGender = gender; _currentPage = 1; }), child: AnimatedContainer(duration: const Duration(milliseconds: 300), padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: isSelected ? kPrimaryGreen : Colors.transparent, borderRadius: BorderRadius.circular(12), boxShadow: isSelected ? [BoxShadow(color: kPrimaryGreen.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : null), child: Text(gender, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, color: isSelected ? Colors.white : Colors.grey.shade600, fontSize: 14)))));
    }).toList()));
  }

  Widget _buildContactMethodBadge(String method) {
    final icons = {'Video Call': Icons.video_camera_front_rounded, 'Audio Call': Icons.phone_rounded, 'Chat': Icons.chat_rounded};
    final colors = {'Video Call': const Color(0xFF7C3AED), 'Audio Call': const Color(0xFF0369A1), 'Chat': const Color(0xFF16A34A)};
    final icon = icons[method] ?? Icons.help_outline_rounded;
    final color = colors[method] ?? Colors.grey;
    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.2), width: 1)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: color, size: 14), const SizedBox(width: 6), Text(method, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700))]));
  }

  Widget _buildAvailableBadge() {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20), border: Border.all(color: kPrimaryGreen.withOpacity(0.3))), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.circle, color: kPrimaryGreen, size: 8), SizedBox(width: 4), Text('Available', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 11, fontWeight: FontWeight.w800))]));
  }

  Widget _buildFormLabel(String text) => Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.black87));

  Widget _buildFormField({required TextEditingController controller, required String hint, required IconData icon, String? Function(String?)? validator, int maxLines = 1}) {
    return TextFormField(controller: controller, maxLines: maxLines, validator: validator, decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20), hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: kPrimaryGreen, width: 2)), errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.red)), isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)));
  }
}