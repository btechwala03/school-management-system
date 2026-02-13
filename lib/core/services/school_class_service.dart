import 'package:admin_app/models/school_class.dart';

class ClassService {
  static final ClassService _instance = ClassService._internal();

  factory ClassService() {
    return _instance;
  }

  ClassService._internal();

  // Mock Data
  final List<SchoolClass> _classes = [
    SchoolClass(id: 'C001', grade: '10', section: 'A', classTeacherId: 'T001', classTeacherName: 'Amit Verma', subjects: ['Mathematics', 'Science', 'English'], timetable: {
      'Monday': ['Mathematics', 'Science', 'English', 'History', 'Geography'],
      'Tuesday': ['Science', 'Mathematics', 'English', 'History', 'Geography'],
    }),
    SchoolClass(id: 'C002', grade: '10', section: 'B', classTeacherId: 'T003', classTeacherName: 'Neha Gupta', subjects: ['Mathematics', 'Science', 'English']),
    SchoolClass(id: 'C003', grade: '9', section: 'A', classTeacherId: 'T002', classTeacherName: 'Priya Singh', subjects: ['Mathematics', 'Science', 'Social Studies']),
      SchoolClass(id: 'C004', grade: '9', section: 'B', classTeacherId: '', classTeacherName: 'Not Assigned', subjects: ['Mathematics', 'Science', 'Social Studies']),
  ];

  List<SchoolClass> getAllClasses() {
    return _classes;
  }

  void addClass(SchoolClass newClass) {
    _classes.add(newClass);
  }

  void updateClassTeacher(String classId, String teacherId, String teacherName) {
    final index = _classes.indexWhere((c) => c.id == classId);
    if (index != -1) {
      final oldClass = _classes[index];
      _classes[index] = SchoolClass(
        id: oldClass.id,
        grade: oldClass.grade,
        section: oldClass.section,
        subjects: oldClass.subjects,
        classTeacherId: teacherId,
        classTeacherName: teacherName,
        subjectTeachers: oldClass.subjectTeachers,
      );
    }
  }

  void updateSubjectTeacher(String classId, String subject, String teacherName) {
    final index = _classes.indexWhere((c) => c.id == classId);
    if (index != -1) {
      final oldClass = _classes[index];
      final newSubjectTeachers = Map<String, String>.from(oldClass.subjectTeachers);
      newSubjectTeachers[subject] = teacherName;

      _classes[index] = SchoolClass(
        id: oldClass.id,
        grade: oldClass.grade,
        section: oldClass.section,
        subjects: oldClass.subjects,
        classTeacherId: oldClass.classTeacherId,
        classTeacherName: oldClass.classTeacherName,
        subjectTeachers: newSubjectTeachers,
      );
    }
  }

  void updateTimetable(String classId, String day, List<String> subjects) {
    final index = _classes.indexWhere((c) => c.id == classId);
    if (index != -1) {
      final oldClass = _classes[index];
      final newTimetable = Map<String, List<String>>.from(oldClass.timetable);
      newTimetable[day] = subjects;

      _classes[index] = SchoolClass(
        id: oldClass.id,
        grade: oldClass.grade,
        section: oldClass.section,
        subjects: oldClass.subjects,
        classTeacherId: oldClass.classTeacherId,
        classTeacherName: oldClass.classTeacherName,
        subjectTeachers: oldClass.subjectTeachers,
        timetable: newTimetable,
      );
    }
  }
  // --- Helper Queries ---

  SchoolClass? getClassByClassTeacherId(String teacherId) {
    try {
      return _classes.firstWhere((c) => c.classTeacherId == teacherId);
    } catch (e) {
      return null;
    }
  }

  // Returns a List of timtable slots for a specific teacher across all classes
  // Map Structure: {'day': 'Monday', 'period': 1, 'subject': 'Math', 'class': '10-A'}
  List<Map<String, dynamic>> getTeacherSchedule(String teacherName) {
    List<Map<String, dynamic>> schedule = [];
    
    for (var schoolClass in _classes) {
      schoolClass.timetable.forEach((day, subjects) {
        for (int i = 0; i < subjects.length; i++) {
          final subject = subjects[i];
          final assignedTeacher = schoolClass.subjectTeachers[subject];
          
          if (assignedTeacher == teacherName) {
            schedule.add({
              'day': day,
              'period': i + 1,
              'subject': subject,
              'class': '${schoolClass.grade}-${schoolClass.section}',
              'room': '201' // Mock Room
            });
          }
        }
      });
    }
    return schedule;
  }
}
