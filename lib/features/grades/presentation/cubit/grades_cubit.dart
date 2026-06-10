import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/grades_repository.dart';
import '../../../../shared/services/signalr_service.dart';
import 'grades_state.dart';

@injectable
class GradesCubit extends Cubit<GradesState> {
  final GradesRepository repository;
  final SignalRService signalRService;
  StreamSubscription? _gradeUpdateSubscription;

  GradesCubit(this.repository, this.signalRService) : super(GradesInitial());

  Future<void> loadCourseGrades(int courseId) async {
    emit(GradesLoading());

    final result = await repository.getCourseGrades(courseId);

    result.fold(
      (failure) => emit(GradesError(failure.message)),
      (grades) {
        emit(GradesLoaded(courseGrades: grades));
        _listenToRealTimeUpdates(courseId);
      },
    );
  }

  Future<void> loadStudentGrades(int courseId, String studentId) async {
    emit(GradesLoading());

    final result = await repository.getStudentGrades(courseId, studentId);

    result.fold(
      (failure) => emit(GradesError(failure.message)),
      (grade) {
        emit(GradesLoaded(courseGrades: [], currentStudentGrade: grade));
        _listenToRealTimeUpdates(courseId, studentId: studentId);
      },
    );
  }

  void _listenToRealTimeUpdates(int courseId, {String? studentId}) {
    _gradeUpdateSubscription?.cancel();
    
    _gradeUpdateSubscription = signalRService.gradeUpdateStream.listen((data) {
      if (studentId != null) {
        loadStudentGrades(courseId, studentId);
      } else {
        loadCourseGrades(courseId);
      }
    });
  }

  @override
  Future<void> close() {
    _gradeUpdateSubscription?.cancel();
    return super.close();
  }
}
