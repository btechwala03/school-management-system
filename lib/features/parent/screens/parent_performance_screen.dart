import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:admin_app/utils/constants.dart';

class ParentPerformanceScreen extends StatefulWidget {
  const ParentPerformanceScreen({super.key});

  @override
  State<ParentPerformanceScreen> createState() => _ParentPerformanceScreenState();
}

class _ParentPerformanceScreenState extends State<ParentPerformanceScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String _selectedTerm = "Term 1";
  final List<String> _terms = ["Term 1", "Term 2", "Annual"];

  // Mock Data: Marks for different terms
  final Map<String, Map<String, dynamic>> _termData = {
    "Term 1": {
      "marks": {'Maths': 85.0, 'Science': 72.0, 'English': 90.0, 'History': 65.0, 'Comp': 95.0},
      "exams": [
        {'subject': 'Mathematics', 'marks': 85, 'total': 100, 'grade': 'A'},
        {'subject': 'Science', 'marks': 72, 'total': 100, 'grade': 'B+'},
        {'subject': 'English', 'marks': 90, 'total': 100, 'grade': 'A+'},
        {'subject': 'History', 'marks': 65, 'total': 100, 'grade': 'B'},
        {'subject': 'Computer', 'marks': 95, 'total': 100, 'grade': 'O'},
      ]
    },
    "Term 2": {
      "marks": {'Maths': 88.0, 'Science': 78.0, 'English': 92.0, 'History': 70.0, 'Comp': 98.0},
      "exams": [
        {'subject': 'Mathematics', 'marks': 88, 'total': 100, 'grade': 'A'},
        {'subject': 'Science', 'marks': 78, 'total': 100, 'grade': 'A'},
        {'subject': 'English', 'marks': 92, 'total': 100, 'grade': 'O'},
        {'subject': 'History', 'marks': 70, 'total': 100, 'grade': 'B+'},
        {'subject': 'Computer', 'marks': 98, 'total': 100, 'grade': 'O'},
      ]
    },
    "Annual": {
      "marks": {'Maths': 95.0, 'Science': 85.0, 'English': 88.0, 'History': 75.0, 'Comp': 99.0},
      "exams": [
        {'subject': 'Mathematics', 'marks': 95, 'total': 100, 'grade': 'O'},
        {'subject': 'Science', 'marks': 85, 'total': 100, 'grade': 'A'},
        {'subject': 'English', 'marks': 88, 'total': 100, 'grade': 'A'},
        {'subject': 'History', 'marks': 75, 'total': 100, 'grade': 'A'},
        {'subject': 'Computer', 'marks': 99, 'total': 100, 'grade': 'O'},
      ]
    },
  };

  @override
  void initState() {
    super.initState();
     _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get data for selected term
    final currentData = _termData[_selectedTerm]!;
    final subjectMarks = currentData['marks'] as Map<String, double>;
    final recentExams = currentData['exams'] as List<Map<String, dynamic>>;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Academic Performance', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        physics: const BouncingScrollPhysics(),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Term Selector
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _terms.map((term) {
                      final isSelected = term == _selectedTerm;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTerm = term),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            term,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 1. Performance Chart
              Text("Subject Analysis", style: AppTextStyles.heading2.copyWith(color: Colors.blueGrey)),
              const SizedBox(height: 16),
              Container(
                height: 300,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 15, offset: const Offset(0, 5))],
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => Colors.black87,
                        tooltipPadding: const EdgeInsets.all(8),
                        tooltipMargin: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${rod.toY.round()}%',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final subjects = subjectMarks.keys.toList();
                            if (value.toInt() >= 0 && value.toInt() < subjects.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  subjects[value.toInt()],
                                  style: TextStyle(
                                    color: Colors.grey.shade600, 
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 10
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true, 
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1),
                    ),
                    barGroups: subjectMarks.entries.toList().asMap().entries.map((entry) {
                      final index = entry.key;
                      final value = entry.value.value;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: value,
                            gradient: LinearGradient(
                              colors: [_getBarColor(value).withOpacity(0.7), _getBarColor(value)],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            width: 12,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: 100,
                              color: Colors.grey.shade50,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 30),
        
              // 2. Recent Exam Results
              Text("$_selectedTerm Results", style: AppTextStyles.heading2.copyWith(color: Colors.blueGrey)),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentExams.length,
                itemBuilder: (context, index) {
                  final exam = recentExams[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_getGradeColor(exam['grade']).withOpacity(0.2), _getGradeColor(exam['grade']).withOpacity(0.05)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            exam['grade'],
                            style: TextStyle(
                              color: _getGradeColor(exam['grade']),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(exam['subject'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text("Max Marks: ${exam['total']}", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${exam['marks']}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const Text("Marks", style: TextStyle(color: Colors.grey, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBarColor(double value) {
    if (value >= 90) return const Color(0xFF4CAF50); // Green
    if (value >= 75) return const Color(0xFF2196F3); // Blue
    if (value >= 50) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFF44336); // Red
  }

  Color _getGradeColor(String grade) {
    if (grade == 'O' || grade == 'A+') return const Color(0xFF4CAF50);
    if (grade == 'A' || grade == 'B+') return const Color(0xFF2196F3);
    if (grade == 'B' || grade == 'C') return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
}
