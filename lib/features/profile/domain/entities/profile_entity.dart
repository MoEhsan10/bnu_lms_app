import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String faculty;
  final int academicYear;
  final int creditHours;
  final int enrolledCoursesCount;

  const ProfileEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.faculty,
    required this.academicYear,
    required this.creditHours,
    required this.enrolledCoursesCount,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        faculty,
        academicYear,
        creditHours,
        enrolledCoursesCount,
      ];
}
