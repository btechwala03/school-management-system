class SchoolClass {
  final String id;
  final String grade; // e.g., "10", "5"
  final String section; // e.g., "A", "B"
  final String classTeacherId; // ID of the assigned Class Teacher
  final String classTeacherName; // Name for display
  final List<String> subjects; // List of subjects taught in this class
  final Map<String, String> subjectTeachers; // Map<SubjectName, TeacherName>
  final Map<String, List<String>> timetable; // Map<Day, List<Subject>>. e.g., 'Monday': ['Math', 'English'...]

  SchoolClass({
    required this.id,
    required this.grade,
    required this.section,
    this.classTeacherId = '',
    this.classTeacherName = 'Not Assigned',
    this.subjects = const [],
    this.subjectTeachers = const {},
    this.timetable = const {},
  });

  String get name => '$grade-$section'; // Helper to get "10-A"
}
