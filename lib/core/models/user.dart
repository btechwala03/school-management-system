enum UserRole {
  admin,
  teacher,
  parent, // Future use
}

class User {
  final String id;
  final String name;
  final UserRole role;
  final String? photoUrl;

  User({
    required this.id,
    required this.name,
    required this.role,
    this.photoUrl,
  });
}
