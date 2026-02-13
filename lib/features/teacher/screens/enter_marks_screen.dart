import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/models/assessment.dart';
import 'package:admin_app/models/student.dart';

import 'package:admin_app/core/services/student_service.dart';

class EnterMarksScreen extends StatefulWidget {
  final Assessment assessment;
  const EnterMarksScreen({super.key, required this.assessment});

  @override
  State<EnterMarksScreen> createState() => _EnterMarksScreenState();
}

class _EnterMarksScreenState extends State<EnterMarksScreen> {
  // Use StudentService to fetch students dynamically
  List<Student> _filteredStudents = [];
  final Map<String, TextEditingController> _marksControllers = {};

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    // Parse class name from assessment (e.g., "10-A")
    final parts = widget.assessment.className.split('-');
    if (parts.length == 2) {
      final cName = parts[0];
      final sName = parts[1];
      
      setState(() {
        _filteredStudents = StudentService().getStudentsByClass(cName, sName);
        for (var s in _filteredStudents) {
          _marksControllers[s.id] = TextEditingController();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _marksControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${widget.assessment.title} Marks', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Class: ${widget.assessment.className}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Max Marks: ${widget.assessment.maxMarks}', style: AppTextStyles.heading2.copyWith(color: Colors.blue, fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.indigo.withOpacity(0.1),
                          child: Text(student.rollNo, style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(student.name, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                        ),
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            controller: _marksControllers[student.id],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: '/${widget.assessment.maxMarks}',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final mark = int.tryParse(value);
                                if (mark != null && mark > widget.assessment.maxMarks) {
                                  return 'Err';
                                }
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: widget.assessment.isLocked ? null : () {
                  // Validate all inputs
                  bool isValid = true;
                  for (var controller in _marksControllers.values) {
                     final text = controller.text;
                     if (text.isNotEmpty) {
                       final val = int.tryParse(text);
                       if (val == null || val > widget.assessment.maxMarks) {
                         isValid = false;
                         break;
                       }
                     }
                  }

                  if (isValid) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Marks Saved Successfully!'), backgroundColor: Colors.green),
                    );
                    Navigator.pop(context);
                  } else {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please check marks. Cannot exceed Max Marks.'), backgroundColor: Colors.red),
                    );
                  }
                },
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text('Save Marks', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
