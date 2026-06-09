import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/quiz_entity.dart';
import '../../models/quiz_attempt_model.dart';
import '../../models/quiz_model.dart';
import '../../models/quiz_take_model.dart';

abstract class QuizRemoteDataSource {
  Future<List<QuizModel>> getQuizzes(int courseId);
  Future<QuizAttemptModel> submitQuiz(int quizId, Map<String, dynamic> submissionData);
  Future<bool> gradeEssay(int quizId, int attemptId, double manualScore);
  Future<bool> publishGrades(int quizId);
  Future<QuizModel> createQuiz(QuizEntity quiz);
  Future<bool> updateQuiz(int quizId, QuizEntity quiz);
  Future<List<QuizAttemptModel>> getQuizAttempts(int quizId);
  Future<QuizAttemptModel> getStudentAttempt(int quizId);
  Future<QuizTakeModel> getQuizForTaking(int quizId);
}

@LazySingleton(as: QuizRemoteDataSource)
class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final Dio dio;

  QuizRemoteDataSourceImpl(this.dio);

  @override
  Future<List<QuizModel>> getQuizzes(int courseId) async {
    final response = await dio.get('quiz/course/$courseId');
    return (response.data as List).map((x) => QuizModel.fromJson(x)).toList();
  }

  @override
  Future<QuizAttemptModel> submitQuiz(int quizId, Map<String, dynamic> submissionData) async {
    final response = await dio.post('quiz/$quizId/submit', data: submissionData);
    return QuizAttemptModel.fromJson(response.data);
  }

  @override
  Future<bool> gradeEssay(int quizId, int attemptId, double manualScore) async {
    final response = await dio.put('quiz/$quizId/attempts/$attemptId/grade', data: manualScore);
    return response.statusCode == 200;
  }

  @override
  Future<bool> publishGrades(int quizId) async {
    final response = await dio.put('quiz/$quizId/publish-grades');
    return response.statusCode == 200;
  }

  @override
  Future<QuizModel> createQuiz(QuizEntity quiz) async {
    final data = {
      "title": quiz.title,
      "description": quiz.description,
      "courseId": quiz.courseId,
      "startDate": quiz.startDate.toIso8601String(),
      "endDate": quiz.endDate.toIso8601String(),
      "durationMinutes": quiz.durationMinutes,
      "isAutoGraded": quiz.isAutoGraded,
      if (quiz.creationQuestions != null)
        "questions": quiz.creationQuestions!.map((q) => {
          "text": q['text'],
          "imageUrl": null,
          "isEssay": q['isEssay'] ?? false,
          "points": q['points'] ?? 1,
          "options": q['options'] != null ? (q['options'] as List).map((o) => {
            "text": o['text'],
            "isCorrect": o['isCorrect'],
          }).toList() : [],
        }).toList(),
    };
    print("Creating quiz at: ${dio.options.baseUrl}quiz"); // ده عشان تشوف اللينك في اللوج
    final response = await dio.post('quiz', data: data);
    return QuizModel.fromJson(response.data);
  }

  @override
  Future<bool> updateQuiz(int quizId, QuizEntity quiz) async {
    final data = {
      "title": quiz.title,
      "description": quiz.description,
      "startDate": quiz.startDate.toIso8601String(),
      "endDate": quiz.endDate.toIso8601String(),
      "durationMinutes": quiz.durationMinutes,
      "isAutoGraded": quiz.isAutoGraded,
    };
    final response = await dio.put('quiz/$quizId', data: data);
    return response.statusCode == 200;
  }

  @override
  Future<List<QuizAttemptModel>> getQuizAttempts(int quizId) async {
    final response = await dio.get('quiz/$quizId/attempts');
    return (response.data as List).map((x) => QuizAttemptModel.fromJson(x)).toList();
  }

  @override
  Future<QuizTakeModel> getQuizForTaking(int quizId) async {
    final response = await dio.get('quiz/$quizId/take');
    return QuizTakeModel.fromJson(response.data);
  }

  @override
  Future<QuizAttemptModel> getStudentAttempt(int quizId) async {
    try {
      final response = await dio.get('quiz/$quizId/my-attempt');
      return QuizAttemptModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception("Grades are not published yet.");
      }
      rethrow;
    }
  }
}
