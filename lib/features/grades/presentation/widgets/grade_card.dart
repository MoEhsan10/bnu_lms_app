import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradeScore {
  final String label;
  final int earnedPoints;
  final int totalPoints;

  const GradeScore({
    required this.label,
    required this.earnedPoints,
    required this.totalPoints,
  });

  int get percentage => totalPoints > 0
      ? ((earnedPoints / totalPoints) * 100).round()
      : 0;
}

class GradeCard extends StatelessWidget {
  final bool isLight;
  final String courseCode;
  final String courseTitle;
  final String instructor;
  final String gradeLetter;
  final Color gradeColor;
  final List<GradeScore> scores;
  final Color borderColor;

  const GradeCard({
    super.key,
    required this.isLight,
    required this.courseCode,
    required this.courseTitle,
    required this.instructor,
    required this.gradeLetter,
    required this.gradeColor,
    required this.scores,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      margin: REdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: 4.w,
          ),
        ),
      ),
      child: Padding(
        padding: REdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildInstructor(),
            SizedBox(height: 20.h),
            ...scores.map((score) => _buildScoreRow(score)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$courseCode: $courseTitle',
                style: isLight
                    ? AppLightTextStyles.headlineSmall
                    : AppDarkTextStyles.headlineSmall,
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          gradeLetter,
          style: TextStyle(
            color: gradeColor,
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructor() {
    return Text(
      instructor,
      style: isLight
          ? AppLightTextStyles.bodySmall
          : AppDarkTextStyles.bodySmall
    );
  }

  Widget _buildScoreRow(GradeScore score) {
    return Padding(
      padding: REdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                score.label,
                style: isLight
                    ? AppLightTextStyles.bodyMedium
                    : AppDarkTextStyles.bodyMedium,
              ),
              Text(
                '${score.percentage}%',
                style: isLight
                    ? AppLightTextStyles.bodyMedium
                    : AppDarkTextStyles.bodyMedium,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Stack(
            children: [
              // Background bar
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: isLight
                      ? Colors.grey.shade700
                      : Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              // Progress bar
              FractionallySizedBox(
                widthFactor: score.percentage / 100,
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: gradeColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}