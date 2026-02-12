import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/models/student.dart';
import 'package:intl/intl.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  State<StudentAttendanceScreen> createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  // Mock Data reuse ( Ideally should move mock data to a service)
  final List<Student> _students = [
    Student(
      id: '1', name: 'Aarav Kumar', rollNo: '101', className: '10', section: 'A',
      fatherName: 'Rajesh', motherName: 'Sunita', aadhaar: '1234', gender: 'Male', photoUrl: 'assets/student_boy.png'
    ),
     Student(
      id: '2', name: 'Ishita Sharma', rollNo: '102', className: '10', section: 'A',
      fatherName: 'Deepak', motherName: 'Meena', aadhaar: '9876', gender: 'Female', photoUrl: 'assets/student_girl.png'
    ),
    Student(
      id: '3', name: 'Rohan Gupta', rollNo: '103', className: '10', section: 'A',
      fatherName: 'Suresh', motherName: 'Anita', aadhaar: '4567', gender: 'Male', photoUrl: 'assets/student_boy.png'
    ),
  ];

  // Map to track attendance status: true = Present, false = Absent
  final Map<String, bool> _attendance = {};

  @override
  void initState() {
    super.initState();
    // Default all to Present
    for (var student in _students) {
      _attendance[student.id] = true;
    }
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
