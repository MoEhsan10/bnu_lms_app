import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/resources/app_text_styles.dart';
import '../../../../shared/resources/color_manager.dart';
import '../../../../shared/di/injection.dart';
import '../manager/student/student_assignments_cubit.dart';
import '../manager/student/student_assignments_state.dart';
import '../screens/assignment_details_screen.dart';
import '../screens/assignment_result_screen.dart';
import '../../domain/entities/assignment_entity.dart';

class StudentAssignmentsTab extends StatelessWidget {
  final int courseId;

  const StudentAssignmentsTab({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StudentAssignmentsCubit>()..getAssignments(courseId),
      child: BlocBuilder<StudentAssignmentsCubit, StudentAssignmentsState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (assignments) => RefreshIndicator(
              onRefresh: () => context.read<StudentAssignmentsCubit>().fetchAssignments(courseId),
              child: assignments.isEmpty 
                ? ListView( // Use ListView even when empty to allow RefreshIndicator to work
                    children: [
                      SizedBox(height: 100.h),
                      const Center(child: Text("No assignments yet")),
                    ],
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(20.w),
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      return _buildStudentAssignmentCard(context, assignments[index]);
                    },
                  ),
            ),
            error: (message) => Center(child: Text(message)),
            orElse: () => const Center(child: Text("Initializing...")),
          );
        },
      ),
    );
  }

  Widget _buildStudentAssignmentCard(BuildContext context, AssignmentEntity assignment) {
    bool isPending = assignment.status.toLowerCase() == 'pending' || assignment.status.toLowerCase() == 'upcoming';
    bool isGraded = assignment.status.toLowerCase() == 'graded' || assignment.status.toLowerCase() == 'completed';

    return GestureDetector(
      onTap: () {
        if (isGraded) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AssignmentResultScreen(assignment: assignment)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AssignmentDetailsScreen(assignment: assignment)),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ColorManager.cardBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: ColorManager.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _StatusIndicator(status: assignment.status),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(assignment.title, style: AppTextStyles.titleMedium),
                  SizedBox(height: 4.h),
                  Text(
                    'Due: ${assignment.dueDate.day}/${assignment.dueDate.month}/${assignment.dueDate.year}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: ColorManager.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final String status;

  const _StatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
      case 'upcoming':
        color = ColorManager.warning;
        break;
      case 'submitted':
        color = ColorManager.primary;
        break;
      case 'graded':
      case 'completed':
        color = ColorManager.success;
        break;
      default:
        color = ColorManager.textSecondary;
    }

    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status.toLowerCase() == 'graded' ? Icons.check_circle : Icons.assignment_outlined,
        color: color,
        size: 24.sp,
      ),
    );
  }
}
