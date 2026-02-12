import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/features/admin/screens/teacher_detail_screen.dart';

class TeacherListScreen extends StatelessWidget {
  const TeacherListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Teacher Data
    final List<Map<String, String>> teachers = [
      {'id': 'T001', 'name': 'Amit Verma', 'subject': 'Mathematics', 'status': 'Present'},
      {'id': 'T002', 'name': 'Priya Singh', 'subject': 'Physics', 'status': 'Absent'},
      {'id': 'T003', 'name': 'Neha Gupta', 'subject': 'Chemistry', 'status': 'Present'},
      {'id': 'T004', 'name': 'Rahul Roy', 'subject': 'English', 'status': 'Present'},
      {'id': 'T005', 'name': 'Saanvi Mehta', 'subject': 'Biology', 'status': 'Leave'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Teachers Directory', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          final teacher = teachers[index];
          final isPresent = teacher['status'] == 'Present';
          final isAbsent = teacher['status'] == 'Absent';

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TeacherDetailScreen(teacherId: teacher['id']!, name: teacher['name']!)),
                );
              },
              leading: CircleAvatar(
                backgroundColor: isPresent ? Colors.green.withOpacity(0.1) : (isAbsent ? Colors.red.withOpacity(0.1) : Colors.orange.withOpacity(0.1)),
                child: Text(teacher['id']!, style: TextStyle(fontWeight: FontWeight.bold, color: isPresent ? Colors.green : (isAbsent ? Colors.red : Colors.orange))),
              ),
              title: Text(teacher['name']!, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
              subtitle: Text(teacher['subject']!, style: AppTextStyles.body),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isPresent ? Colors.green : (isAbsent ? Colors.red : Colors.orange),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(teacher['status']!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      ),
    );
  }
}
