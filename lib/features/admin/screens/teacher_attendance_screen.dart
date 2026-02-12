import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:admin_app/core/services/teacher_service.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});

  @override
  State<TeacherAttendanceScreen> createState() => _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  final _teacherService = TeacherService();
  final String _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  
  // Local state to track changes on this screen before "Saving" (optional, allows batch save)
  // Or current implementing instant save for simplicity.
  
  final List<Map<String, dynamic>> _teachers = [
    {'id': 'T001', 'name': 'Amit Verma', 'status': 'Present'},
    {'id': 'T002', 'name': 'Priya Singh', 'status': 'Present'},
    {'id': 'T003', 'name': 'Neha Gupta', 'status': 'Present'},
    {'id': 'T004', 'name': 'Rahul Roy', 'status': 'Present'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mark Teacher Attendance', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Attendance Saved Successfully!'), backgroundColor: Colors.green),
               );
               Navigator.pop(context);
            },
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text('SAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date: ${DateFormat('dd MMM yyyy').format(DateTime.now())}', 
                  style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                const Chip(label: Text('Total: 4'), backgroundColor: Colors.blueAccent, labelStyle: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _teachers.length,
              itemBuilder: (context, index) {
                final teacher = _teachers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0), // Reduced padding for compact look
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(teacher['name'][0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ),
                      title: Text(teacher['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('ID: ${teacher['id']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           _buildStatusButton(teacher, 'Present', Colors.green),
                           const SizedBox(width: 8),
                           _buildStatusButton(teacher, 'Absent', Colors.red),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(Map<String, dynamic> teacher, String status, Color color) {
    bool isSelected = teacher['status'] == status;
    return InkWell(
      onTap: () {
        setState(() {
          teacher['status'] = status;
          // Update Service Immediately
          _teacherService.markAttendance(teacher['id'], _currentDate, status);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : Colors.grey.shade300),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
