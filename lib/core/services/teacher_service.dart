import 'package:admin_app/models/teacher.dart';

class TeacherService {
  static final TeacherService _instance = TeacherService._internal();

  factory TeacherService() {
    return _instance;
  }

  TeacherService._internal();

  // Mock Data
  final List<Teacher> _teachers = [
    Teacher(
      id: 'T001',
      name: 'Amit Verma',
      subject: 'Mathematics',
      isPresent: true,
      email: 'amit.verma@school.edu',
      phone: '9876543210',
      qualification: 'M.Sc. Mathematics',
      experience: '10 Years',
      photoUrl: 'assets/teacher_man.png',
    ),
    Teacher(
      id: 'T002',
      name: 'Priya Singh',
      subject: 'Physics',
      isPresent: false,
      email: 'priya.singh@school.edu',
      phone: '9876543211',
      qualification: 'M.Sc. Physics',
      experience: '8 Years',
      photoUrl: 'assets/teacher_woman.png',
    ),
    Teacher(
      id: 'T003',
      name: 'Neha Gupta',
      subject: 'Chemistry',
      isPresent: true,
      email: 'neha.gupta@school.edu',
      phone: '9876543212',
      qualification: 'Ph.D. Chemistry',
      experience: '12 Years',
      photoUrl: 'assets/teacher_woman.png',
    ),
    Teacher(
      id: 'T004',
      name: 'Rahul Roy',
      subject: 'English',
      isPresent: true,
      email: 'rahul.roy@school.edu',
      phone: '9876543213',
      qualification: 'M.A. English',
      experience: '5 Years',
      photoUrl: 'assets/teacher_man.png',
    ),
    Teacher(
      id: 'T005',
      name: 'Saanvi Mehta',
      subject: 'Biology',
      isPresent: false, // Leave
      email: 'saanvi.mehta@school.edu',
      phone: '9876543214',
      qualification: 'M.Sc. Biology',
      experience: '7 Years',
      photoUrl: 'assets/teacher_woman.png',
    ),
  ];

  List<Teacher> getAllTeachers() {
    return _teachers;
  }

  void addTeacher(Teacher teacher) {
    _teachers.add(teacher);
  }

  // Mock Attendance Methods
  void markAttendance(String teacherId, String date, String status) {
    final index = _teachers.indexWhere((t) => t.id == teacherId);
    if (index != -1) {
      _teachers[index].isPresent = (status == 'Present');
    }
  }

  Future<List<Map<String, String>>> getAttendance(String teacherId) async {
    // Return mock attendance history with String values to match UI
    return List.generate(5, (index) {
      final date = DateTime.now().subtract(Duration(days: index));
      return {
        'date': "${date.day} ${_getMonth(date.month)}", 
        'status': index % 3 == 0 ? 'Absent' : 'Present',
      };
    });
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
