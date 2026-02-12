import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:admin_app/features/admin/screens/teacher_attendance_screen.dart';
import 'package:admin_app/features/admin/screens/student_list_screen.dart';

class AuditLogScreen extends StatelessWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Audit Data
    final List<Map<String, String>> logs = [
      {
        'action': 'Fee Status Edit',
        'details': 'Changed Tuition Fee to PAID for Aarav Kumar (XP2024)',
        'admin': 'Principal Sharma',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)).toString(),
        'type': 'Manual Override'
      },
      {
         'action': 'Late Fee Applied',
         'details': 'System Auto-Applied Late Fee (₹500) for Ishita Sharma',
         'admin': 'SYSTEM',
         'timestamp': DateTime.now().subtract(const Duration(hours: 2)).toString(),
         'type': 'Automated'
      },
      {
        'action': 'Teacher Attendance',
        'details': 'Marked 48/50 Teachers as Present',
        'admin': 'Principal Sharma',
        'timestamp': DateTime.now().subtract(const Duration(hours: 4)).toString(),
        'type': 'Attendance'
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Audit Logs', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          final date = DateTime.parse(log['timestamp']!);
          final isSystem = log['admin'] == 'SYSTEM';

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              onTap: () {
                // Determine navigation based on log type
                if (log['type'] == 'Attendance') {
                   Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const TeacherAttendanceScreen()),
                  );
                } else if (log['action']!.contains('Fee')) {
                   // In a real app, nav to specific transaction. Here, open Student List.
                   Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const StudentListScreen()),
                  );
                }
              },
              leading: CircleAvatar(
                backgroundColor: isSystem ? Colors.orange.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                child: Icon(
                  isSystem ? Icons.settings : Icons.security,
                  color: isSystem ? Colors.orange : Colors.blue,
                ),
              ),
              title: Text(log['action']!, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(log['details']!, style: AppTextStyles.body),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${log['admin']} • ${DateFormat('hh:mm a, dd MMM').format(date)}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Chip(
                label: Text(log['type']!, style: const TextStyle(fontSize: 10, color: Colors.white)),
                backgroundColor: isSystem ? Colors.orange : Colors.blue,
                padding: EdgeInsets.zero,
              ),
            ),
          );
        },
      ),
    );
  }
}
