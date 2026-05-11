import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/resources/app_text_styles.dart';
import '../../../../shared/resources/color_manager.dart';
import '../../../../shared/di/injection.dart';
import '../manager/instructor/assignments_cubit.dart';
import '../manager/instructor/assignments_state.dart';
import '../screens/create_assignment_screen.dart';
import '../../domain/entities/assignment_entity.dart';

class InstructorAssignmentsTab extends StatelessWidget {
  final int courseId;

  const InstructorAssignmentsTab({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AssignmentsCubit>()..getAssignments(courseId),
      child: BlocBuilder<AssignmentsCubit, AssignmentsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAssignmentScreen(courseId: courseId),
                          ),
                        ).then((_) => context.read<AssignmentsCubit>().getAssignments(courseId));
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: Text('Create Assignment', style: AppTextStyles.buttonText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text('Course Assignments', style: AppTextStyles.titleMedium),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: state.maybeWhen(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      success: (assignments) => assignments.isEmpty 
                        ? const Center(child: Text("No assignments yet"))
                        : ListView.builder(
                            itemCount: assignments.length,
                            itemBuilder: (context, index) {
                              return _buildInstructorAssignmentCard(context, assignments[index]);
                            },
                          ),
                      error: (message) => Center(child: Text(message)),
                      orElse: () => const Center(child: Text("Initializing...")),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInstructorAssignmentCard(BuildContext context, AssignmentEntity assignment) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorManager.borderColor, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(assignment.title, style: AppTextStyles.titleMedium),
              Icon(Icons.more_vert, color: ColorManager.textSecondary, size: 20.sp),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Due: ${assignment.dueDate.day} ${_getMonth(assignment.dueDate.month)}', style: AppTextStyles.bodySmall),
              Text('Submitted: --/--', style: AppTextStyles.labelSmall.copyWith(color: ColorManager.primary)),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // TODO: Navigate to SubmissionsListScreen
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: ColorManager.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                padding: EdgeInsets.symmetric(vertical: 10.h),
              ),
              child: Text('View Submissions', style: AppTextStyles.labelSmall.copyWith(color: ColorManager.primary)),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
