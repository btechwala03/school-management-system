import 'package:flutter/material.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_app/models/student.dart';
import 'package:admin_app/models/fee.dart';
import 'package:intl/intl.dart';

class StudentDetailScreen extends StatefulWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  bool _isAadhaarVisible = false;
  
  // Mock Fees Data
  final List<Fee> _fees = [
    Fee(id: '1', feeType: 'Tuition Fees', amount: 5000, dueDate: DateTime(2025, 4, 10), status: 'Paid', paymentDate: DateTime(2025, 4, 5)),
    Fee(id: '2', feeType: 'Annual Charge', amount: 8000, dueDate: DateTime(2025, 4, 10), status: 'Pending'),
    Fee(id: '3', feeType: 'Books', amount: 3500, dueDate: DateTime(2025, 3, 25), status: 'Late'),
    Fee(id: '4', feeType: 'Uniform', amount: 2500, dueDate: DateTime(2025, 3, 25), status: 'Paid', paymentDate: DateTime(2025, 3, 20)),
    Fee(id: '5', feeType: 'Development Fees', amount: 2000, dueDate: DateTime(2025, 6, 10), status: 'Pending'),
    Fee(id: '6', feeType: 'Board Fees', amount: 1500, dueDate: DateTime(2025, 2, 15), status: 'Pending'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.student.name, style: AppTextStyles.heading2.copyWith(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 24),
            Text('Fee Management', style: AppTextStyles.heading2),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _fees.length,
              itemBuilder: (context, index) {
                final fee = _fees[index];
                // Hide Board Fees if not Class 10 or 12
                if (fee.feeType == 'Board Fees' && !['10', '12'].contains(widget.student.className)) {
                  return const SizedBox.shrink();
                }
                return _buildFeeItem(fee);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Row(
            children: [
               CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: widget.student.photoUrl.startsWith('http') ? NetworkImage(widget.student.photoUrl) : AssetImage(widget.student.photoUrl) as ImageProvider,
                onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 40), 
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.student.name, style: AppTextStyles.heading2),
                    const SizedBox(height: 4),
                    Text('Class: ${widget.student.className}-${widget.student.section} | Roll: ${widget.student.rollNo}', style: AppTextStyles.body),
                     const SizedBox(height: 4),
                    Text('Gender: ${widget.student.gender}', style: AppTextStyles.body),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          _buildInfoRow('Father\'s Name', widget.student.fatherName),
          const SizedBox(height: 10),
          _buildInfoRow('Mother\'s Name', widget.student.motherName),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Aadhaar No:', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text(
                    _isAadhaarVisible ? widget.student.aadhaar : widget.student.aadhaar.replaceRange(0, 9, 'XXXX-XXXX-'),
                    style: AppTextStyles.body,
                  ),
                  IconButton(
                    icon: Icon(_isAadhaarVisible ? Icons.visibility_off : Icons.visibility, color: AppColors.primary),
                    onPressed: () {
                      setState(() {
                        _isAadhaarVisible = !_isAadhaarVisible;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label:', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
        Text(value, style: AppTextStyles.body),
      ],
    );
  }

  Widget _buildFeeItem(Fee fee) {
    Color statusColor;
    IconData statusIcon;

    switch (fee.status) {
      case 'Paid':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Late':
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      default:
        statusColor = AppColors.error;
        statusIcon = Icons.pending;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(fee.feeType, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DueDate: ${DateFormat('dd MMM yyyy').format(fee.dueDate)}',
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            ),
            InkWell(
               onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _buildFeeHistory(context, fee.feeType),
                  );
               },
               child: const Padding(
                 padding: EdgeInsets.symmetric(vertical: 4.0),
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Icon(Icons.history, size: 14, color: Colors.blue),
                     SizedBox(width: 4),
                     Text('View History', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
                   ],
                 ),
               ),
             ),
          ],
        ),
        trailing: Text('₹${fee.amount.toStringAsFixed(0)}', style: AppTextStyles.heading2.copyWith(fontSize: 16)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (fee.status == 'Paid')
                  Text('Paid on: ${DateFormat('dd MMM yyyy').format(fee.paymentDate!)}', style: const TextStyle(color: Colors.green)),
                if (fee.remarks != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(fee.remarks!, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (fee.status != 'Paid')
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.notifications_active),
                          label: const Text('Send Reminder'),
                          onPressed: () {
                            _showSmsSimulationDialog(
                              "Dear Parent, current status for ${widget.student.name}'s ${fee.feeType} is PENDING. Please pay ₹${fee.amount} by ${DateFormat('dd MMM').format(fee.dueDate)} to avoid late fees.",
                              "Reminder Sent"
                            );
                          },
                        ),
                      ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text('Edit Status', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          // Show Edit Dialog
                          _showEditStatusDialog(fee);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSmsSimulationDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.sms, color: AppColors.secondary),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Simulating SMS sent to registered mobile no:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(message, style: AppTextStyles.body.copyWith(fontSize: 14)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showEditStatusDialog(Fee fee) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Fee Status for ${fee.feeType}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Mark as Paid'),
                subtitle: const Text('Will send payment confirmation SMS'),
                leading: const Icon(Icons.check_circle, color: Colors.green),
                onTap: () {
                  setState(() {
                    fee.status = 'Paid';
                    fee.paymentDate = DateTime.now();
                    fee.remarks = 'Edited by Admin on ${DateFormat('dd MMM yyyy').format(DateTime.now())}';
                  });
                  Navigator.pop(context);
                  _showSmsSimulationDialog(
                      "Dear Parent, received ₹${fee.amount} for ${widget.student.name}'s ${fee.feeType}. Thank you.",
                      "Payment Confirmation"
                  );
                },
              ),
              ListTile(
                title: const Text('Mark as Late & Apply Charge'),
                subtitle: const Text('Adds ₹500 Late Fee'),
                leading: const Icon(Icons.warning, color: Colors.orange),
                onTap: () {
                   setState(() {
                    fee.status = 'Late';
                    // fee.amount += 500; // In a real app we would update amount, but keeping simple for UI demo
                    fee.remarks = 'Late Fee (+₹500) Applied by Admin on ${DateFormat('dd MMM yyyy').format(DateTime.now())}';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildFeeHistory(BuildContext context, String feeType) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$feeType History', style: AppTextStyles.heading2),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: const Text('Paid - Jan 2025'),
            subtitle: const Text('Via UPI • 10 Jan 2025'),
            trailing: const Text('₹5,000', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: const Text('Paid - Dec 2024'),
            subtitle: const Text('Via Cash • 05 Dec 2024'),
            trailing: const Text('₹5,000', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.warning, color: Colors.orange),
            title: const Text('Late Fee - Nov 2024'),
            subtitle: const Text('Paid with Fine • 20 Nov 2024'),
            trailing: const Text('₹5,500', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
