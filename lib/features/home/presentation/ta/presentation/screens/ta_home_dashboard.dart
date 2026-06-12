import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../shared/resources/app_sizes.dart';
import '../widgets/ta_stats_grid.dart';
import '../../../doctor/presentation/widgets/doctor_dashboard_header.dart';
import '../../../doctor/presentation/widgets/teaching_tools_section.dart';
import '../../../../../../shared/routes_manager/routes.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';

class TaHomeDashboard extends StatelessWidget {
  const TaHomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. Reused Header (This keeps the white container + date pill look)
          // We can use the DoctorDashboardTopHeader directly if the text inside
          // isn't hardcoded to "Dr.". If it is, we wrap DoctorDashboardHeader manually.
          const _TaHeaderWrapper(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // 2. Stats Grid (Labs, Grading, Forums)
              const TaStatsGrid(),

              SizedBox(height: AppSizes.largeSpacing),

              const TeachingToolsSection(isInstructor: false),

              SizedBox(height: 16.h),

              // Post Announcement Quick Action
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.manageAnnouncements);
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: ColorsManager.blue.withValues(alpha: 0.1)),
                      boxShadow: isLight
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: ColorsManager.blue.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.campaign_outlined, color: ColorsManager.blue, size: 24.sp),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Manage Announcements',
                                style: isLight
                                    ? AppLightTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)
                                    : AppDarkTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'View, edit, or broadcast updates',
                                style: isLight
                                    ? AppLightTextStyles.labelSmall.copyWith(color: ColorsManager.grayMedium)
                                    : AppDarkTextStyles.labelSmall.copyWith(color: ColorsManager.darkTextSecondary),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: ColorsManager.grayMedium, size: 16.sp),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40.h), // Bottom padding
            ],
          ),
        ],
      ),
    );
  }
}

// Local wrapper to replicate the visual style of DoctorDashboardTopHeader
// but allowing us to swap the inner content if needed.
class _TaHeaderWrapper extends StatelessWidget {
  const _TaHeaderWrapper();

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.h, // Add a bit of top padding since we don't have the fixed height centering anymore
        left: 24.w,
        right: 24.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        boxShadow: isLight
            ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reuse the internal content widget (Avatar + Name)
          // Ideally, this widget accepts a name parameter.
          // If not, creates a TaDashboardHeader similar to DoctorDashboardHeader.
          const DoctorDashboardHeader(),
          SizedBox(height: 16.h), // Bottom padding before the border radius cuts off
        ],
      ),
    );
  }
}