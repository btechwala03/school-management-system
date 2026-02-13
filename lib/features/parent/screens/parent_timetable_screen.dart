import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';

class ParentTimetableScreen extends StatefulWidget {
  const ParentTimetableScreen({super.key});

  @override
  State<ParentTimetableScreen> createState() => _ParentTimetableScreenState();
}

class _ParentTimetableScreenState extends State<ParentTimetableScreen> with SingleTickerProviderStateMixin {
  String _selectedDay = "Monday";
  final List<String> _days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

  // Mock Data: Timetable for the whole week
  final Map<String, List<Map<String, String>>> _weeklyTimetable = {
    "Monday": [
      {'time': '09:00 AM', 'subject': 'Mathematics', 'teacher': 'Mr. R. Gupta'},
      {'time': '10:00 AM', 'subject': 'Science', 'teacher': 'Ms. S. Rao'},
      {'time': '11:00 AM', 'subject': 'English', 'teacher': 'Mrs. A. Mathew'},
      {'time': '12:00 PM', 'subject': 'Lunch Break', 'teacher': '-'},
      {'time': '01:00 PM', 'subject': 'History', 'teacher': 'Mr. K. Singh'},
      {'time': '02:00 PM', 'subject': 'Computer', 'teacher': 'Ms. P. Desai'},
    ],
    "Tuesday": [
      {'time': '09:00 AM', 'subject': 'Science', 'teacher': 'Ms. S. Rao'},
      {'time': '10:00 AM', 'subject': 'Mathematics', 'teacher': 'Mr. R. Gupta'},
      {'time': '11:00 AM', 'subject': 'Geography', 'teacher': 'Mr. K. Singh'},
      {'time': '12:00 PM', 'subject': 'Lunch Break', 'teacher': '-'},
      {'time': '01:00 PM', 'subject': 'English', 'teacher': 'Mrs. A. Mathew'},
      {'time': '02:00 PM', 'subject': 'Music', 'teacher': 'Mr. D. Silva'},
    ],
    "Wednesday": [
      {'time': '09:00 AM', 'subject': 'English', 'teacher': 'Mrs. A. Mathew'},
      {'time': '10:00 AM', 'subject': 'History', 'teacher': 'Mr. K. Singh'},
      {'time': '11:00 AM', 'subject': 'Mathematics', 'teacher': 'Mr. R. Gupta'},
      {'time': '12:00 PM', 'subject': 'Lunch Break', 'teacher': '-'},
      {'time': '01:00 PM', 'subject': 'Science', 'teacher': 'Ms. S. Rao'},
      {'time': '02:00 PM', 'subject': 'PT', 'teacher': 'Mr. Y. Khan'},
    ],
    "Thursday": [
      {'time': '09:00 AM', 'subject': 'Mathematics', 'teacher': 'Mr. R. Gupta'},
      {'time': '10:00 AM', 'subject': 'Science', 'teacher': 'Ms. S. Rao'},
      {'time': '11:00 AM', 'subject': 'Hindi', 'teacher': 'Mrs. K. Sharma'},
      {'time': '12:00 PM', 'subject': 'Lunch Break', 'teacher': '-'},
      {'time': '01:00 PM', 'subject': 'Computer', 'teacher': 'Ms. P. Desai'},
      {'time': '02:00 PM', 'subject': 'Library', 'teacher': 'Mrs. L. George'},
    ],
    "Friday": [
      {'time': '09:00 AM', 'subject': 'Science', 'teacher': 'Ms. S. Rao'},
      {'time': '10:00 AM', 'subject': 'Mathematics', 'teacher': 'Mr. R. Gupta'},
      {'time': '11:00 AM', 'subject': 'English', 'teacher': 'Mrs. A. Mathew'},
      {'time': '12:00 PM', 'subject': 'Lunch Break', 'teacher': '-'},
      {'time': '01:00 PM', 'subject': 'Social Studies', 'teacher': 'Mr. K. Singh'},
      {'time': '02:00 PM', 'subject': 'Art', 'teacher': 'Ms. R. Sen'},
    ],
    "Saturday": [
      {'time': '09:00 AM', 'subject': 'Activites', 'teacher': 'All Staff'},
      {'time': '10:00 AM', 'subject': 'Sports', 'teacher': 'Mr. Y. Khan'},
      {'time': '11:00 AM', 'subject': 'Club Meeting', 'teacher': '-'},
      {'time': '12:00 PM', 'subject': 'Dispersal', 'teacher': '-'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Class Timetable', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Day Selector
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final day = _days[index];
                final isSelected = day == _selectedDay;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDay = day),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: isSelected 
                        ? [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                        : [BoxShadow(color: Colors.grey.shade100, blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildTimetableList(_selectedDay),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableList(String day) {
    final timetable = _weeklyTimetable[day] ?? [];

    if (timetable.isEmpty) {
      return Center(child: Text("No classes for $day"));
    }

    return ListView.separated(
      key: ValueKey(day),
      padding: const EdgeInsets.all(20),
      itemCount: timetable.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final slot = timetable[index];
        final isBreak = slot['subject'] == 'Lunch Break' || slot['subject'] == 'Dispersal';
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isBreak ? const Color(0xFFFFF3E0) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isBreak ? Colors.orange.shade200 : Colors.white
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isBreak ? Colors.orange.shade100 : const Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  slot['time']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isBreak ? Colors.deepOrange : const Color(0xFF4FACFE),
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slot['subject']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                    ),
                    if (!isBreak) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.person_outline_rounded, size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            slot['teacher']!,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
              if (!isBreak)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
                  child: Icon(Icons.class_outlined, size: 20, color: Colors.grey.shade400),
                ),
            ],
          ),
        );
      },
    );
  }
}
