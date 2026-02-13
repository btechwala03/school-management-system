import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/models/teacher.dart';
import 'package:admin_app/core/services/teacher_service.dart';

class AddTeacherScreen extends StatefulWidget {
  const AddTeacherScreen({super.key});

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Dropdown Values
  String _selectedSubject = 'Mathematics';
  final List<String> _subjects = ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'English', 'History', 'Geography', 'Computer Science'];

  void _saveTeacher() {
    if (_formKey.currentState!.validate()) {
      final newTeacher = Teacher(
        id: 'T${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}', // Simple ID
        name: _nameController.text,
        subject: _selectedSubject,
        email: _emailController.text,
        phone: _phoneController.text,
        qualification: _qualificationController.text,
        experience: _experienceController.text,
        photoUrl: 'assets/teacher_placeholder.png',
        isPresent: true,
      );

      TeacherService().addTeacher(newTeacher);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teacher Added Successfully!')),
      );

      Navigator.pop(context, true); // Return true to indicate success
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qualificationController.dispose();
    _experienceController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add New Teacher', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, Color(0xFF8E84FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Color(0xFF8E84FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Column(
                children: [
                   const Icon(Icons.person_add_alt_1, size: 60, color: Colors.white24),
                   const SizedBox(height: 10),
                   Text(
                    'Enter teacher details to add to directory.',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionCard(
                      title: 'Professional Details',
                      icon: Icons.work,
                      children: [
                        _buildTextField('Full Name', _nameController, Icons.person),
                        const SizedBox(height: 16),
                        _buildDropdown('Subject', _subjects, _selectedSubject, (val) => setState(() => _selectedSubject = val!)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildTextField('Qualification', _qualificationController, Icons.school)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildTextField('Experience', _experienceController, Icons.timeline)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSectionCard(
                      title: 'Contact Information',
                      icon: Icons.contact_mail,
                      children: [
                        _buildTextField('Email Address', _emailController, Icons.email, isEmail: true),
                        const SizedBox(height: 16),
                        _buildTextField('Phone Number', _phoneController, Icons.phone, isNumber: true, maxLength: 10),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _saveTeacher,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                        shadowColor: AppColors.primary.withOpacity(0.5),
                      ),
                      child: const Text('SAVE TEACHER', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 10),
              Text(title, style: AppTextStyles.heading2.copyWith(fontSize: 18, color: AppColors.textPrimary)),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumber = false, bool isEmail = false, int? maxLength}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      maxLength: maxLength,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: AppColors.primary.withOpacity(0.7)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        counterText: "",
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
    );
  }
}
