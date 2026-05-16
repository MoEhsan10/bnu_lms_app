import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../assignments/presentation/screens/create_assignment_screen.dart';
import '../../../../../../assignments/presentation/screens/assignment_submissions_screen.dart';
import '../../../../../../assignments/presentation/manager/instructor/assignments_cubit.dart';
import '../../../../../../assignments/presentation/manager/instructor/assignments_state.dart';
import '../../../../../../assignments/domain/entities/assignment_entity.dart';

class TaCourseAssignmentsTab extends StatelessWidget {
  final int courseId;
  const TaCourseAssignmentsTab({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    return BlocBuilder<AssignmentsCubit, AssignmentsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Create Assignment Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<AssignmentsCubit>(),
                            child: CreateAssignmentScreen(courseId: courseId),
                          ),
                        ),
                      ).then((_) => context.read<AssignmentsCubit>().getAssignments(courseId));
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: Text(
                      'Create Assignment',
                      style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cyan,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Course Assignments',
                  style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: state.maybeWhen(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    success: (assignments) => assignments.isEmpty
                        ? Center(
                            child: Text(
                              'No assignments yet.',
                              style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            itemCount: assignments.length,
                            itemBuilder: (context, index) {
                              return _buildTaAssignmentCard(context, assignments[index]);
                            },
                          ),
                    error: (message) => Center(
                      child: Text(
                        message,
                        style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium)
                            .copyWith(color: ColorsManager.red),
                      ),
                    ),
                    orElse: () => Center(
                      child: Text(
                        'Initializing...',
                        style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaAssignmentCard(BuildContext context, AssignmentEntity assignment) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    const cyan = Color(0xFF2FBAD7);
    final shadowColor = Colors.black.withValues(alpha: 0.05);

    // Determine status
    final isPastDue = DateTime.now().isAfter(assignment.dueDate);
    final statusText = isPastDue ? 'PAST DUE' : 'ACTIVE';
    final statusColor = isPastDue ? ColorsManager.green : Colors.orange;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isLight
            ? [BoxShadow(color: shadowColor, blurRadius: 10, offset: const Offset(0, 4))]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Status Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.more_horiz, color: ColorsManager.grayMedium, size: 20.sp),
            ],
          ),
          SizedBox(height: 12.h),

          // Title
          Text(
            assignment.title,
            style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),

          // Details Row
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 14.sp, color: ColorsManager.grayMedium),
              SizedBox(width: 6.w),
              Text(
                'Due: ${assignment.dueDate.day} ${_getMonth(assignment.dueDate.month)}, ${assignment.dueDate.year}',
                style: TextStyle(fontSize: 12.sp, color: ColorsManager.grayMedium),
              ),
              const Spacer(),
              Text(
                '${assignment.maxPoints.toInt()} Points',
                style: TextStyle(fontSize: 12.sp, color: cyan, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          Divider(color: ColorsManager.grayMedium.withValues(alpha: 0.1)),
          SizedBox(height: 12.h),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssignmentSubmissionsScreen(assignmentId: assignment.id),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cyan,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              ),
              child: Text(
                'View Submissions',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
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