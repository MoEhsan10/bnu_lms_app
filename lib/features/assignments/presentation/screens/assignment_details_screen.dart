import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/resources/app_text_styles.dart';
import '../../../../shared/resources/color_manager.dart';
import '../../domain/entities/assignment_entity.dart';
import 'submit_assignment_screen.dart';

class AssignmentDetailsScreen extends StatelessWidget {
  final AssignmentEntity assignment;

  const AssignmentDetailsScreen({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        title: Text('Assignment Details', style: AppTextStyles.titleLarge),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorManager.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            SizedBox(height: 24.h),
            _buildSectionTitle('Instructions'),
            SizedBox(height: 12.h),
            _buildInstructionsSection(),
            SizedBox(height: 24.h),
            _buildSectionTitle('Reference Materials'),
            SizedBox(height: 12.h),
            _buildReferenceMaterialsSection(),
            SizedBox(height: 24.h),
            _buildSectionTitle('Submission Status'),
            SizedBox(height: 12.h),
            _buildSubmissionStatusSection(),
            SizedBox(height: 24.h),
            _buildSectionTitle('Instructor'),
            SizedBox(height: 12.h),
            _buildInstructorSection(),
            SizedBox(height: 24.h),
            _buildSectionTitle('Grading Rubric'),
            SizedBox(height: 12.h),
            _buildGradingRubricSection(),
            SizedBox(height: 40.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubmitAssignmentScreen(assignment: assignment)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text('Proceed to Submission', style: AppTextStyles.buttonText),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.titleMedium);
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: ColorManager.cardBackground, borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(assignment.title, style: AppTextStyles.titleLarge)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: (assignment.status.toLowerCase() == 'pending' ? Colors.orange : ColorManager.success).withValues(alpha: 0.1), 
                  borderRadius: BorderRadius.circular(8.r)
                ),
                child: Text(
                  assignment.status, 
                  style: AppTextStyles.labelSmall.copyWith(
                    color: assignment.status.toLowerCase() == 'pending' ? Colors.orange : ColorManager.success
                  )
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16.sp, color: ColorManager.textSecondary),
              SizedBox(width: 8.w),
              Text(
                'Due: ${assignment.dueDate.day}/${assignment.dueDate.month}, ${assignment.dueDate.hour}:${assignment.dueDate.minute}', 
                style: AppTextStyles.bodyMedium
              ),
              const Spacer(),
              Text('${assignment.maxPoints} Points', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: ColorManager.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.primary.withValues(alpha: 0.05),
        border: Border(left: BorderSide(color: ColorManager.primary, width: 4.w)),
      ),
      child: Text(
        assignment.description,
        style: AppTextStyles.bodyMedium,
      ),
    );
  }

  Widget _buildReferenceMaterialsSection() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      tileColor: ColorManager.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      leading: Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 30.sp),
      title: Text('Requirements_Doc.pdf', style: AppTextStyles.bodyMedium),
      subtitle: Text('2.4 MB', style: AppTextStyles.labelSmall),
      trailing: const Icon(Icons.download_rounded, color: ColorManager.primary),
      onTap: () {},
    );
  }

  Widget _buildSubmissionStatusSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatusCard('Attempts', '0 / 2', Icons.replay),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatusCard('Time Left', '3 Days', Icons.timer_outlined),
        ),
      ],
    );
  }

  Widget _buildStatusCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: ColorManager.cardBackground, borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: [
          Icon(icon, color: ColorManager.primary, size: 24.sp),
          SizedBox(height: 8.h),
          Text(title, style: AppTextStyles.labelSmall.copyWith(color: ColorManager.textSecondary)),
          SizedBox(height: 4.h),
          Text(value, style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }

  Widget _buildInstructorSection() {
    return ListTile(
      contentPadding: EdgeInsets.all(12.w),
      tileColor: ColorManager.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      leading: CircleAvatar(radius: 24.r, backgroundColor: ColorManager.primary.withValues(alpha: 0.2), child: const Icon(Icons.person, color: ColorManager.primary)),
      title: Text(assignment.instructorName ?? 'Dr. Mitchell', style: AppTextStyles.titleMedium),
      subtitle:  Text('Lead Instructor', style: AppTextStyles.labelSmall),
      trailing: IconButton(icon: const Icon(Icons.mail_outline, color: ColorManager.primary), onPressed: () {}),
    );
  }

  Widget _buildGradingRubricSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: ColorManager.cardBackground, borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: [
          _buildRubricRow('Code Quality', '10 pts'),
          SizedBox(height: 12.h),
          _buildRubricRow('Documentation', '5 pts'),
          SizedBox(height: 12.h),
          _buildRubricRow('Timely Submission', '5 pts'),
        ],
      ),
    );
  }

  Widget _buildRubricRow(String criteria, String points) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(criteria, style: AppTextStyles.bodyMedium),
        Text(points, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: ColorManager.primary)),
      ],
    );
  }
}
