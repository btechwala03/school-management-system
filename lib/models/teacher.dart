class Teacher {
  final String id;
  final String name;
  final String subject;
  bool isPresent;

  Teacher({
    required this.id,
    required this.name,
    required this.subject,
    this.isPresent = true,
  });
}
