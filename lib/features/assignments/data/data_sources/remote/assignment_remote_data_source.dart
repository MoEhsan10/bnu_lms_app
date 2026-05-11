import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:bnu_lms_app/shared/config/api_constants.dart';

import '../../models/assignment_model.dart';
import '../../models/submission_model.dart';


abstract class AssignmentRemoteDataSource {
  Future<List<AssignmentModel>> getAssignmentsByCourse(int courseId);
  Future<AssignmentModel> getAssignmentDetail(int assignmentId);
  Future<int> createAssignment(int courseId, Map<String, dynamic> assignmentData);
  Future<void> submitAssignment(int assignmentId, Map<String, dynamic> submissionData);
  Future<List<SubmissionModel>> getSubmissions(int assignmentId);
  Future<void> gradeSubmission(int submissionId, double grade, String feedback);
}

@LazySingleton(as: AssignmentRemoteDataSource)
class AssignmentRemoteDataSourceImpl implements AssignmentRemoteDataSource {
  final Dio dio;

  AssignmentRemoteDataSourceImpl(this.dio);

  @override
  Future<List<AssignmentModel>> getAssignmentsByCourse(int courseId) async {
    final response = await dio.get(ApiConstants.assignmentCourseList(courseId));
    return (response.data as List).map((json) => AssignmentModel.fromJson(json)).toList();
  }

  @override
  Future<AssignmentModel> getAssignmentDetail(int assignmentId) async {
    final response = await dio.get(ApiConstants.assignmentDetail(assignmentId));
    return AssignmentModel.fromJson(response.data);
  }

  @override
  Future<int> createAssignment(int courseId, Map<String, dynamic> assignmentData) async {
    // Add courseId to the map so it's included in FormData
    final Map<String, dynamic> dataWithCourse = Map.from(assignmentData);
    dataWithCourse['courseId'] = courseId;

    final formData = FormData.fromMap(dataWithCourse);

    // If filePath is present, add it as a file
    if (dataWithCourse.containsKey('filePath') && dataWithCourse['filePath'] != null) {
      String path = dataWithCourse['filePath'];
      formData.files.add(MapEntry(
        'file',
        await MultipartFile.fromFile(path, filename: path.split('/').last),
      ));
    }

    final response = await dio.post(
      ApiConstants.assignmentCreate,
      data: formData,
    );
    return _parseCreatedAssignmentId(response.data);
  }

  /// API returns `{ "id": n }` (camelCase JSON); tolerate plain int for older builds.
  int _parseCreatedAssignmentId(dynamic data) {
    if (data is int) return data;
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final v = map['id'] ?? map['Id'];
      if (v is int) return v;
      if (v is num) return v.toInt();
    }
    throw FormatException('Unexpected create assignment response: $data');
  }

  @override
  Future<void> submitAssignment(int assignmentId, Map<String, dynamic> submissionData) async {
    final formData = FormData.fromMap(submissionData);

    if (submissionData.containsKey('filePath') && submissionData['filePath'] != null) {
      String path = submissionData['filePath'];
      formData.files.add(MapEntry(
        'file',
        await MultipartFile.fromFile(path, filename: path.split('/').last),
      ));
    }

    await dio.post(
      ApiConstants.assignmentSubmit(assignmentId),
      data: formData,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );
  }

  @override
  Future<List<SubmissionModel>> getSubmissions(int assignmentId) async {
    final response = await dio.get(ApiConstants.assignmentSubmissions(assignmentId));
    return (response.data as List).map((json) => SubmissionModel.fromJson(json)).toList();
  }

  @override
  Future<void> gradeSubmission(int submissionId, double grade, String feedback) async {
    await dio.patch(
      ApiConstants.submissionGrade(submissionId),
      data: <String, dynamic>{
        'grade': grade,
        'feedback': feedback,
      },
    );
  }
}
