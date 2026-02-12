import 'package:admin_app/core/models/user.dart';

class AuthService {
  // Simulate network delay and logic
  Future<User?> login(String id, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Mock latency

    // MOCK DATA - In real app, this hits the Backend API
    if (id == 'admin' && password == 'admin123') {
      return User(
        id: 'A001',
        name: 'Principal Sharma',
        role: UserRole.admin,
        photoUrl: 'assets/admin_avatar.png',
      );
    } else if (id.toUpperCase().startsWith('T') && password == 'teacher123') {
      return User(
        id: id,
        name: 'Teacher ${id.substring(1)}',
        role: UserRole.teacher,
        photoUrl: 'assets/teacher_avatar.png',
      );
    }

    return null; // Login failed
  }
}
