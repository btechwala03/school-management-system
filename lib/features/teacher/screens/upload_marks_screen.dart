import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/models/assessment.dart';
import 'package:admin_app/core/services/assessment_service.dart';
import 'package:admin_app/features/teacher/screens/enter_marks_screen.dart';
import 'package:intl/intl.dart';

class UploadMarksScreen extends StatefulWidget {
  const UploadMarksScreen({super.key});

  @override
  State<UploadMarksScreen> createState() => _UploadMarksScreenState();
}

class _UploadMarksScreenState extends State<UploadMarksScreen> {
  final Map<String, String> _teachingAssignments = {
    '10-A': 'Mathematics',
    '10-B': 'Mathematics',
    '8-A': 'Science',
  };

  String? _selectedClass;
  String _currentSubject = '';
  final _assessmentService = AssessmentService();

  @override
  void initState() {
    super.initState();
    _selectedClass = _teachingAssignments.keys.first;
    _currentSubject = _teachingAssignments[_selectedClass]!;
  }

  void _updateStateForClass(String className) {
    setState(() {
      _selectedClass = className;
      _currentSubject = _teachingAssignments[className]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final assessments = _assessmentService.getAssessmentsForClass(_selectedClass!, _currentSubject);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assessments', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: DropdownButtonFormField<String>(
              value: _selectedClass,
              decoration: InputDecoration(
                labelText: 'Select Class',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                prefixIcon: const Icon(Icons.class_, color: AppColors.primary),
              ),
              items: _teachingAssignments.keys.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('Class $value (${_teachingAssignments[value]})'),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) _updateStateForClass(newValue);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: assessments.length,
              itemBuilder: (context, index) {
                final assessment = assessments[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.withOpacity(0.1),
                      child: Icon(Icons.assignment, color: Colors.indigo),
                    ),
                    title: Text(assessment.title, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Max Marks: ${assessment.maxMarks} • Date: ${DateFormat('dd MMM').format(assessment.date)}', style: AppTextStyles.body.copyWith(fontSize: 12)),
                        if (assessment.isLocked)
                          Text('Status: Locked', style: AppTextStyles.body.copyWith(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EnterMarksScreen(assessment: assessment),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateAssessmentDialog,
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add),
        label: const Text('New Assessment'),
      ),
    );
  }

  void _showCreateAssessmentDialog() {
    final titleController = TextEditingController();
    final maxMarksController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Assessment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Exam Title (e.g., Surprise Test, Chapter 4)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: maxMarksController,
              decoration: const InputDecoration(labelText: 'Max Marks'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Date: '),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2026),
                    );
                    if (picked != null) selectedDate = picked;
                  },
                  child: Text(DateFormat('dd MMM yyyy').format(selectedDate)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && maxMarksController.text.isNotEmpty) {
                final newAssessment = Assessment(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  className: _selectedClass!,
                  subject: _currentSubject,
                  maxMarks: int.parse(maxMarksController.text),
                  date: selectedDate,
                );
                _assessmentService.createAssessment(newAssessment);
                setState(() {});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assessment Created!')));
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

