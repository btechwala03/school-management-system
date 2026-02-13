class Student {
  final String id;
  final String name;
  final String rollNo;
  final String className;
  final String section;
  final String fatherName;
  final String motherName;
  final String aadhaar;
  final String gender;
  final String photoUrl;

  final String admissionNumber;
  final String mobileNumber;
  final String address;

  Student({
    required this.id,
    required this.name,
    required this.rollNo,
    required this.className,
    required this.section,
    required this.fatherName,
    required this.motherName,
    required this.aadhaar,
    required this.gender,
    required this.photoUrl,
    this.admissionNumber = '',
    this.mobileNumber = '',
    this.address = '',
  });
}
