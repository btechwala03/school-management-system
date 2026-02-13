import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/core/widgets/fade_in_list_item.dart';
import 'package:admin_app/features/parent/screens/parent_attendance_screen.dart';
import 'package:admin_app/features/parent/screens/parent_fees_screen.dart';
import 'package:admin_app/features/parent/screens/parent_performance_screen.dart';
import 'package:admin_app/features/parent/screens/parent_timetable_screen.dart';
import 'package:admin_app/features/parent/screens/parent_homework_screen.dart';
import 'package:admin_app/screens/login_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mock Ward Data
    final String studentName = "Aarav Kumar";
    final String className = "Class 10-A";
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 80.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)], // Modern Blue-Purple
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
            ),
            title: const Text('Parent Portal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                   Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Ward Profile Card
                      FadeInListItem(
                        index: 0,
                        child: _buildWardProfileCard(studentName, className),
                      ),
                      const SizedBox(height: 24),

                      // 2. Quick Stats
                      FadeInListItem(
                        index: 1,
                        child: Text("Overview", style: AppTextStyles.heading2.copyWith(color: Colors.blueGrey)),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: FadeInListItem(index: 2, child: _buildStatCard("Attendance", "92.5%", Colors.green, Icons.check_circle_outline, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentAttendanceScreen()))))),
                          const SizedBox(width: 12),
                          Expanded(child: FadeInListItem(index: 3, child: _buildStatCard("Fees Due", "₹18,000", Colors.orange, Icons.currency_rupee, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentFeesScreen()))))),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 3. Quick Actions Grid
                      FadeInListItem(
                        index: 4,
                        child: Text("Quick Actions", style: AppTextStyles.heading2.copyWith(color: Colors.blueGrey)),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1, // Taller cards
                        children: [
                          FadeInListItem(
                            index: 5,
                            child: _buildActionCard(
                              context, 
                              "Attendance", 
                              "Check Log",
                              Icons.calendar_month_rounded, 
                              const Color(0xFF4FACFE), // Blue Gradient Start
                              const Color(0xFF00F2FE), // Blue Gradient End
                              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentAttendanceScreen())),
                            ),
                          ),
                          FadeInListItem(
                            index: 6,
                            child: _buildActionCard(
                              context, 
                              "Performance", 
                              "View Marks",
                              Icons.bar_chart_rounded, 
                              const Color(0xFF43E97B), // Green Gradient
                              const Color(0xFF38F9D7), 
                              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentPerformanceScreen())),
                            ),
                          ),
                          FadeInListItem(
                            index: 7,
                            child: _buildActionCard(
                              context, 
                              "Fees", 
                              "Pay Now",
                              Icons.payment_rounded, 
                              const Color(0xFFFA709A), // Pink/Red Gradient
                              const Color(0xFFFEE140), 
                              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentFeesScreen())),
                            ),
                          ),
                          FadeInListItem(
                            index: 8,
                            child: _buildActionCard(
                              context, 
                              "Timetable", 
                              "Weekly Plan",
                              Icons.schedule_rounded, 
                              const Color(0xFFA18CD1), // Purple Gradient
                              const Color(0xFFFBC2EB), 
                              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentTimetableScreen())),
                            ),
                          ),
                          FadeInListItem(
                            index: 9,
                            child: _buildActionCard(
                              context, 
                              "Homework", 
                              "Assignments",
                              Icons.assignment_rounded, 
                              const Color(0xFFF6D365), // Orange Gradient
                              const Color(0xFFFDA085), 
                              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentHomeworkScreen())),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      
                      // 4. Recent Notice with Animations
                      Text("Recent Updates", style: AppTextStyles.heading2.copyWith(color: Colors.blueGrey)),
                      const SizedBox(height: 12),
                      _buildNoticeCard(),
                      const SizedBox(height: 40), // Bottom padding
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWardProfileCard(String name, String className) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF11998e), Color(0xFF38ef7d)], // Modern Green Gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF11998e).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
            ),
            child: const CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xFFE8F5E9),
              child: Icon(Icons.person_rounded, size: 40, color: Color(0xFF11998e)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text("Student Profile", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text(className, style: const TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon, {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 18, color: color),
                        const SizedBox(width: 8),
                        Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    if (onTap != null)
                      Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey.shade300),
                  ],
                ),
                const SizedBox(height: 12),
                Text(value, style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle, IconData icon, Color startColor, Color endColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [startColor, endColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: startColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNoticeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade50, Colors.deepOrange.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
             padding: const EdgeInsets.all(10),
             decoration: const BoxDecoration(
               color: Colors.white,
               shape: BoxShape.circle,
             ),
             child: const Icon(Icons.notifications_active_rounded, color: Colors.deepOrange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Parent-Teacher Meeting", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepOrange)),
                const SizedBox(height: 6),
                Text("Join us for a discussion on Mid-Term results.", style: TextStyle(color: Colors.grey.shade700, height: 1.4)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text("15th Oct 2025", style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
