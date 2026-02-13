class Teacher {
  final String id;
  final String name;
  final String subject;
  final String email;
  final String phone;
  final String qualification;
  final String experience;
  final String photoUrl;
  bool isPresent;

  Teacher({
    required this.id,
    required this.name,
    required this.subject,
    this.email = '',
    this.phone = '',
    this.qualification = '',
    this.experience = '',
    this.photoUrl = 'assets/teacher_placeholder.png', // Placeholder
    this.isPresent = true,
  });
}
