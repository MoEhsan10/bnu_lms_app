import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/di/injection.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../cubit/student_attendance_cubit.dart';
import '../cubit/student_attendance_state.dart';
import 'student_attendance_screen.dart';

class AttendanceScreen extends StatelessWidget {
  final int courseId;

  const AttendanceScreen({super.key, this.courseId = 1});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StudentAttendanceCubit>()..fetchDashboard(courseId),
      child: _AttendanceDashboardBody(courseId: courseId),
    );
  }
}

class _AttendanceDashboardBody extends StatelessWidget {
  final int courseId;

  const _AttendanceDashboardBody({required this.courseId});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final screenBg = isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground;
    final cardBg = isLight ? ColorsManager.white : ColorsManager.darkSurface;
    final appBarBg = isLight ? ColorsManager.white : ColorsManager.darkSurface;
    final headlineStyle = isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall;
    final titleStyle = isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium;
    final bodyStyle = isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium;

    return Scaffold(
      backgroundColor: screenBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Attendance",
          style: headlineStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            color: ColorsManager.blue,
            onPressed: () => context.read<StudentAttendanceCubit>().fetchDashboard(courseId),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<StudentAttendanceCubit, StudentAttendanceState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: ColorsManager.blue,
            onRefresh: () => context.read<StudentAttendanceCubit>().fetchDashboard(courseId),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 1. Scan CTA Card ──────────────────────────────────────
                  _ScanCard(courseId: courseId),

                  SizedBox(height: 24.h),

                  // ── 2. Term Overview Card ─────────────────────────────────
                  Text(
                    "Term Overview",
                    style: titleStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  _buildOverviewCard(context, state, cardBg, bodyStyle, isLight),

                  SizedBox(height: 28.h),

                  // ── 3. Recent Logs ────────────────────────────────────────
                  Text(
                    "Recent Logs",
                    style: titleStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  _buildRecentLogs(context, state, cardBg, isLight),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context,
    StudentAttendanceState state,
    Color cardBg,
    TextStyle bodyStyle,
    bool isLight,
  ) {
    if (state is StudentDashboardLoading) {
      return Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: ColorsManager.blue),
        ),
      );
    }

    int present = 0;
    int absent = 0;
    double rate = 0.0;

    if (state is StudentDashboardLoaded) {
      present = state.presentCount;
      absent = state.absentCount;
      rate = state.attendanceRate;
    }

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${rate.toStringAsFixed(1)}%",
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w900,
                  color: ColorsManager.blue,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Attendance Rate",
                style: bodyStyle.copyWith(
                  color: ColorsManager.grayMedium,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _MetricItem(label: "Present", value: present, color: ColorsManager.green),
              SizedBox(width: 20.w),
              _MetricItem(label: "Absent", value: absent, color: ColorsManager.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentLogs(
    BuildContext context,
    StudentAttendanceState state,
    Color cardBg,
    bool isLight,
  ) {
    if (state is StudentDashboardLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(color: ColorsManager.blue),
        ),
      );
    }

    if (state is StudentDashboardError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            state.message,
            style: TextStyle(color: ColorsManager.red, fontSize: 13.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state is StudentDashboardLoaded) {
      final reports = state.reports;

      if (reports.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32.h),
            child: Column(
              children: [
                Icon(Icons.history_toggle_off_rounded, size: 40.sp, color: ColorsManager.grayMedium),
                SizedBox(height: 8.h),
                Text(
                  "No attendance records yet.",
                  style: TextStyle(color: ColorsManager.grayMedium, fontSize: 13.sp),
                ),
              ],
            ),
          ),
        );
      }

      // Flatten all records across sessions into one flat log list
      final List<_LogItem> logs = [];
      for (final report in reports) {
        for (final rec in report.attendanceRecords) {
          logs.add(_LogItem(
            sessionTitle: report.sessionTitle,
            scannedAt: rec.scannedAt,
            isPresent: rec.isPresent,
          ));
        }
      }

      // Sort by most recent first
      logs.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final item = logs[index];
          final timeStr =
              "${item.scannedAt.hour.toString().padLeft(2, '0')}:${item.scannedAt.minute.toString().padLeft(2, '0')}";

          return _LogCard(
            sessionTitle: item.sessionTitle,
            time: timeStr,
            isPresent: item.isPresent,
            cardBg: cardBg,
            isLight: isLight,
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}

// ── CTA Scan Card ─────────────────────────────────────────────────────────────

class _ScanCard extends StatelessWidget {
  final int courseId;

  const _ScanCard({required this.courseId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StudentAttendanceScreen(courseId: courseId),
          ),
        );
        if (result == true && context.mounted) {
          context.read<StudentAttendanceCubit>().fetchDashboard(courseId);
        }
      },
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [ColorsManager.blue, Color(0xFF1AA6C0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.blue.withValues(alpha: 0.3),
              blurRadius: 16.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
                size: 30.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Scan Attendance",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Mark present for today's lecture",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Metric column ─────────────────────────────────────────────────────────────

class _MetricItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _MetricItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$value",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: ColorsManager.grayMedium),
        ),
      ],
    );
  }
}

// ── Log card ──────────────────────────────────────────────────────────────────

class _LogCard extends StatelessWidget {
  final String sessionTitle;
  final String time;
  final bool isPresent;
  final Color cardBg;
  final bool isLight;

  const _LogCard({
    required this.sessionTitle,
    required this.time,
    required this.isPresent,
    required this.cardBg,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sessionTitle,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  "Time: $time",
                  style: TextStyle(fontSize: 11.sp, color: ColorsManager.grayMedium),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: (isPresent ? ColorsManager.green : ColorsManager.red).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              isPresent ? "PRESENT" : "ABSENT",
              style: TextStyle(
                color: isPresent ? ColorsManager.green : ColorsManager.red,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Internal data class ───────────────────────────────────────────────────────

class _LogItem {
  final String sessionTitle;
  final DateTime scannedAt;
  final bool isPresent;

  _LogItem({required this.sessionTitle, required this.scannedAt, required this.isPresent});
}
