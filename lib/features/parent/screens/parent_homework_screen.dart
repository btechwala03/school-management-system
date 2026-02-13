import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';

class ParentHomeworkScreen extends StatefulWidget {
  const ParentHomeworkScreen({super.key});

  @override
  State<ParentHomeworkScreen> createState() => _ParentHomeworkScreenState();
}

class _ParentHomeworkScreenState extends State<ParentHomeworkScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock Data
  final List<Map<String, dynamic>> _assignments = [
    {
      'subject': 'Mathematics',
      'title': 'Chapter 5: Quadratic Equations',
      'dueDate': '15 Oct 2025',
      'status': 'Pending',
      'description': 'Solve Exercise 5.1 and 5.2 in your notebook.',
    },
    {
      'subject': 'Science',
      'title': 'Physics Lab Record',
      'dueDate': '16 Oct 2025',
      'status': 'Pending',
      'description': 'Complete the observation table for Ohm\'s Law experiment.',
    },
    {
      'subject': 'English',
      'title': 'Essay Writing',
      'dueDate': '18 Oct 2025',
      'status': 'Pending',
      'description': 'Write an essay on "The Impact of Technology on Education".',
    },
    {
      'subject': 'History',
      'title': 'World War I Timeline',
      'dueDate': '10 Oct 2025',
      'status': 'Completed',
      'description': 'Create a timeline of major events from 1914-1918.',
    },
    {
      'subject': 'Computer',
      'title': 'HTML Basics',
      'dueDate': '08 Oct 2025',
      'status': 'Completed',
      'description': 'Create a simple webpage using basic HTML tags.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Assignments', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade600,
              indicator: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)]),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF2575FC).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAssignmentList(filterStatus: 'Pending'),
          _buildAssignmentList(filterStatus: 'Completed'),
        ],
      ),
    );
  }

  Widget _buildAssignmentList({required String filterStatus}) {
    final filteredList = _assignments.where((a) => a['status'] == filterStatus).toList();

    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
              child: Icon(Icons.assignment_turned_in_rounded, size: 60, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 20),
            Text(
              "No $filterStatus Assignments",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: filteredList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final task = filteredList[index];
        final isPending = filterStatus == 'Pending';
        
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                     decoration: BoxDecoration(
                       color: _getSubjectColor(task['subject']).withOpacity(0.1),
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: Text(
                       task['subject'],
                       style: TextStyle(
                         color: _getSubjectColor(task['subject']),
                         fontWeight: FontWeight.bold,
                         fontSize: 12,
                       ),
                     ),
                   ),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 14, color: isPending ? Colors.red : Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "${task['dueDate']}",
                        style: TextStyle(
                          color: isPending ? Colors.red : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                task['title'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                task['description'],
                style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
              ),
              if (isPending) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {}, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Mark as Done"),
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }

  Color _getSubjectColor(String subject) {
    if (subject == 'Mathematics') return Colors.blue;
    if (subject == 'Science') return Colors.green;
    if (subject == 'English') return Colors.orange;
    if (subject == 'History') return Colors.brown;
    if (subject == 'Computer') return Colors.purple;
    return Colors.grey;
  }
}
