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
    final response = await dio.get('${ApiConstants.baseUrl}/Assignment/course/$courseId');
    return (response.data as List).map((json) => AssignmentModel.fromJson(json)).toList();
  }

  @override
  Future<AssignmentModel> getAssignmentDetail(int assignmentId) async {
    final response = await dio.get('${ApiConstants.baseUrl}/Assignment/$assignmentId');
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

    // DEBUG: Confirm it's multipart and show full URL
    print("FULL REQUEST URL: ${ApiConstants.baseUrl}/Assignment/create");
    print("Content-Type being sent: multipart/form-data; boundary=${formData.boundary}");

    final response = await dio.post(
      '${ApiConstants.baseUrl}/Assignment/create', 
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    return response.data as int;
  }

  @override
  Future<void> submitAssignment(int assignmentId, Map<String, dynamic> submissionData) async {
    await dio.post('${ApiConstants.baseUrl}/Assignment/$assignmentId/submit', data: submissionData);
  }

  @override
  Future<List<SubmissionModel>> getSubmissions(int assignmentId) async {
    final response = await dio.get('${ApiConstants.baseUrl}/Assignment/$assignmentId/submissions');
    return (response.data as List).map((json) => SubmissionModel.fromJson(json)).toList();
  }

  @override
  Future<void> gradeSubmission(int submissionId, double grade, String feedback) async {
    await dio.post('${ApiConstants.baseUrl}/Assignment/submission/$submissionId/grade', data: {
      'grade': grade,
      'feedback': feedback,
    });
  }
}
