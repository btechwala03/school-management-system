import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/core/widgets/fade_in_list_item.dart';
import 'package:admin_app/features/admin/screens/student_list_screen.dart';
import 'package:admin_app/features/admin/screens/teacher_attendance_screen.dart';
import 'package:admin_app/features/admin/screens/teacher_list_screen.dart';
import 'package:admin_app/features/admin/screens/audit_log_screen.dart';
import 'package:admin_app/features/admin/screens/send_notices_screen.dart';
import 'package:admin_app/features/admin/screens/reports_dashboard_screen.dart';
import 'package:admin_app/screens/login_screen.dart'; // Import LoginScreen
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              accountName: const Text('Principal Sharma', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              accountEmail: const Text('admin@school.edu'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: AppColors.primary),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () { Navigator.pop(context); },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Students'),
              onTap: () {
                 Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const StudentListScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Teachers'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TeacherListScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                 Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: FadeInListItem(index: 0, child: _buildStatCard('Total Students', '1,250', Icons.people, Colors.blue))),
                const SizedBox(width: 16),
                Expanded(child: FadeInListItem(index: 1, child: _buildStatCard('Teachers Present', '48/50', Icons.school, Colors.green))),
              ],
            ),
            const SizedBox(height: 16),
            // New Headcount Card
            FadeInListItem(
              index: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Student Demographics', style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildGenderStat('Boys', '650', Icons.male, Colors.blue),
                        Container(height: 40, width: 1, color: Colors.grey.shade300),
                        _buildGenderStat('Girls', '600', Icons.female, Colors.pink),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInListItem(
              index: 3,
              child: Text('Quick Actions', style: AppTextStyles.heading2),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                FadeInListItem(
                  index: 4,
                  child: _buildActionCard(context, 'Manage Fees', Icons.payment, AppColors.primary, () {
                     Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const StudentListScreen()),
                    );
                  }),
                ),
                FadeInListItem(
                  index: 5,
                  child: _buildActionCard(context, 'Mark Attendance', Icons.edit_calendar, AppColors.secondary, () {
                    // Reverting to "Mark Attendance" as per user request
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const TeacherAttendanceScreen()),
                    );
                  }),
                ),
                FadeInListItem(
                  index: 6,
                  child: _buildActionCard(context, 'Send Notices', Icons.message, Colors.orange, () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SendNoticesScreen()),
                    );
                  }),
                ),
                FadeInListItem(
                  index: 7,
                  child: _buildActionCard(context, 'View Reports', Icons.bar_chart, Colors.purple, () {
                     Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ReportsDashboardScreen()),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.heading2.copyWith(fontSize: 28)),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.body.copyWith(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildGenderStat(String label, String count, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 4),
        Text(count, style: AppTextStyles.heading2.copyWith(fontSize: 20)),
        Text(label, style: AppTextStyles.body),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(title, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
