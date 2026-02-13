import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/models/student.dart';
import 'package:intl/intl.dart';
import 'package:admin_app/core/services/student_service.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  State<StudentAttendanceScreen> createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  // Use StudentService to fetch students dynamically
  List<Student> _students = [];
  
  // Map to track attendance status: true = Present, false = Absent
  final Map<String, bool> _attendance = {};

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    // Mock: Teacher is Class Teacher of 10-A
    final allStudents = StudentService().getStudentsByClass('10', 'A');
    setState(() {
      _students = allStudents;
      for (var student in _students) {
        // Default all to Present
        _attendance[student.id] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('dd MMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Class 10-A Attendance', style: TextStyle(color: Colors.white, fontSize: 18)),
            Text(today, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
          ],
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _students.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final student = _students[index];
                final isPresent = _attendance[student.id] ?? true;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isPresent ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    child: Text(student.rollNo, style: TextStyle(color: isPresent ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(student.name, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isPresent ? Colors.green : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _attendance[student.id] = true;
                            });
                          },
                          child: Text('P', style: TextStyle(color: isPresent ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: !isPresent ? Colors.red : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _attendance[student.id] = false;
                            });
                          },
                          child: Text('A', style: TextStyle(color: !isPresent ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Logic to save attendance & send SMS to absentees
                  int absentCount = _attendance.values.where((v) => v == false).length;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Attendance Submitted. $absentCount Absent SMS sent.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Submit & Notify Parents', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
