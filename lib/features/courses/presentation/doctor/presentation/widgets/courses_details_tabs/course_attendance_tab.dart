import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/di/injection.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../attendance/domain/entities/course_attendance_report_entity.dart';
import '../../../../../../attendance/presentation/cubit/instructor_attendance_cubit.dart';
import '../../../../../../attendance/presentation/cubit/instructor_attendance_state.dart';
import '../../../../../../attendance/presentation/screens/instructor_attendance_screen.dart';

class CourseAttendanceTab extends StatelessWidget {
  final int courseId;

  const CourseAttendanceTab({super.key, this.courseId = 1});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InstructorAttendanceCubit>()..fetchPastSessions(courseId),
      child: _CourseAttendanceTabBody(courseId: courseId),
    );
  }
}

class _CourseAttendanceTabBody extends StatelessWidget {
  final int courseId;

  const _CourseAttendanceTabBody({required this.courseId});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return RefreshIndicator(
      onRefresh: () => context.read<InstructorAttendanceCubit>().fetchPastSessions(courseId),
      color: ColorsManager.blue,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Take Attendance Button
            InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InstructorAttendanceScreen(
                      courseId: courseId,
                      lectureId: 1, // Defaulting to first lecture
                    ),
                  ),
                );
                // Refresh list if a new session was created
                if (result == true && context.mounted) {
                  context.read<InstructorAttendanceCubit>().fetchPastSessions(courseId);
                }
              },
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: ColorsManager.blue,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: ColorsManager.blue.withValues(alpha: 0.3),
                      blurRadius: 12.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.how_to_reg, color: ColorsManager.white, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Take Attendance',
                      style: AppDarkTextStyles.labelLarge.copyWith(
                        color: ColorsManager.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attendance History',
                  style: isLight
                      ? AppLightTextStyles.headlineSmall
                      : AppDarkTextStyles.headlineSmall,
                ),
                Text(
                  'Live Sync',
                  style: AppLightTextStyles.labelMedium.copyWith(
                    color: ColorsManager.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            BlocBuilder<InstructorAttendanceCubit, InstructorAttendanceState>(
              builder: (context, state) {
                if (state is InstructorAttendanceLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: ColorsManager.blue),
                    ),
                  );
                } else if (state is InstructorAttendanceError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        state.message,
                        style: TextStyle(color: ColorsManager.red, fontSize: 14.sp),
                      ),
                    ),
                  );
                } else if (state is InstructorHistoryLoaded) {
                  final reports = state.reports;
                  if (reports.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Column(
                          children: [
                            Icon(
                              Icons.history_toggle_off_rounded,
                              size: 48.sp,
                              color: ColorsManager.grayMedium,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              "No past attendance sessions",
                              style: TextStyle(
                                color: ColorsManager.grayMedium,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      // Calculate Present and Absent percentages
                      final totalStudents = report.attendanceRecords.length;
                      final presentStudents = report.attendanceRecords.where((r) => r.isPresent).length;
                      final absentStudents = totalStudents - presentStudents;

                      final presentPct = totalStudents > 0 ? ((presentStudents / totalStudents) * 100).round() : 0;
                      final absentPct = totalStudents > 0 ? ((absentStudents / totalStudents) * 100).round() : 0;

                      // Format date e.g., "Monday, Oct 24"
                      final dateStr = "${_getWeekdayName(report.createdAt.weekday)}, ${_getMonthName(report.createdAt.month)} ${report.createdAt.day}";

                      return _buildAttendanceCard(
                        context,
                        report,
                        dateStr,
                        "Session #${report.sessionId} • ${report.sessionTitle}",
                        presentPct,
                        absentPct,
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(
    BuildContext context,
    CourseAttendanceReportEntity report,
    String date,
    String sessionInfo,
    int present,
    int absent,
  ) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8.r,
                  offset: const Offset(0, 2),
                )
              ]
            : [],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: isLight
                          ? AppLightTextStyles.titleMedium
                          : AppDarkTextStyles.titleMedium,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      sessionInfo,
                      style: isLight
                          ? AppLightTextStyles.labelSmall
                          : AppDarkTextStyles.labelSmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: ColorsManager.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'COMPLETED',
                  style: AppLightTextStyles.labelSmall.copyWith(
                    color: ColorsManager.blue,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '$present%',
                    style: (isLight
                            ? AppLightTextStyles.headlineMedium
                            : AppDarkTextStyles.headlineMedium)
                        .copyWith(color: ColorsManager.blue),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'PRESENT',
                    style: (isLight
                            ? AppLightTextStyles.labelSmall
                            : AppDarkTextStyles.labelSmall)
                        .copyWith(fontSize: 10.sp),
                  ),
                  SizedBox(width: 20.w),
                  Text(
                    '$absent%',
                    style: (isLight
                            ? AppLightTextStyles.headlineMedium
                            : AppDarkTextStyles.headlineMedium)
                        .copyWith(color: ColorsManager.red),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'ABSENT',
                    style: (isLight
                            ? AppLightTextStyles.labelSmall
                            : AppDarkTextStyles.labelSmall)
                        .copyWith(fontSize: 10.sp),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showSessionDetails(context, report),
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Text(
                    'Details >',
                    style: AppLightTextStyles.labelMedium.copyWith(
                      color: ColorsManager.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSessionDetails(BuildContext context, CourseAttendanceReportEntity report) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final modalBg = isLight ? ColorsManager.white : ColorsManager.darkSurface;
    final textStyle = isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium;
    final titleStyle = isLight ? AppLightTextStyles.titleLarge : AppDarkTextStyles.titleLarge;

    showModalBottomSheet(
      context: context,
      backgroundColor: modalBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      isScrollControlled: true,
      builder: (context) {
        final attendees = report.attendanceRecords.where((r) => r.isPresent).toList();

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pull Bar
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: ColorsManager.grayMedium.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              // Title Info
              Text(
                report.sessionTitle,
                style: titleStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                "Session #${report.sessionId} • ${attendees.length} Students Present",
                style: AppLightTextStyles.labelSmall.copyWith(
                  color: ColorsManager.grayMedium,
                ),
              ),
              SizedBox(height: 16.h),
              const Divider(),
              SizedBox(height: 8.h),
              // List
              Expanded(
                child: attendees.isEmpty
                    ? Center(
                        child: Text(
                          "No students attended this session.",
                          style: textStyle.copyWith(color: ColorsManager.grayMedium),
                        ),
                      )
                    : ListView.builder(
                        itemCount: attendees.length,
                        itemBuilder: (context, index) {
                          final attendee = attendees[index];
                          // Time formatting e.g. "10:14"
                          final scanTime = "${attendee.scannedAt.hour.toString().padLeft(2, '0')}:${attendee.scannedAt.minute.toString().padLeft(2, '0')}";

                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: isLight
                                  ? ColorsManager.white
                                  : ColorsManager.darkBackground,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: ColorsManager.blue.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18.r,
                                  backgroundColor: ColorsManager.blue.withValues(alpha: 0.1),
                                  child: Icon(
                                    Icons.person,
                                    color: ColorsManager.blue,
                                    size: 18.sp,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        attendee.studentName,
                                        style: textStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        "ID: ${attendee.studentId}",
                                        style: AppLightTextStyles.labelSmall.copyWith(
                                          color: ColorsManager.grayMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: ColorsManager.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: ColorsManager.green,
                                        size: 10.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        scanTime,
                                        style: AppLightTextStyles.labelSmall.copyWith(
                                          color: ColorsManager.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getWeekdayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    if (weekday < 1 || weekday > 7) return 'Monday';
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    if (month < 1 || month > 12) return 'Oct';
    return months[month - 1];
  }
}