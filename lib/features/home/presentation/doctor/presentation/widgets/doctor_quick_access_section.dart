import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/app_sizes.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import 'quick_action_card.dart';

import '../../../../../attendance/presentation/screens/instructor_attendance_screen.dart';
import '../../../../../../shared/routes_manager/routes.dart';

class DoctorQuickAccessSection extends StatelessWidget {
  const DoctorQuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 30),
          child: Text(
            localizations.quickAccess,
            style: isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium,
          ),
        ),
        SizedBox(height: AppSizes.mediumSpacing),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QuickActionCard(
                  icon: Icons.how_to_reg_outlined,
                  label: 'Take Attendance',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InstructorAttendanceScreen(
                          courseId: 1, // Default placeholder
                          lectureId: 1,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 16.w),
                QuickActionCard(
                  icon: Icons.assignment_add,
                  label: 'Create Assignment',
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            // New Full-Width Quiz Creation Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Routes.quizWizard);
                },
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF26C6DA), Color(0xFF0097A7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF26C6DA).withValues(alpha: 0.3),
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
                        child: Icon(Icons.quiz_rounded, color: ColorsManager.white, size: 28.sp),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create Assessment',
                              style: AppDarkTextStyles.titleMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Build a new interactive quiz or exam',
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
            
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QuickActionCard(
                  icon: Icons.campaign_outlined,
                  label: 'Post Update',
                  onTap: () {},
                ),
                SizedBox(width: 16.w),
                // Placeholder for balance
                QuickActionCard(
                  icon: Icons.insights,
                  label: 'Analytics',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}