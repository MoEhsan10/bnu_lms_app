import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/resources/app_text_styles.dart';
import '../../../../shared/resources/color_manager.dart';
import '../../domain/entities/assignment_entity.dart';

class AssignmentResultScreen extends StatelessWidget {
  final AssignmentEntity assignment;

  const AssignmentResultScreen({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        title: Text('Assignment Results', style: AppTextStyles.titleLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: ColorManager.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _GradeCircle(grade: assignment.grade ?? 0, maxPoints: assignment.maxPoints),
            SizedBox(height: 32.h),
            _FeedbackCard(feedback: assignment.feedback ?? "No feedback provided yet."),
            SizedBox(height: 24.h),
            const _OriginalityReport(percentage: 5), // Mock data
            SizedBox(height: 24.h),
            _SectionTitle(title: 'Mastery Progress'),
            SizedBox(height: 16.h),
            const _MasteryProgressBar(label: 'Understanding', value: 0.85, color: Colors.blue),
            SizedBox(height: 12.h),
            const _MasteryProgressBar(label: 'Execution', value: 0.95, color: Colors.green),
            SizedBox(height: 12.h),
            const _MasteryProgressBar(label: 'Originality', value: 0.90, color: Colors.orange),
          ],
        ),
      ),
    );
  }
}

class _GradeCircle extends StatelessWidget {
  final double grade;
  final double maxPoints;

  const _GradeCircle({required this.grade, required this.maxPoints});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150.w,
          height: 150.w,
          child: CircularProgressIndicator(
            value: grade / maxPoints,
            strokeWidth: 12.w,
            backgroundColor: ColorManager.primary.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(ColorManager.primary),
          ),
        ),
        Column(
          children: [
            Text(
              '${grade.toInt()}',
              style: AppTextStyles.titleLarge.copyWith(fontSize: 40.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              'Out of ${maxPoints.toInt()}',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final String feedback;

  const _FeedbackCard({required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ColorManager.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorManager.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.comment_outlined, color: ColorManager.primary, size: 20),
              SizedBox(width: 8.w),
              Text('Instructor Feedback', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            feedback,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _OriginalityReport extends StatelessWidget {
  final int percentage;

  const _OriginalityReport({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_outlined, color: Colors.green),
              SizedBox(width: 8.w),
              Text('Originality Report', style: AppTextStyles.labelMedium),
            ],
          ),
          Text(
            '$percentage% Similarity',
            style: AppTextStyles.labelMedium.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

class _MasteryProgressBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _MasteryProgressBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            Text('${(value * 100).toInt()}%', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8.h,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
