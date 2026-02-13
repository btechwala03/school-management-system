import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/models/school_class.dart';
import 'package:admin_app/core/services/school_class_service.dart';
import 'package:admin_app/core/services/teacher_service.dart';
import 'package:admin_app/models/teacher.dart';

class ClassManagementScreen extends StatefulWidget {
  const ClassManagementScreen({super.key});

  @override
  State<ClassManagementScreen> createState() => _ClassManagementScreenState();
}

class _ClassManagementScreenState extends State<ClassManagementScreen> {
  final _classService = ClassService();
  final _teacherService = TeacherService();
  List<SchoolClass> _classes = [];

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  void _loadClasses() {
    setState(() {
      _classes = _classService.getAllClasses();
    });
  }

  void _showAddClassDialog() {
    final gradeController = TextEditingController();
    final sectionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Class'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: gradeController, decoration: const InputDecoration(labelText: 'Grade (e.g., 10)')),
            TextField(controller: sectionController, decoration: const InputDecoration(labelText: 'Section (e.g., A)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (gradeController.text.isNotEmpty && sectionController.text.isNotEmpty) {
                final newClass = SchoolClass(
                  id: 'C${DateTime.now().millisecondsSinceEpoch}',
                  grade: gradeController.text,
                  section: sectionController.text,
                );
                _classService.addClass(newClass);
                _loadClasses();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Class Added!')));
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAssignTeacherDialog(SchoolClass schoolClass) {
    Teacher? selectedTeacher;
    final teachers = _teacherService.getAllTeachers();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Assign Teacher to ${schoolClass.grade}-${schoolClass.section}'),
            content: DropdownButton<Teacher>(
              hint: const Text('Select Class Teacher'),
              value: selectedTeacher,
              isExpanded: true,
              items: teachers.map((teacher) {
                return DropdownMenuItem(
                  value: teacher,
                  child: Text(teacher.name),
                );
              }).toList(),
              onChanged: (val) {
                setState(() => selectedTeacher = val);
              },
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (selectedTeacher != null) {
                    _classService.updateClassTeacher(schoolClass.id, selectedTeacher!.id, selectedTeacher!.name);
                    _loadClasses();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${selectedTeacher!.name} assigned to ${schoolClass.grade}-${schoolClass.section}!')));
                  }
                },
                child: const Text('Assign'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSubjectManagementDialog(SchoolClass schoolClass) {
    final teachers = _teacherService.getAllTeachers();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Subjects for ${schoolClass.grade}-${schoolClass.section}'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: schoolClass.subjects.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final subject = schoolClass.subjects[index];
                  final assignedTeacherName = schoolClass.subjectTeachers[subject] ?? 'Not Assigned';
                  
                  return ListTile(
                    title: Text(subject, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(assignedTeacherName, style: TextStyle(color: assignedTeacherName == 'Not Assigned' ? Colors.red : Colors.green)),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {
                        Teacher? selectedSubjectTeacher;
                        
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Assign $subject Teacher'),
                            content: DropdownButtonFormField<Teacher>(
                              items: teachers.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                              onChanged: (val) {
                                selectedSubjectTeacher = val;
                              },
                              decoration: const InputDecoration(labelText: 'Select Teacher'),
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                              ElevatedButton(
                                onPressed: () {
                                  if (selectedSubjectTeacher != null) {
                                    _classService.updateSubjectTeacher(schoolClass.id, subject, selectedSubjectTeacher!.name);
                                    Navigator.pop(context); // Close assign dialog
                                    setState(() {}); // Refresh list
                                    _loadClasses(); // Refresh main screen
                                  }
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Classes', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _classes.length,
        itemBuilder: (context, index) {
          final schoolClass = _classes[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: AppColors.secondary.withOpacity(0.1),
                child: Text(schoolClass.grade, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
              ),
              title: Text('Class ${schoolClass.grade}-${schoolClass.section}', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
              subtitle: Text('Class Teacher: ${schoolClass.classTeacherName}', style: TextStyle(color: schoolClass.classTeacherId.isEmpty ? Colors.red : Colors.grey[700])),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.book, color: Colors.blueAccent),
                    onPressed: () => _showSubjectManagementDialog(schoolClass),
                    tooltip: 'Manage Subjects',
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_add_alt, color: AppColors.primary),
                    onPressed: () => _showAssignTeacherDialog(schoolClass),
                    tooltip: 'Assign Class Teacher',
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddClassDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Class', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
