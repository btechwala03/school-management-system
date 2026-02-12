import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:intl/intl.dart';

class TeacherFullReportScreen extends StatelessWidget {
  final String teacherId;
  final String name;

  const TeacherFullReportScreen({super.key, required this.teacherId, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Report: $name', style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Professional Profile'),
            _buildInfoCard([
              {'label': 'Designation', 'value': 'Senior Mathematics Teacher'},
              {'label': 'Joining Date', 'value': '12 Aug 2020 (5 Years)'},
              {'label': 'Qualification', 'value': 'M.Sc Mathematics, B.Ed'},
              {'label': 'Contact', 'value': '+91 9876543210'},
            ]),
            const SizedBox(height: 24),
            
            _buildSectionHeader('Attendance Summary (2025)'),
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Working', '120', Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Present', '110', Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Leaves Taken', '10', Colors.orange)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Recent Leave History', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildLeaveHistoryItem('10 Feb 2025', 'Sick Leave', 'Approved'),
            _buildLeaveHistoryItem('05 Jan 2025', 'Casual Leave', 'Approved'),
            _buildLeaveHistoryItem('20 Dec 2024', 'Emergency', 'Approved'),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Performance & Credentials'),
            _buildInfoCard([
              {'label': 'Subject Average', 'value': 'Mathematics: 88% (Class 10)'},
              {'label': 'Class Teacher', 'value': '10-A'},
              {'label': 'Last Review', 'value': 'Excellent (Dec 2024)'},
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: AppTextStyles.heading2),
    );
  }

  Widget _buildInfoCard(List<Map<String, String>> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: data.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item['label']!, style: const TextStyle(color: Colors.grey)),
                Text(item['value']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: color), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildLeaveHistoryItem(String date, String type, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(type, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(status, style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
