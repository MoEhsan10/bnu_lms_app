class AttendanceRecordEntity {
  final String studentId;
  final String studentName;
  final DateTime scannedAt;
  final bool isPresent;

  const AttendanceRecordEntity({
    required this.studentId,
    required this.studentName,
    required this.scannedAt,
    required this.isPresent,
  });
}
