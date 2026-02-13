import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:admin_app/utils/constants.dart';

class ParentAttendanceScreen extends StatefulWidget {
  const ParentAttendanceScreen({super.key});

  @override
  State<ParentAttendanceScreen> createState() => _ParentAttendanceScreenState();
}

class _ParentAttendanceScreenState extends State<ParentAttendanceScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Mock Attendance Data
  final Map<DateTime, String> _attendanceData = {
    DateTime.utc(2025, 10, 1): 'Present',
    DateTime.utc(2025, 10, 2): 'Holiday',
    DateTime.utc(2025, 10, 3): 'Present',
    DateTime.utc(2025, 10, 6): 'Absent',
    DateTime.utc(2025, 10, 7): 'Present',
    DateTime.utc(2025, 10, 8): 'Present',
    DateTime.utc(2025, 10, 9): 'Present',
    DateTime.utc(2025, 10, 10): 'Present',
    DateTime.utc(2025, 10, 13): 'Absent',
    DateTime.utc(2025, 10, 14): 'Late',
    DateTime.utc(2025, 10, 15): 'Present',
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<String> _getEventsForDay(DateTime day) {
    final status = _attendanceData[DateTime.utc(day.year, day.month, day.day)];
    if (status != null) {
      return [status];
    }
    return [];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present':
        return const Color(0xFF4CAF50); // Soft Green
      case 'Absent':
        return const Color(0xFFEF5350); // Soft Red
      case 'Holiday':
        return const Color(0xFFFFCA28); // Amber
      case 'Late':
        return const Color(0xFF42A5F5); // Blue
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Grayish Blue
      appBar: AppBar(
        title: const Text('My Attendance', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildAttendanceChart(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade200, blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  leftChevronIcon: Icon(Icons.chevron_left_rounded, color: AppColors.primary),
                  rightChevronIcon: Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                eventLoader: _getEventsForDay,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  todayDecoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isEmpty) return const SizedBox();
                    final status = events.first as String;
                    return Positioned(
                      bottom: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStatusColor(status),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        width: 8.0,
                        height: 8.0,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSelectedDayDetails(),
            const SizedBox(height: 20),
            _buildHistoryList(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceChart() {
    int totalPresent = _attendanceData.values.where((s) => s == 'Present').length;
    int totalAbsent = _attendanceData.values.where((s) => s == 'Absent').length;
    int totalDays = totalPresent + totalAbsent;
    double presentPercent = totalDays == 0 ? 0 : (totalPresent / totalDays) * 100;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Overall", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text("${presentPercent.toStringAsFixed(0)}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.black87)),
                  const Text("Attendance", style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 35,
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFF4CAF50),
                        value: totalPresent.toDouble(),
                        title: '',
                        radius: 15,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: const Color(0xFFEF5350),
                        value: totalAbsent.toDouble(),
                        title: '',
                        radius: 15,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem("Present", "$totalPresent", const Color(0xFF4CAF50)),
              _buildLegendItem("Absent", "$totalAbsent", const Color(0xFFEF5350)),
              _buildLegendItem("Late", "1", const Color(0xFF42A5F5)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
          Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    final historyEvents = _attendanceData.entries
        .where((e) => e.value == 'Absent' || e.value == 'Late')
        .toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    if (historyEvents.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Needs Attention", style: AppTextStyles.heading2.copyWith(color: Colors.blueGrey)),
          const SizedBox(height: 12),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historyEvents.length,
              itemBuilder: (context, index) {
                final entry = historyEvents[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                    boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 4)],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _getStatusColor(entry.value).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          entry.value == 'Absent' ? Icons.close_rounded : Icons.access_time_rounded,
                          color: _getStatusColor(entry.value),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(DateFormat('d MMMM y').format(entry.key), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(DateFormat('EEEE').format(entry.key), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(entry.value).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          entry.value,
                          style: TextStyle(color: _getStatusColor(entry.value), fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _buildSelectedDayDetails() {
    if (_selectedDay == null) return const SizedBox();
    
    final events = _getEventsForDay(_selectedDay!);
    final formattedDate = DateFormat('EEEE, d MMMM y').format(_selectedDay!);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF6A11CB).withOpacity(0.8), const Color(0xFF2575FC).withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2575FC).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
          const SizedBox(height: 10),
          if (events.isNotEmpty)
             Row(
               children: [
                 Container(
                   padding: const EdgeInsets.all(6),
                   decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                   child: Icon(Icons.circle, size: 10, color: _getStatusColor(events.first)),
                 ),
                 const SizedBox(width: 10),
                 Text(
                   events.first,
                   style: const TextStyle(
                     color: Colors.white,
                     fontWeight: FontWeight.bold,
                     fontSize: 20,
                   ),
                 ),
               ],
             )
          else
            const Text(
              'No records for this day.',
              style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }
}
