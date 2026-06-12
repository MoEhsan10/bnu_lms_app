import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/routes_manager/routes.dart';

class StudentHeroCard extends StatelessWidget {
  const StudentHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    // var themeProvider = Provider.of<ThemeProvider>(context);
    // final isLight = themeProvider.isLightTheme();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2FBAD7), Color(0xFF0097A7)], // Cyan gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2FBAD7).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, color: Colors.white, size: 14.sp),
                SizedBox(width: 6.w),
                Text(
                  'STAY ON TRACK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Track Your\nDeadlines',
            style: AppDarkTextStyles.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Check your calendar for upcoming assignments and quizzes across all courses.',
            style: AppDarkTextStyles.bodyLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.calendar);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0097A7),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Open Calendar',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.arrow_forward, size: 16.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
