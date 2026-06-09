import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_grading_cubit.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';

class QuizQuestionsStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const QuizQuestionsStep({super.key, required this.onNext, required this.onBack});

  @override
  State<QuizQuestionsStep> createState() => _QuizQuestionsStepState();
}

class _QuizQuestionsStepState extends State<QuizQuestionsStep> {
  int _correctOptionIndex = 0;
  String _questionType = 'Multiple Choice';
  final TextEditingController _questionTextController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController(text: '1');
  final TextEditingController _timeLimitController = TextEditingController(text: '30');
  String? _imagePath;
  
  // Options controllers
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    _questionTextController.dispose();
    _pointsController.dispose();
    _timeLimitController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void _saveQuestion() {
    if (_questionTextController.text.trim().isEmpty) return;
    
    final cubit = context.read<QuizGradingCubit>();
    
    List<Map<String, dynamic>> options = [];
    if (_questionType != 'Open-ended / Essay') {
      for (int i = 0; i < _optionControllers.length; i++) {
        if (_optionControllers[i].text.trim().isNotEmpty) {
          options.add({
            'text': _optionControllers[i].text.trim(),
            'isCorrect': _correctOptionIndex == i,
          });
        }
      }
    }

    cubit.addQuestion({
      'text': _questionTextController.text.trim(),
      'type': _questionType,
      'points': int.tryParse(_pointsController.text) ?? 1,
      'timeLimit': int.tryParse(_timeLimitController.text) ?? 30,
      'isEssay': _questionType == 'Open-ended / Essay',
      'options': options,
      'imagePath': _imagePath,
    });

    // Clear form
    _questionTextController.clear();
    _imagePath = null;
    for (var controller in _optionControllers) {
      controller.clear();
    }
    setState(() {
      _correctOptionIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Question saved!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    // final surfaceColor = isLight ? ColorsManager.white : const Color(0xFF1A2A30);
    final inputFillColor = isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : const Color(0xFF131F24);

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question 1',
                style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF26C6DA).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _questionType,
                    icon: Icon(Icons.arrow_drop_down, color: const Color(0xFF26C6DA), size: 20.sp),
                    dropdownColor: isLight ? ColorsManager.white : const Color(0xFF1A2A30),
                    style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(
                      color: const Color(0xFF26C6DA),
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _questionType = newValue;
                        });
                      }
                    },
                    items: ['Multiple Choice', 'True/False', 'Open-ended / Essay']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Question Text Area
          TextField(
            controller: _questionTextController,
            maxLines: 4,
            style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Enter your question here...',
              hintStyle: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
              filled: true,
              fillColor: inputFillColor,
              contentPadding: EdgeInsets.all(16.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFF26C6DA), width: 1.5),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Media Upload
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: _imagePath != null ? 0 : 24.h),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: isLight ? ColorsManager.white : const Color(0xFF131F24),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ColorsManager.grayMedium.withValues(alpha: 0.5),
                  style: BorderStyle.solid, 
                ),
              ),
              child: _imagePath != null
                  ? Image.file(
                      File(_imagePath!),
                      width: double.infinity,
                      height: 150.h,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Column(
                        children: [
                          Icon(Icons.image_outlined, color: ColorsManager.grayMedium, size: 28.sp),
                          SizedBox(height: 8.h),
                          Text(
                            'Tap to add an image',
                            style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.grayMedium),
                          ),
                        ],
                      ),
                    ),
            ),
          ),

          SizedBox(height: 32.h),
          Row(
            children: [
              Expanded(child: _buildTextField(isLight, inputFillColor, 'Points', '10', controller: _pointsController)),
              SizedBox(width: 16.w),
              Expanded(child: _buildTextField(isLight, inputFillColor, 'Time Limit (Sec)', '30', controller: _timeLimitController)),
            ],
          ),

          SizedBox(height: 32.h),
          
          if (_questionType != 'Open-ended / Essay') ...[
            Text(
              'Answer Options',
              style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
            ),
            SizedBox(height: 16.h),

            // Options List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _optionControllers.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final letter = String.fromCharCode(65 + index); // A, B, C, D...
                return _buildOptionItem(isLight, inputFillColor, index, letter, 'Enter option text', controller: _optionControllers[index]);
              },
            ),
            if (_questionType == 'Multiple Choice') ...[
              SizedBox(height: 16.h),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _optionControllers.add(TextEditingController());
                  });
                },
                icon: Icon(Icons.add, color: const Color(0xFF26C6DA), size: 18.sp),
                label: Text(
                  'Add Option',
                  style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(
                    color: const Color(0xFF26C6DA),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ] else ...[
             // Essay placeholder
             Container(
               padding: EdgeInsets.all(16.w),
               decoration: BoxDecoration(
                 color: inputFillColor,
                 borderRadius: BorderRadius.circular(12.r),
                 border: Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.5)),
               ),
               child: Text(
                 'Students will be provided a rich text editor to write their essay response. This question will require manual grading.',
                 style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
               ),
             ),
          ],

          SizedBox(height: 48.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: widget.onBack,
                child: Text(
                  'Back',
                  style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.grayDark, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: _saveQuestion,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF26C6DA)),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: Text(
                      'Save Question',
                      style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: const Color(0xFF26C6DA), fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26C6DA),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Next',
                      style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(bool isLight, Color fillColor, String label, String hint, {TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
            filled: true,
            fillColor: fillColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF26C6DA), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionItem(bool isLight, Color fillColor, int index, String letter, String hint, {TextEditingController? controller}) {
    bool isSelected = _correctOptionIndex == index;
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF26C6DA) : fillColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                color: isSelected ? ColorsManager.white : (isLight ? ColorsManager.black : ColorsManager.white),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: TextField(
            controller: controller,
            style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
              filled: true,
              fillColor: fillColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFF26C6DA), width: 1.5),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Radio<int>(
          value: index,
          groupValue: _correctOptionIndex,
          activeColor: const Color(0xFF26C6DA),
          onChanged: (value) {
            setState(() {
              _correctOptionIndex = value!;
            });
          },
        ),
        if (_optionControllers.length > 2)
          IconButton(
            icon: Icon(Icons.delete_outline, color: ColorsManager.red, size: 20.sp),
            onPressed: () {
              setState(() {
                if (_correctOptionIndex == index) {
                  _correctOptionIndex = 0;
                } else if (_correctOptionIndex > index) {
                  _correctOptionIndex--;
                }
                _optionControllers[index].dispose();
                _optionControllers.removeAt(index);
              });
            },
          ),
      ],
    );
  }
}
