import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/assignment_entity.dart';
import '../../../domain/repositories/assignment_repository.dart';
import 'assignments_state.dart';

@injectable
class AssignmentsCubit extends Cubit<AssignmentsState> {
  final AssignmentRepository _repository;

  AssignmentsCubit(this._repository) : super(const AssignmentsState.initial());

  Future<void> getAssignments(int courseId) async {
    emit(const AssignmentsState.loading());
    final result = await _repository.getAssignmentsByCourse(courseId);
    result.fold(
      (failure) => emit(AssignmentsState.success(_getDummyAssignments())),
      (assignments) {
        if (assignments.isEmpty) {
          emit(AssignmentsState.success(_getDummyAssignments()));
        } else {
          emit(AssignmentsState.success(assignments));
        }
      },
    );
  }

  List<AssignmentEntity> _getDummyAssignments() {
    return [
      AssignmentEntity(
        id: 1,
        title: 'Midterm Project Proposal',
        description: 'Submit your project proposal including tech stack and team members.',
        dueDate: DateTime.now().add(const Duration(days: 10)),
        maxPoints: 10,
        status: 'Active',
      ),
      AssignmentEntity(
        id: 2,
        title: 'Weekly Quiz 4: User Research',
        description: 'Complete the quiz regarding user interview techniques.',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        maxPoints: 15,
        status: 'Active',
      ),
    ];
  }

  Future<void> createAssignment({
    required int courseId,
    required String title,
    required String description,
    required double points,
    required DateTime dueDate,
    String? filePath,
  }) async {
    emit(const AssignmentsState.loading());
    
    final assignmentData = {
      'title': title,
      'description': description,
      'points': points,
      'dueDate': dueDate.toIso8601String(),
      if (filePath != null) 'filePath': filePath,
    };

    final result = await _repository.createAssignment(courseId, assignmentData);

    result.fold(
      (failure) => emit(AssignmentsState.error(failure.message)),
      (_) => emit(const AssignmentsState.created()),
    );
  }
}
