import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/models/teacher.dart';
import 'package:admin_app/features/admin/screens/teacher_detail_screen.dart';
import 'package:admin_app/core/services/teacher_service.dart';
import 'package:admin_app/features/admin/screens/add_teacher_screen.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  List<Teacher> _allTeachers = [];
  List<Teacher> _filteredTeachers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  void _loadTeachers() {
    setState(() {
      _allTeachers = TeacherService().getAllTeachers();
      _filteredTeachers = _allTeachers;
    });
  }

  void _filterTeachers(String query) {
    setState(() {
      _filteredTeachers = _allTeachers
          .where((teacher) =>
              teacher.name.toLowerCase().contains(query.toLowerCase()) ||
              teacher.subject.toLowerCase().contains(query.toLowerCase()) ||
              teacher.id.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Teachers Directory', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary,
            child: TextField(
              controller: _searchController,
              onChanged: _filterTeachers,
              decoration: InputDecoration(
                hintText: 'Search by Name, ID or Subject',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredTeachers.length,
              itemBuilder: (context, index) {
                final teacher = _filteredTeachers[index];
                final isPresent = teacher.isPresent;

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: isPresent ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      child: Text(
                        teacher.name.isNotEmpty ? teacher.name.substring(0, 1) : 'T',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isPresent ? Colors.green : Colors.red,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    title: Text(teacher.name, style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(teacher.subject, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                        Text('ID: ${teacher.id} | Exp: ${teacher.experience}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TeacherDetailScreen(teacherId: teacher.id, name: teacher.name)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTeacherScreen()),
          );
          
          if (result == true) {
            _loadTeachers(); 
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Add Teacher', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
