import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_app/models/student.dart';
import 'package:admin_app/features/admin/screens/student_detail_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final List<Student> _allStudents = [
    Student(
      id: '1',
      name: 'Aarav Kumar',
      rollNo: '101',
      className: '10',
      section: 'A',
      fatherName: 'Rajesh Kumar',
      motherName: 'Sunita Devi',
      aadhaar: '1234-5678-9012',
      gender: 'Male',
      photoUrl: 'assets/student_boy.png',
    ),
     Student(
      id: '2',
      name: 'Ishita Sharma',
      rollNo: '102',
      className: '10',
      section: 'A',
      fatherName: 'Deepak Sharma',
      motherName: 'Meena Sharma',
      aadhaar: '9876-5432-1098',
      gender: 'Female',
      photoUrl: 'assets/student_girl.png',
    ),
    Student(
      id: '3',
      name: 'Rohan Gupta',
      rollNo: '103',
      className: '12',
      section: 'B',
      fatherName: 'Suresh Gupta',
      motherName: 'Anita Gupta',
      aadhaar: '4567-8901-2345',
      gender: 'Male',
      photoUrl: 'assets/student_boy.png',
    ),
    // Add more mock data as needed
  ];

  List<Student> _filteredStudents = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredStudents = _allStudents;
  }

  void _filterStudents(String query) {
    setState(() {
      _filteredStudents = _allStudents
          .where((student) =>
              student.name.toLowerCase().contains(query.toLowerCase()) ||
              student.rollNo.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Students', style: AppTextStyles.heading2.copyWith(color: Colors.white)),
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
              onChanged: _filterStudents,
              decoration: InputDecoration(
                hintText: 'Search by Name or Roll No',
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
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(
                        student.name.substring(0, 1),
                        style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
                      ),
                    ),
                    title: Text(student.name, style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Class: ${student.className} - ${student.section} | Roll: ${student.rollNo}'),
                         Text('Father: ${student.fatherName}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                       Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => StudentDetailScreen(student: student)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new student (Mock action)
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add Student Feature coming soon')));
        },
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
