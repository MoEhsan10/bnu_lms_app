import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/resources/app_text_styles.dart';
import '../../../../shared/resources/color_manager.dart';
import '../../../../shared/di/injection.dart';
import '../manager/instructor/grading_cubit.dart';
import '../manager/instructor/grading_state.dart';

class GradingScreen extends StatefulWidget {
  final int submissionId;
  final String studentName;
  final DateTime submissionDate;

  const GradingScreen({
    super.key,
    required this.submissionId,
    required this.studentName,
    required this.submissionDate,
  });

  @override
  State<GradingScreen> createState() => _GradingScreenState();
}

class _GradingScreenState extends State<GradingScreen> {
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GradingCubit>(),
      child: BlocConsumer<GradingCubit, GradingState>(
        listener: (context, state) {
          state.maybeWhen(
            success: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Grade Submitted!'), backgroundColor: ColorManager.success),
              );
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: ColorManager.error),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ColorManager.background,
            appBar: AppBar(
              title: Text('Grade Submission', style: AppTextStyles.titleLarge),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStudentInfoCard(),
                  SizedBox(height: 24.h),
                  Text('Evaluation', style: AppTextStyles.titleMedium),
                  SizedBox(height: 16.h),
                  _buildGradeInput(),
                  SizedBox(height: 16.h),
                  _buildFeedbackInput(),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.maybeWhen(loading: () => null, orElse: () => () {
                        context.read<GradingCubit>().gradeSubmission(
                          submissionId: widget.submissionId,
                          grade: double.tryParse(_scoreController.text) ?? 0,
                          feedback: _feedbackController.text,
                        );
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: state.maybeWhen(
                        loading: () => const CircularProgressIndicator(color: Colors.white),
                        orElse: () => Text('Submit Final Grade', style: AppTextStyles.buttonText),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudentInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorManager.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Student: ${widget.studentName}', style: AppTextStyles.titleMedium),
          SizedBox(height: 8.h),
          Text(
            'Submitted: ${widget.submissionDate.day}/${widget.submissionDate.month}, ${widget.submissionDate.hour}:${widget.submissionDate.minute}',
            style: AppTextStyles.bodySmall,
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Download/View File Logic
            },
            icon: Icon(Icons.download, size: 18.sp),
            label: const Text('Download Submission File'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primary.withValues(alpha: 0.1),
              foregroundColor: ColorManager.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeInput() {
    return TextField(
      controller: _scoreController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Score (out of 20)',
        labelStyle: AppTextStyles.labelSmall,
        filled: true,
        fillColor: ColorManager.cardBackground,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildFeedbackInput() {
    return TextField(
      controller: _feedbackController,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'Instructor Feedback',
        labelStyle: AppTextStyles.labelSmall,
        alignLabelWithHint: true,
        filled: true,
        fillColor: ColorManager.cardBackground,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
      ),
    );
  }
}
