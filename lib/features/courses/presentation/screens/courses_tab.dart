import 'package:bnu_lms_app/features/courses/presentation/widgets/course_card.dart';
import 'package:bnu_lms_app/l10n/app_localizations.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../shared/providers/theme_provider.dart';

class CoursesTab extends StatelessWidget {
  const CoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    final courses = [
      {
        'title': 'Advanced Programming',
        'instructor': 'Dr. Angela Yu',
        'category': 'Computer Science',
        'progress': 0.75,
        'categoryColor': const Color(0xFF5DADE2),
        'iconBgColor': isLight ? const Color(0xFFdbeafe) : const Color(0xFF223049),
        'icon': Icons.computer,
      },
      {
        'title': 'Data Structures & Algorithms',
        'instructor': 'Dr. Robert Martin',
        'category': 'Computer Science',
        'progress': 0.60,
        'categoryColor': const Color(0xFF5DADE2),
        'iconBgColor': isLight ? const Color(0xFFdbeafe) : const Color(0xFF223049),
        'icon': Icons.code,
      },
      {
        'title': 'Web Development',
        'instructor': 'Prof. Sarah Johnson',
        'category': 'Computer Science',
        'progress': 0.90,
        'categoryColor': const Color(0xFF5DADE2),
        'iconBgColor': isLight ? const Color(0xFFdbeafe) : const Color(0xFF223049),
        'icon': Icons.language,
      },
      {
        'title': 'Database Management Systems',
        'instructor': 'Dr. Michael Chen',
        'category': 'Computer Science',
        'progress': 0.45,
        'categoryColor': const Color(0xFF5DADE2),
        'iconBgColor': isLight ? const Color(0xFFdbeafe) : const Color(0xFF223049),
        'icon': Icons.storage,
      },
      {
        'title': 'Artificial Intelligence',
        'instructor': 'Prof. Emily Watson',
        'category': 'Computer Science',
        'progress': 0.30,
        'categoryColor': const Color(0xFF5DADE2),
        'iconBgColor': isLight ? const Color(0xFFdbeafe) : const Color(0xFF223049),
        'icon': Icons.psychology,
      },
      {
        'title': 'Mobile App Development',
        'instructor': 'Dr. Ahmed Hassan',
        'category': 'Computer Science',
        'progress': 0.85,
        'categoryColor': const Color(0xFF5DADE2),
        'iconBgColor': isLight ? const Color(0xFFdbeafe) : const Color(0xFF223049),
        'icon': Icons.phone_android,
      },
    ];

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: REdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.courses,
                  style: isLight
                      ? AppLightTextStyles.headlineLarge
                      : AppDarkTextStyles.headlineLarge,
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: Show semester picker
                  },
                  child: Container(
                    padding: REdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isLight ? Color(0xFFB8E9F5) : ColorsManager.darkSurface,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Fall 2024',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF00A3CC),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: const Color(0xFF00A3CC),
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Course List
          Expanded(
            child: ListView.builder(
              padding: REdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return CourseCard(
                  title: course['title'] as String,
                  instructor: course['instructor'] as String,
                  category: course['category'] as String,
                  progress: course['progress'] as double,
                  categoryColor: course['categoryColor'] as Color,
                  iconBgColor: course['iconBgColor'] as Color,
                  categoryIcon: course['icon'] as IconData,
                  onTap: () {
                    print("Course ${index + 1} tapped");
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}