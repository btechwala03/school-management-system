import 'package:admin_app/models/assessment.dart';

class AssessmentService {
  // Singleton pattern for mock persistence in memory
  static final AssessmentService _instance = AssessmentService._internal();
  factory AssessmentService() => _instance;
  AssessmentService._internal();

  final List<Assessment> _assessments = [
    Assessment(id: '1', title: 'Mid-Term Exam', className: '10-A', subject: 'Mathematics', maxMarks: 100, date: DateTime(2025, 9, 15), isLocked: false),
    Assessment(id: '2', title: 'Unit Test 1', className: '10-A', subject: 'Mathematics', maxMarks: 25, date: DateTime(2025, 10, 10), isLocked: true),
    Assessment(id: '3', title: 'Pop Quiz', className: '8-A', subject: 'Science', maxMarks: 10, date: DateTime(2025, 11, 5), isLocked: false),
  ];

  List<Assessment> getAssessmentsForClass(String className, String subject) {
    return _assessments.where((a) => a.className == className && a.subject == subject).toList();
  }

  void createAssessment(Assessment assessment) {
    _assessments.add(assessment);
  }
}
