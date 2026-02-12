import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/models/student.dart';

class UploadMarksScreen extends StatefulWidget {
  const UploadMarksScreen({super.key});

  @override
  State<UploadMarksScreen> createState() => _UploadMarksScreenState();
}

class _UploadMarksScreenState extends State<UploadMarksScreen> {
  // Advanced Teacher Logic: Class -> Subject Map
  // T001 teaches Math to 10th and Science to 8th
  final Map<String, String> _teachingAssignments = {
    '10-A': 'Mathematics',
    '10-B': 'Mathematics',
    '8-A': 'Science',
  };

  String? _selectedClass;
  String _currentSubject = '';
  String _selectedExamTerm = 'Mid-Term 2025';

  // Exam Security Logic
  final Map<String, bool> _examTerms = {
    'Mid-Term 2025': false, // Open
    'Finals 2024': true,    // Locked/Closed (Past)
  };

  // Mock Data
  final List<Student> _allStudents = [
    // Class 10-A
    Student(id: '1', name: 'Aarav Kumar', rollNo: '101', className: '10', section: 'A', fatherName: 'Rajesh', motherName: 'Sunita', aadhaar: '1234', gender: 'Male', photoUrl: 'assets/student_boy.png'),
    Student(id: '2', name: 'Ishita Sharma', rollNo: '102', className: '10', section: 'A', fatherName: 'Deepak', motherName: 'Meena', aadhaar: '9876', gender: 'Female', photoUrl: 'assets/student_girl.png'),
    // Class 10-B
    Student(id: '3', name: 'Vikram Singh', rollNo: '101', className: '10', section: 'B', fatherName: 'Vijay', motherName: 'Kavita', aadhaar: '1111', gender: 'Male', photoUrl: 'assets/student_boy.png'),
    // Class 8-A (Science)
    Student(id: '4', name: 'Riya Gupta', rollNo: '801', className: '8', section: 'A', fatherName: 'Sanjay', motherName: 'Pooja', aadhaar: '2222', gender: 'Female', photoUrl: 'assets/student_girl.png'),
    Student(id: '5', name: 'Arjun Reddy', rollNo: '802', className: '8', section: 'A', fatherName: 'Karan', motherName: 'Sneha', aadhaar: '3333', gender: 'Male', photoUrl: 'assets/student_boy.png'),
  ];

  List<Student> _filteredStudents = [];
  final Map<String, TextEditingController> _marksControllers = {};

  @override
  void initState() {
    super.initState();
    _selectedClass = _teachingAssignments.keys.first;
    _updateStateForClass(_selectedClass!);
  }

  void _updateStateForClass(String className) {
    setState(() {
      _selectedClass = className;
      _currentSubject = _teachingAssignments[className]!;
      
      // Filter Logic: Handle '8-A' vs '10-A' formatting
      // Our mock data uses '8', 'A'. The key is '8-A'. 
      final parts = className.split('-');
      final cName = parts[0];
      final sName = parts[1];

      _filteredStudents = _allStudents.where((s) => s.className == cName && s.section == sName).toList();
      
      _marksControllers.clear();
      for (var student in _filteredStudents) {
        _marksControllers[student.id] = TextEditingController();
      }
    });
  }

  Color _getSubjectColor(String subject) {
    if (subject == 'Mathematics') return Colors.blue;
    if (subject == 'Science') return Colors.green;
    return Colors.orange;
  }

  @override
  void dispose() {
    for (var controller in _marksControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upload Marks', style: TextStyle(color: Colors.white)),
        backgroundColor: _getSubjectColor(_currentSubject),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text('Subject: $_currentSubject', 
                      style: AppTextStyles.heading2.copyWith(fontSize: 18, color: _getSubjectColor(_currentSubject))),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text('Mid-Term Exam', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedExamTerm,
                  decoration: InputDecoration(
                    labelText: 'Select Exam Term',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    prefixIcon: const Icon(Icons.calendar_today, color: AppColors.primary),
                  ),
                  items: _examTerms.keys.map((String value) {
                    final isLocked = _examTerms[value]!;
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value),
                          if (isLocked) const Icon(Icons.lock, size: 14, color: Colors.red),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedExamTerm = newValue!;
                      if (_examTerms[_selectedExamTerm]!) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This exam term is locked. View-only mode.'), backgroundColor: Colors.red));
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedClass,
                  decoration: InputDecoration(
                    labelText: 'Select Class',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    prefixIcon: const Icon(Icons.class_, color: AppColors.primary),
                  ),
                  items: _teachingAssignments.keys.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('Class $value (${_teachingAssignments[value]})'),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) _updateStateForClass(newValue);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredStudents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.school_outlined, size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text('No students found', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = _filteredStudents[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.only(bottom: 12),
                        child:Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: _getSubjectColor(_currentSubject).withOpacity(0.1),
                                child: Text(student.rollNo, 
                                  style: TextStyle(color: _getSubjectColor(_currentSubject), fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(student.name, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                                    // Text('ID: ${student.id}', style: AppTextStyles.body),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _marksControllers[student.id],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    labelText: 'Marks',
                                    hintText: '/100',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: _getSubjectColor(_currentSubject), width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getSubjectColor(_currentSubject),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _examTerms[_selectedExamTerm]! ? null : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Uploaded ${_currentSubject} marks for Class $_selectedClass!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cloud_upload, color: Colors.white),
                label: const Text('Submit Marks', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
