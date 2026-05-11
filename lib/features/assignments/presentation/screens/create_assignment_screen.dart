import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/resources/app_text_styles.dart';
import '../../../../shared/resources/color_manager.dart';
import '../../../../shared/di/injection.dart';
import '../manager/instructor/assignments_cubit.dart';
import '../manager/instructor/assignments_state.dart';

class CreateAssignmentScreen extends StatefulWidget {
  final int courseId;

  const CreateAssignmentScreen({super.key, required this.courseId});

  @override
  State<CreateAssignmentScreen> createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AssignmentsCubit>(),
      child: BlocConsumer<AssignmentsCubit, AssignmentsState>(
        listener: (context, state) {
          state.maybeWhen(
            created: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Assignment Published!'), backgroundColor: ColorManager.success),
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
              title: Text('New Assignment', style: AppTextStyles.titleLarge),
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
                  _buildInputField(
                    label: 'Assignment Title',
                    hint: 'e.g., Midterm Project',
                    controller: _titleController,
                  ),
                  SizedBox(height: 16.h),
                  _buildInputField(
                    label: 'Description / Instructions',
                    hint: 'Enter details...',
                    maxLines: 4,
                    controller: _descController,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: 'Points',
                          hint: 'e.g., 20',
                          controller: _pointsController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildInputField(
                          label: 'Due Date',
                          hint: _selectedDate == null ? 'Select Date' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          isDate: true,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (date != null) {
                              setState(() {
                                _selectedDate = date;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Text('Attach Files (Optional)', style: AppTextStyles.titleMedium),
                  SizedBox(height: 12.h),
                  _buildAttachArea(),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.maybeWhen(loading: () => null, orElse: () => () {
                        context.read<AssignmentsCubit>().createAssignment(
                          courseId: widget.courseId,
                          title: _titleController.text,
                          description: _descController.text,
                          points: double.tryParse(_pointsController.text) ?? 0,
                          dueDate: _selectedDate ?? DateTime.now(),
                        );
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: state.maybeWhen(
                        loading: () => const CircularProgressIndicator(color: Colors.white),
                        orElse: () => Text('Publish Assignment', style: AppTextStyles.buttonText),
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

  Widget _buildInputField({
    required String label,
    required String hint,
    int maxLines = 1,
    bool isDate = false,
    TextEditingController? controller,
    TextInputType? keyboardType,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSmall),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: isDate,
          onTap: onTap,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: ColorManager.textSecondary.withValues(alpha: 0.5)),
            filled: true,
            fillColor: ColorManager.cardBackground,
            suffixIcon: isDate ? Icon(Icons.calendar_today, color: ColorManager.primary, size: 20.sp) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachArea() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: ColorManager.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorManager.primary.withValues(alpha: 0.3), style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(Icons.attach_file, color: ColorManager.primary, size: 32.sp),
          SizedBox(height: 8.h),
          Text('Tap to browse files', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
