import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/models/school_class.dart';
import 'package:admin_app/core/services/school_class_service.dart';

class EditTimetableScreen extends StatefulWidget {
  const EditTimetableScreen({super.key});

  @override
  State<EditTimetableScreen> createState() => _EditTimetableScreenState();
}

class _EditTimetableScreenState extends State<EditTimetableScreen> {
  final _classService = ClassService();
  List<SchoolClass> _classes = [];
  SchoolClass? _selectedClass;
  String _selectedDay = 'Monday';
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  
  // Timetable Data: List of Subjects for 8 periods
  List<String> _currentTimetable = List.generate(8, (index) => 'Free Period');

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  void _loadClasses() {
    setState(() {
      _classes = _classService.getAllClasses();
      if (_classes.isNotEmpty) {
        _selectedClass = _classes.first;
        _loadTimetable();
      }
    });
  }

  void _loadTimetable() {
    if (_selectedClass != null) {
      final savedTimetable = _selectedClass!.timetable[_selectedDay];
      if (savedTimetable != null && savedTimetable.length == 8) {
        _currentTimetable = List.from(savedTimetable);
      } else {
        _currentTimetable = List.generate(8, (index) => 'Free Period');
      }
      setState(() {});
    }
  }

  void _saveTimetable() {
    if (_selectedClass != null) {
      _classService.updateTimetable(_selectedClass!.id, _selectedDay, _currentTimetable);
      // Refresh local class object
      _selectedClass = _classService.getAllClasses().firstWhere((c) => c.id == _selectedClass!.id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Timetable Saved!')));
    }
  }

  void _showSubjectPicker(int periodIndex) {
    if (_selectedClass == null) return;
    
    // Available subjects + Free Period
    final options = ['Free Period', ..._selectedClass!.subjects];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Subject for Period ${periodIndex + 1}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final subject = options[index];
              return ListTile(
                title: Text(subject),
                onTap: () {
                  setState(() {
                    _currentTimetable[periodIndex] = subject;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Timetable', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filters Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                DropdownButtonFormField<SchoolClass>(
                  value: _selectedClass,
                  decoration: const InputDecoration(labelText: 'Select Class', border: OutlineInputBorder()),
                  items: _classes.map((c) => DropdownMenuItem(value: c, child: Text('${c.grade}-${c.section}'))).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedClass = val;
                      _loadTimetable();
                    });
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _days.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final day = _days[index];
                      final isSelected = day == _selectedDay;
                      return ChoiceChip(
                        label: Text(day),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedDay = day;
                              _loadTimetable();
                            });
                          }
                        },
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Periods List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 8,
              itemBuilder: (context, index) {
                final subject = _currentTimetable[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.secondary.withOpacity(0.1),
                      child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
                    ),
                    title: Text('Period ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(subject, style: TextStyle(color: subject == 'Free Period' ? Colors.grey : AppColors.primary, fontSize: 16)),
                    trailing: const Icon(Icons.edit, color: Colors.grey),
                    onTap: () => _showSubjectPicker(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveTimetable,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Save Timetable', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
