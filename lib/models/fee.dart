class Fee {
  final String id;
  final String feeType; // Tuition, Annual, Board, Development, Books, Uniform
  final double amount;
  final DateTime dueDate;
  String status; // Paid, Pending, Late
  DateTime? paymentDate;
  String? remarks; // "Edited by Admin on..."

  Fee({
    required this.id,
    required this.feeType,
    required this.amount,
    required this.dueDate,
    this.status = 'Pending',
    this.paymentDate,
    this.remarks,
  });
}
