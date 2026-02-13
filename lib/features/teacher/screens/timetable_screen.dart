import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:admin_app/core/services/school_class_service.dart';

class TimetableScreen extends StatefulWidget {
  final String teacherName;
  const TimetableScreen({super.key, this.teacherName = 'Amit Verma'});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  String _selectedDay = 'Mon';
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final Map<String, String> _fullDayNames = {
    'Mon': 'Monday', 'Tue': 'Tuesday', 'Wed': 'Wednesday', 'Thu': 'Thursday', 'Fri': 'Friday', 'Sat': 'Saturday'
  };

  List<Map<String, dynamic>> _fullSchedule = [];

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
    // Filter schedule for selected day
    final dayName = _fullDayNames[_selectedDay];
    final schedule = _fullSchedule.where((slot) => slot['day'] == dayName).toList();
    
    // Sort by period
    schedule.sort((a, b) => (a['period'] as int).compareTo(b['period'] as int));

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
              // Calculate Time based on Period (Assuming 1 hour periods starting at 8 AM)
              // Period 1: 08:00 - 09:00
              int period = slot['period'];
              final start = TimeOfDay(hour: 8 + period - 1, minute: 0);
              final end = TimeOfDay(hour: 8 + period, minute: 0);
              
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
                  subtitle: Text('Class: ${slot['class']} • Room: ${slot['room']}'),
                  trailing: isNow 
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                        child: const Text('NOW', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ) 
                    : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
