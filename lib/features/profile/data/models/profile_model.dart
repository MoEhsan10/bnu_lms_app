class ProfileModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? faculty;
  final int? academicYear;
  final int? creditHours;
  final int? enrolledCoursesCount;

  ProfileModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.faculty,
    this.academicYear,
    this.creditHours,
    this.enrolledCoursesCount,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      faculty: json['faculty'] as String?,
      academicYear: json['academicYear'] as int?,
      creditHours: json['creditHours'] as int?,
      enrolledCoursesCount: json['enrolledCoursesCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'faculty': faculty,
      'academicYear': academicYear,
      'creditHours': creditHours,
      'enrolledCoursesCount': enrolledCoursesCount,
    };
  }
}
