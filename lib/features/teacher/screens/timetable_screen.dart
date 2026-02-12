import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:intl/intl.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Current Time Simulation (e.g., 10:15 AM)
    // In a real app, use DateTime.now()
    final currentTime = TimeOfDay.now();
    
    final List<Map<String, dynamic>> schedule = [
      {'start': const TimeOfDay(hour: 9, minute: 0), 'end': const TimeOfDay(hour: 9, minute: 50), 'subject': 'Mathematics', 'class': '10-A', 'room': '201'},
      {'start': const TimeOfDay(hour: 10, minute: 0), 'end': const TimeOfDay(hour: 10, minute: 50), 'subject': 'Physics', 'class': '12-B', 'room': 'Lab 1'},
      {'start': const TimeOfDay(hour: 11, minute: 0), 'end': const TimeOfDay(hour: 11, minute: 20), 'subject': 'Break', 'class': '-', 'room': 'Staff Room'},
      {'start': const TimeOfDay(hour: 11, minute: 30), 'end': const TimeOfDay(hour: 12, minute: 20), 'subject': 'Mathematics', 'class': '10-B', 'room': '202'},
      {'start': const TimeOfDay(hour: 13, minute: 0), 'end': const TimeOfDay(hour: 14, minute: 0), 'subject': 'Remedial', 'class': '8-A', 'room': 'Library'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Timetable', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(DateFormat('EEE, dd MMM').format(DateTime.now()), 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Today\'s Schedule', style: AppTextStyles.heading2),
          const SizedBox(height: 16),
          ...schedule.map((slot) {
            final start = slot['start'] as TimeOfDay;
            final end = slot['end'] as TimeOfDay;
            final isNow = _isTimeBetween(currentTime, start, end);
            final isPast = _isPast(currentTime, end);

            return Card(
              elevation: isNow ? 8 : 2,
              shadowColor: isNow ? Colors.blue.withOpacity(0.4) : null,
              color: isNow ? Colors.blue.shade50 : (isPast ? Colors.grey.shade100 : Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: isNow ? const BorderSide(color: Colors.blue, width: 2) : BorderSide.none,
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_formatTime(start), style: TextStyle(fontWeight: FontWeight.bold, color: isNow ? Colors.blue : Colors.black)),
                    Text(_formatTime(end), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                title: Text(slot['subject'], style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: isPast ? Colors.grey : Colors.black,
                  decoration: isPast ? TextDecoration.lineThrough : null,
                )),
                subtitle: Text(slot['class'] != '-' ? 'Class: ${slot['class']} • Room: ${slot['room']}' : 'Free Period'),
                trailing: isNow 
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                      child: const Text('NOW', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ) 
                  : (slot['class'] != '-' ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey) : null),
              ),
            );
          }),
        ],
      ),
    );
  }

  bool _isTimeBetween(TimeOfDay now, TimeOfDay start, TimeOfDay end) {
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return nowMinutes >= startMinutes && nowMinutes < endMinutes;
  }

  bool _isPast(TimeOfDay now, TimeOfDay end) {
    final nowMinutes = now.hour * 60 + now.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return nowMinutes >= endMinutes;
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
