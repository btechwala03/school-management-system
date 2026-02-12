import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/features/admin/screens/teacher_detail_screen.dart';

class TeacherAttendanceReportScreen extends StatelessWidget {
  const TeacherAttendanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for Reporting
    final List<Map<String, dynamic>> teacherStats = [
      {'id': 'T001', 'name': 'Amit Verma', 'present': 22, 'absent': 2, 'leaves': 1, 'rating': '92%'},
      {'id': 'T002', 'name': 'Priya Singh', 'present': 18, 'absent': 5, 'leaves': 2, 'rating': '75%'},
      {'id': 'T003', 'name': 'Neha Gupta', 'present': 24, 'absent': 1, 'leaves': 0, 'rating': '98%'},
      {'id': 'T004', 'name': 'Rahul Roy', 'present': 20, 'absent': 4, 'leaves': 1, 'rating': '80%'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Teacher Attendance Records', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: teacherStats.length,
        itemBuilder: (context, index) {
          final stat = teacherStats[index];
          final rating = int.parse(stat['rating'].toString().replaceAll('%', ''));
          Color statusColor = rating > 90 ? Colors.green : (rating > 75 ? Colors.orange : Colors.red);

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              onTap: () {
                 // Navigate to Full Report
                 Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherDetailScreen(teacherId: stat['id'], name: stat['name'])));
              },
              leading: CircleAvatar(
                backgroundColor: statusColor.withOpacity(0.1),
                child: Text(stat['rating'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
              ),
              title: Text(stat['name'], style: AppTextStyles.heading2.copyWith(fontSize: 16)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatPill('Present: ${stat['present']}', Colors.green),
                    _buildStatPill('Absent: ${stat['absent']}', Colors.red),
                    _buildStatPill('Leaves: ${stat['leaves']}', Colors.blue),
                  ],
                ),
              ),
              trailing: const Icon(Icons.bar_chart, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
    );
  }
}
