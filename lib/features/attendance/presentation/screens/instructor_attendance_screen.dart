import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/di/injection.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../cubit/instructor_attendance_cubit.dart';
import '../cubit/instructor_attendance_state.dart';

class InstructorAttendanceScreen extends StatelessWidget {
  final int courseId;
  final int lectureId;

  const InstructorAttendanceScreen({
    super.key,
    required this.courseId,
    required this.lectureId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InstructorAttendanceCubit>()
        ..createSession(
          courseId: courseId,
          title: "Lecture #$lectureId",
          duration: 90,
          lat: 30.0712,
          lng: 31.2825,
        ),
      child: _InstructorAttendanceScreenBody(
        courseId: courseId,
        lectureId: lectureId,
      ),
    );
  }
}

class _InstructorAttendanceScreenBody extends StatefulWidget {
  final int courseId;
  final int lectureId;

  const _InstructorAttendanceScreenBody({
    required this.courseId,
    required this.lectureId,
  });

  @override
  State<_InstructorAttendanceScreenBody> createState() => _InstructorAttendanceScreenBodyState();
}

class _InstructorAttendanceScreenBodyState extends State<_InstructorAttendanceScreenBody> {
  String _qrToken = ""; // Starts empty; populated from the backend response
  int _studentsAttended = 0;
  Timer? _liveFetchTimer;

  @override
  void initState() {
    super.initState();
    _startLiveFetching();
  }

  @override
  void dispose() {
    _liveFetchTimer?.cancel();
    super.dispose();
  }

  void _startLiveFetching() {
    // Poll for attended students every 5 seconds to keep the count updated live
    _liveFetchTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        context.read<InstructorAttendanceCubit>().fetchActiveAttendees(widget.courseId);
      }
    });
  }

  void _showAttendeesBottomSheet(BuildContext context) {
    context.read<InstructorAttendanceCubit>().fetchActiveAttendees(widget.courseId);

    final isLight = Provider.of<ThemeProvider>(context, listen: false).isLightTheme();
    final sheetBg = isLight ? ColorsManager.white : ColorsManager.darkSurface;
    final textStyle = isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium;
    final subtextStyle = isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium;

    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: context.read<InstructorAttendanceCubit>(),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Active Attendees",
                          style: textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18.sp),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      child: BlocBuilder<InstructorAttendanceCubit, InstructorAttendanceState>(
                        builder: (context, state) {
                          if (state is InstructorAttendanceLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          List<dynamic> activeList = [];
                          if (state is InstructorAttendeesLoaded) {
                            activeList = state.attendees;
                          }

                          if (activeList.isEmpty) {
                            return Center(
                              child: Text(
                                "No students have checked in yet.",
                                style: subtextStyle.copyWith(color: ColorsManager.grayMedium),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: activeList.length,
                            itemBuilder: (context, index) {
                              final student = activeList[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: ColorsManager.blue.withValues(alpha: 0.1),
                                  child: Text(
                                    student.studentName.isNotEmpty ? student.studentName[0].toUpperCase() : 'S',
                                    style: const TextStyle(color: ColorsManager.blue, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  student.studentName,
                                  style: textStyle.copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "ID: ${student.studentId.length > 8 ? student.studentId.substring(0, 8) : student.studentId}",
                                  style: subtextStyle.copyWith(fontSize: 12.sp, color: ColorsManager.grayMedium),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: ColorsManager.red),
                                  onPressed: () {
                                    _confirmRevoke(context, student.studentId, student.studentName);
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _confirmRevoke(BuildContext context, String studentId, String studentName) {
    final isLight = Provider.of<ThemeProvider>(context, listen: false).isLightTheme();
    final cardBg = isLight ? ColorsManager.white : ColorsManager.darkSurface;
    final titleStyle = isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium;
    final bodyStyle = isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: cardBg,
        title: Text(
          "Revoke Attendance",
          style: titleStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to mark $studentName as absent? This will permanently delete their scan record.",
          style: bodyStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              "Cancel",
              style: bodyStyle.copyWith(color: ColorsManager.grayMedium),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<InstructorAttendanceCubit>().removeStudentFromAttendance(widget.courseId, studentId);
              Navigator.pop(dialogCtx);
            },
            child: Text(
              "Revoke",
              style: bodyStyle.copyWith(color: ColorsManager.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final appBarBg = isLight ? ColorsManager.white : ColorsManager.darkSurface;
    final screenBg = isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground;
    final cardBg = isLight ? ColorsManager.white : ColorsManager.darkSurface;

    final headlineStyle = isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall;
    final titleStyle = isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium;
    final bodyStyle = isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium;

    return BlocConsumer<InstructorAttendanceCubit, InstructorAttendanceState>(
      listener: (context, state) {
        if (state is InstructorSessionCreated) {
          setState(() {
            _qrToken = state.session.qrCodeToken;
          });
        } else if (state is InstructorAttendeesLoaded) {
          setState(() {
            _studentsAttended = state.attendees.length;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: screenBg,
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Active Session",
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
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),

                  // Course metadata info
                  Text(
                    "CS-201: Advanced Data Structures",
                    style: titleStyle.copyWith(fontWeight: FontWeight.bold, color: ColorsManager.blue),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Lecture #${widget.lectureId} Attendance",
                    style: bodyStyle.copyWith(color: ColorsManager.grayMedium),
                  ),

                  const Spacer(),

                  // QR Code Card
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: isLight
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ]
                          : [],
                    ),
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state is InstructorAttendanceError)
                          SizedBox(
                            width: 240.w,
                            height: 240.w,
                            child: Center(
                              child: Text(
                                state.message,
                                style: bodyStyle.copyWith(color: ColorsManager.red),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        else if (state is InstructorAttendanceLoading || _qrToken.isEmpty)
                          SizedBox(
                            width: 240.w,
                            height: 240.w,
                            child: const Center(child: CircularProgressIndicator()),
                          )
                        else
                          QrImageView(
                            data: _qrToken,
                            version: QrVersions.auto,
                            size: 240.w,
                            gapless: false,
                            eyeStyle: QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: isLight ? ColorsManager.black : ColorsManager.white,
                            ),
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: isLight ? ColorsManager.black : ColorsManager.white,
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Attendance count typography (wrapped in GestureDetector as requested)
                  GestureDetector(
                    onTap: () => _showAttendeesBottomSheet(context),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: ColorsManager.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: ColorsManager.blue.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Students Attended: $_studentsAttended",
                              style: bodyStyle.copyWith(
                                color: ColorsManager.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: ColorsManager.blue,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Stop Attendance Button
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      onPressed: () {
                        // Safe confirmation before closing session
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: cardBg,
                            title: Text(
                              "Stop Attendance",
                              style: titleStyle.copyWith(fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                              "Are you sure you want to end this attendance session? This will close token validation.",
                              style: bodyStyle,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(
                                  "Cancel",
                                  style: bodyStyle.copyWith(color: ColorsManager.grayMedium),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx); // Close dialog
                                  Navigator.pop(context); // Exit attendance screen
                                },
                                child: Text(
                                  "End Session",
                                  style: bodyStyle.copyWith(color: ColorsManager.red, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        "Stop Attendance",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
