import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/core/services/teacher_service.dart';
import 'package:intl/intl.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text('Mr. Amit Verma', style: AppTextStyles.heading1),
            Text('ID: T001 • Mathematics Dept.', style: AppTextStyles.body),
            const SizedBox(height: 32),
            _buildProfileItem(Icons.email, 'Email', 'amit.verma@school.edu'),
            _buildProfileItem(Icons.phone, 'Phone', '+91 98765 43210'),
            _buildProfileItem(Icons.school, 'Qualification', 'M.Sc. Mathematics, B.Ed'),
            _buildProfileItem(Icons.calendar_today, 'Joining Date', '15 June 2018'),
            _buildProfileItem(Icons.home, 'Address', '123, Teachers Colony, City'),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.calendar_month, color: Colors.purple),
                const SizedBox(width: 8),
                Text('My Attendance Record (Feb 2025)', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                _buildAttendanceRow('01 Feb - 05 Feb', 'Present'),
                  const Divider(),
                  // Dynamic Row from Service
                  FutureBuilder<List<Map<String, String>>>(
                    future: Future.value(TeacherService().getAttendance('T001')), // Mock Async
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                         return _buildAttendanceRow(DateFormat('dd MMM').format(DateTime.now()), 'Not Marked Yet'); 
                      }
                      final todayRecord = snapshot.data!.last;
                       return _buildAttendanceRow(todayRecord['date']!, todayRecord['status']!);
                    },
                  ),
                  const Divider(),
                  _buildAttendanceRow('07 Feb - 12 Feb', 'Present'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                   Navigator.of(context).pushReplacementNamed('/');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Logout', style: TextStyle(color: Colors.red, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceRow(String date, String status) {
    bool isAbsent = status.contains('Absent');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: const TextStyle(fontWeight: FontWeight.w500)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isAbsent ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(status, style: TextStyle(color: isAbsent ? Colors.red : Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple),
        title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
    );
  }
}
