import 'package:admin_app/models/student.dart';

class StudentService {
  static final StudentService _instance = StudentService._internal();

  factory StudentService() {
    return _instance;
  }

  StudentService._internal();

  // Mock Data
  final List<Student> _students = [
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
      admissionNumber: 'ADM2023001',
      mobileNumber: '9876543210',
      address: '123, Gandhi Nagar, Delhi',
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
      admissionNumber: 'ADM2023002',
      mobileNumber: '8765432109',
      address: '456, Nehru Place, Delhi',
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
      admissionNumber: 'ADM2023003',
      mobileNumber: '7654321098',
      address: '789, Lajpat Nagar, Delhi',
    ),
     // Class 8-A Student for testing
     Student(
      id: '4',
      name: 'Sanya Malhotra',
      rollNo: '801',
      className: '8',
      section: 'A',
      fatherName: 'Vikram Malhotra',
      motherName: 'Priya Malhotra',
      aadhaar: '1111-2222-3333',
      gender: 'Female',
      photoUrl: 'assets/student_girl.png',
      admissionNumber: 'ADM2023004',
      mobileNumber: '9988776655',
      address: '321, Vasant Kunj, Delhi',
    ),
     Student(
      id: '5',
      name: 'Arjun Reddy',
      rollNo: '802',
      className: '8',
      section: 'A',
      fatherName: 'Karan Reddy',
      motherName: 'Sneha Reddy',
      aadhaar: '4444-5555-6666',
      gender: 'Male',
      photoUrl: 'assets/student_boy.png',
      admissionNumber: 'ADM2023005',
      mobileNumber: '8877665544',
      address: '654, Hauz Khas, Delhi',
    ),
  ];

  List<Student> getAllStudents() {
    return _students;
  }

  List<Student> getStudentsByClass(String className, String section) {
    return _students
        .where((s) => s.className == className && s.section == section)
        .toList();
  }

  void addStudent(Student student) {
    _students.add(student);
  }
}
