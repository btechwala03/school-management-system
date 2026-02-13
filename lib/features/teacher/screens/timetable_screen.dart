import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:intl/intl.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  String _selectedDay = 'Mon';
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  // Mock Data: Weekly Schedule
  final Map<String, List<Map<String, dynamic>>> _weeklySchedule = {
    'Mon': [
      {'start': const TimeOfDay(hour: 9, minute: 0), 'end': const TimeOfDay(hour: 9, minute: 50), 'subject': 'Mathematics', 'class': '10-A', 'room': '201'},
      {'start': const TimeOfDay(hour: 10, minute: 0), 'end': const TimeOfDay(hour: 10, minute: 50), 'subject': 'Physics', 'class': '12-B', 'room': 'Lab 1'},
      {'start': const TimeOfDay(hour: 11, minute: 30), 'end': const TimeOfDay(hour: 12, minute: 20), 'subject': 'Mathematics', 'class': '10-B', 'room': '202'},
    ],
    'Tue': [
      {'start': const TimeOfDay(hour: 9, minute: 0), 'end': const TimeOfDay(hour: 9, minute: 50), 'subject': 'Science', 'class': '8-A', 'room': '101'},
      {'start': const TimeOfDay(hour: 11, minute: 30), 'end': const TimeOfDay(hour: 12, minute: 20), 'subject': 'Mathematics', 'class': '10-A', 'room': '201'},
      {'start': const TimeOfDay(hour: 14, minute: 0), 'end': const TimeOfDay(hour: 14, minute: 50), 'subject': 'Remedial', 'class': '10-B', 'room': 'Library'},
    ],
    'Wed': [
       {'start': const TimeOfDay(hour: 10, minute: 0), 'end': const TimeOfDay(hour: 10, minute: 50), 'subject': 'Physics', 'class': '12-B', 'room': 'Lab 1'},
       {'start': const TimeOfDay(hour: 12, minute: 0), 'end': const TimeOfDay(hour: 12, minute: 50), 'subject': 'Free Period', 'class': '-', 'room': 'Staff Room'},
    ],
    'Thu': [
      {'start': const TimeOfDay(hour: 9, minute: 0), 'end': const TimeOfDay(hour: 9, minute: 50), 'subject': 'Mathematics', 'class': '10-B', 'room': '202'},
      {'start': const TimeOfDay(hour: 10, minute: 0), 'end': const TimeOfDay(hour: 10, minute: 50), 'subject': 'Science', 'class': '8-A', 'room': '101'},
    ],
    'Fri': [
      {'start': const TimeOfDay(hour: 9, minute: 0), 'end': const TimeOfDay(hour: 9, minute: 50), 'subject': 'Mathematics', 'class': '10-A', 'room': '201'},
      {'start': const TimeOfDay(hour: 10, minute: 0), 'end': const TimeOfDay(hour: 10, minute: 50), 'subject': 'Club Activity', 'class': 'All', 'room': 'Ground'},
    ],
    'Sat': [
      {'start': const TimeOfDay(hour: 9, minute: 0), 'end': const TimeOfDay(hour: 11, minute: 0), 'subject': 'Special Class', 'class': '10-A', 'room': '201'},
    ],
  };

  @override
  void initState() {
    super.initState();
    // Auto-select current day if valid
    String currentDay = DateFormat('E').format(DateTime.now());
    if (_days.contains(currentDay)) {
      _selectedDay = currentDay;
    }
  }

  @override
  Widget build(BuildContext context) {
    final schedule = _weeklySchedule[_selectedDay] ?? [];
    final currentTime = TimeOfDay.now();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Timetable', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final day = _days[index];
                final isSelected = day == _selectedDay;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDay = day;
                    });
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      day,
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: schedule.isEmpty 
        ? Center(child: Text('No classes on $_selectedDay', style: const TextStyle(color: Colors.grey)))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: schedule.length,
            itemBuilder: (context, index) {
              final slot = schedule[index];
              final start = slot['start'] as TimeOfDay;
              final end = slot['end'] as TimeOfDay;
              
              // Only highlight if it's actually today
              bool isToday = DateFormat('E').format(DateTime.now()) == _selectedDay;
              final isNow = isToday && _isTimeBetween(currentTime, start, end);
              final isPast = isToday && _isPast(currentTime, end);

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
            },
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
