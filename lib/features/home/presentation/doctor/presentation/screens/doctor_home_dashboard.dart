import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/app_sizes.dart';

// Import the separated section widgets
import '../../../../../grades/presentation/widgets/grades_course_selection_screen.dart';
import '../widgets/doctor_dashboard_top_header.dart';
import '../widgets/doctor_stats_grid.dart';
import '../widgets/doctor_quick_access_section.dart';
import '../widgets/doctor_my_courses_section.dart';

class DoctorHomeDashboard extends StatelessWidget {
  const DoctorHomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const DoctorDashboardTopHeader(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DoctorStatsGrid(),

              SizedBox(height: AppSizes.largeSpacing),

              // Grades Management Card for Instructor
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GradesCourseSelectionScreen(isInstructor: true),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)], // Purple gradient
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: ColorsManager.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.grade_rounded, color: ColorsManager.white, size: 28.sp),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Grades Management',
                                style: AppDarkTextStyles.titleMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Manage exams & final grades',
                                style: AppDarkTextStyles.labelSmall.copyWith(color: ColorsManager.white.withValues(alpha: 0.9)),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: ColorsManager.white, size: 16.sp),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSizes.largeSpacing),

              const DoctorQuickAccessSection(),

              const DoctorMyCoursesSection(),
            ],
          ),
        ],
      ),
    );
  }
}