class TeacherService {
  static final TeacherService _instance = TeacherService._internal();

  factory TeacherService() {
    return _instance;
  }

  TeacherService._internal();

  // Mock Data: Teacher Attendance
  // Key: TeacherID, Value: List of Attendance Records
  final Map<String, List<Map<String, String>>> _attendanceRecords = {
    'T001': [
      {'date': '2025-02-01', 'status': 'Present'},
      {'date': '2025-02-02', 'status': 'Present'},
      {'date': '2025-02-03', 'status': 'Present'},
      {'date': '2025-02-04', 'status': 'Absent (Sick Leave)'}, // Pre-filled
      {'date': '2025-02-05', 'status': 'Present'},
    ],
    'T002': [
      {'date': '2025-02-05', 'status': 'Present'},
    ],
  };

  void markAttendance(String teacherId, String date, String status) {
    if (!_attendanceRecords.containsKey(teacherId)) {
      _attendanceRecords[teacherId] = [];
    }
    // Remove existing record for the same date if any
    _attendanceRecords[teacherId]!.removeWhere((record) => record['date'] == date);
    
    // Add new record
    _attendanceRecords[teacherId]!.add({'date': date, 'status': status});
  }

  List<Map<String, String>> getAttendance(String teacherId) {
    return _attendanceRecords[teacherId] ?? [];
  }

  Map<String, int> getAttendanceStats(String teacherId) {
    final records = getAttendance(teacherId);
    int present = records.where((r) => r['status']!.contains('Present')).length;
    int absent = records.where((r) => r['status']!.contains('Absent')).length;
    int leaves = records.where((r) => r['status']!.contains('Leave')).length; // Using generic 'Leave' check
    
    // Note: 'Absent (Sick Leave)' counts as both Absent AND Leave for simplicity in this mock, 
    // or we can refine logic. Let's say Leaves are subset of Absent if flagged.
    // For now, let's just count unique statuses.
    
    return {
      'present': present,
      'absent': absent, // Total absences
      'leaves': 1, // Mock static for now or derive from status text
    };
  }
}
