import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../shared/resources/app_text_styles.dart';
import '../../../../shared/resources/color_manager.dart';
import '../../../../shared/di/injection.dart';
import '../../domain/entities/assignment_entity.dart';
import '../manager/submission/assignment_submission_cubit.dart';
import '../manager/submission/assignment_submission_state.dart';
import 'submission_success_screen.dart';

class SubmitAssignmentScreen extends StatefulWidget {
  final AssignmentEntity assignment;

  const SubmitAssignmentScreen({super.key, required this.assignment});

  @override
  State<SubmitAssignmentScreen> createState() => _SubmitAssignmentScreenState();
}

class _SubmitAssignmentScreenState extends State<SubmitAssignmentScreen> {
  String? _filePath;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AssignmentSubmissionCubit>(),
      child: BlocConsumer<AssignmentSubmissionCubit, AssignmentSubmissionState>(
        listener: (context, state) {
          state.maybeWhen(
            success: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SubmissionSuccessScreen()),
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
              title: Text('Submit Assignment', style: AppTextStyles.titleLarge),
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
                  _SectionTitle(title: 'Upload File'),
                  SizedBox(height: 12.h),
                  _FileUploadArea(
                    filePath: _filePath,
                    onTap: _pickFile,
                  ),
                  SizedBox(height: 24.h),
                  _SectionTitle(title: 'Assignment URL (Optional)'),
                  SizedBox(height: 12.h),
                  _CustomTextField(
                    controller: _urlController,
                    hintText: 'https://example.com/project',
                    maxLines: 1,
                  ),
                  SizedBox(height: 24.h),
                  _SectionTitle(title: 'Comments (Optional)'),
                  SizedBox(height: 12.h),
                  _CustomTextField(
                    controller: _commentController,
                    hintText: 'Enter your comments here...',
                    maxLines: 4,
                  ),
                  SizedBox(height: 40.h),
                  _SubmitButton(
                    isLoading: state.maybeWhen(loading: () => true, orElse: () => false),
                    onPressed: () {
                      context.read<AssignmentSubmissionCubit>().submitAssignment(
                        assignmentId: widget.assignment.id,
                        filePath: _filePath,
                        url: _urlController.text.isNotEmpty ? _urlController.text : null,
                        comment: _commentController.text.isNotEmpty ? _commentController.text : null,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.bold));
  }
}

class _FileUploadArea extends StatelessWidget {
  final String? filePath;
  final VoidCallback onTap;

  const _FileUploadArea({this.filePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: ColorManager.cardBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: ColorManager.primary.withValues(alpha: 0.3), style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(Icons.cloud_upload_outlined, color: ColorManager.primary, size: 40.sp),
            SizedBox(height: 12.h),
            Text(
              filePath != null ? filePath!.split('/').last : 'Tap to browse files',
              style: AppTextStyles.bodyMedium.copyWith(color: ColorManager.primary),
            ),
            if (filePath == null)
              Text(
                'Maximum file size: 50MB',
                style: AppTextStyles.bodySmall.copyWith(fontSize: 10.sp),
              ),
          ],
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const _CustomTextField({
    required this.controller,
    required this.hintText,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: ColorManager.textSecondary.withValues(alpha: 0.5)),
        filled: true,
        fillColor: ColorManager.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: ColorManager.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: ColorManager.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: ColorManager.primary),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SubmitButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text('Submit Now', style: AppTextStyles.buttonText),
      ),
    );
  }
}
