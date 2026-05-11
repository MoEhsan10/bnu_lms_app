import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/resources/app_text_styles.dart';
import '../../../../shared/resources/color_manager.dart';

class SubmissionSuccessScreen extends StatelessWidget {
  const SubmissionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            _SuccessIcon(),
            SizedBox(height: 32.h),
            Text(
              'Submission Successful!',
              style: AppTextStyles.titleLarge.copyWith(fontSize: 24.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Your assignment has been submitted successfully. You can view your submission status in the assignments tab.',
              style: AppTextStyles.bodyMedium.copyWith(color: ColorManager.textSecondary),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            _ReturnButton(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        color: ColorManager.success.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check_circle_outline,
        color: ColorManager.success,
        size: 80.sp,
      ),
    );
  }
}

class _ReturnButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Navigate back to Assignments tab (this might require a specific route or pop until)
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          elevation: 0,
        ),
        child: Text('Return to Assignments', style: AppTextStyles.buttonText),
      ),
    );
  }
}
