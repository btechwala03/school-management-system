
class Assessment {
  final String id;
  final String title;
  final String className;
  final String subject;
  final int maxMarks;
  final DateTime date;
  final bool isLocked;

  Assessment({
    required this.id,
    required this.title,
    required this.className,
    required this.subject,
    required this.maxMarks,
    required this.date,
    this.isLocked = false,
  });
}
