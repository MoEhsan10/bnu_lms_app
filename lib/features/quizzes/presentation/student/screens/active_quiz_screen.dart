import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/quiz_taking_cubit.dart';

class ActiveQuizScreen extends StatefulWidget {
  final int quizId;
  const ActiveQuizScreen({super.key, required this.quizId});

  @override
  State<ActiveQuizScreen> createState() => _ActiveQuizScreenState();
}

class _ActiveQuizScreenState extends State<ActiveQuizScreen> {
  int _selectedOptionIndex = -1;
  final Map<int, int> _answers = {}; // Map of questionId to selectedOptionId
  final Map<int, String> _essayAnswers = {}; // Map of questionId to essay string
  
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _timerStarted = false;
  late TextEditingController _essayController;

  @override
  void initState() {
    super.initState();
    _essayController = TextEditingController();
    Future.microtask(() => context.read<QuizTakingCubit>().loadQuiz(widget.quizId));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _essayController.dispose();
    super.dispose();
  }

  void _startTimerIfNeeded(int durationMinutes) {
    if (!_timerStarted && durationMinutes > 0) {
      _timerStarted = true;
      _remainingSeconds = durationMinutes * 60;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() => _remainingSeconds--);
        } else {
          timer.cancel();
          _submitQuiz();
        }
      });
    }
  }

  String get _formattedTime {
    int m = _remainingSeconds ~/ 60;
    int s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _submitQuiz() {
    final cubit = context.read<QuizTakingCubit>();
    if (cubit.quizTakeEntity == null) return;
    
    // Save current essay text if on essay question
    final currentQ = cubit.quizTakeEntity!.questions[cubit.currentQuestionIndex];
    if (currentQ.isEssay) {
      _essayAnswers[currentQ.id] = _essayController.text;
    }

    final answersList = <Map<String, dynamic>>[];
    for (var q in cubit.quizTakeEntity!.questions) {
      if (q.isEssay) {
        if (_essayAnswers.containsKey(q.id)) {
           answersList.add({"questionId": q.id, "essayAnswer": _essayAnswers[q.id]});
        }
      } else {
        if (_answers.containsKey(q.id)) {
           answersList.add({"questionId": q.id, "selectedOptionId": _answers[q.id]});
        }
      }
    }

    cubit.submitQuiz(widget.quizId, {"answers": answersList});
    Navigator.pop(context); // Pop active quiz
    Navigator.pop(context); // Pop intro screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quiz submitted successfully!'), backgroundColor: Color(0xFF26C6DA)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final surfaceColor = isLight ? ColorsManager.white : const Color(0xFF1A2A30);

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: isLight ? ColorsManager.black : ColorsManager.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text('Quiz Session', style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(color: ColorsManager.grayMedium)),
            SizedBox(height: 2.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_outlined, color: ColorsManager.red, size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  _formattedTime,
                  style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(color: ColorsManager.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      body: BlocConsumer<QuizTakingCubit, QuizTakingState>(
        listener: (context, state) {
          if (state is QuizTakingLoaded) {
            _startTimerIfNeeded(state.quiz.durationMinutes);
          }
        },
        builder: (context, state) {
          final cubit = context.read<QuizTakingCubit>();
          
          if (state is QuizTakingInitial || state is QuizTakingSubmitting) {
             return const Center(child: CircularProgressIndicator(color: Color(0xFF26C6DA)));
          }

          if (state is QuizTakingError) {
             return Center(child: Text(state.message, style: TextStyle(color: ColorsManager.red)));
          }

          if (cubit.quizTakeEntity == null || cubit.quizTakeEntity!.questions.isEmpty) {
             return const Center(child: Text('No questions found.'));
          }

          final currentQ = cubit.quizTakeEntity!.questions[cubit.currentQuestionIndex];
          final options = currentQ.options;
          final points = currentQ.points;

          return Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (cubit.currentQuestionIndex + 1) / cubit.quizTakeEntity!.questions.length,
            backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF26C6DA)),
            minHeight: 4.h,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Section 1: General Knowledge',
                        style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.grayMedium, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF26C6DA).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          '$points Points',
                          style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(color: const Color(0xFF26C6DA), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Question ${cubit.currentQuestionIndex + 1} of ${cubit.quizTakeEntity!.questions.length}',
                    style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
                  ),
                  SizedBox(height: 24.h),

                  // Question Text
                  Text(
                    currentQ.text,
                    style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(height: 1.5),
                  ),
                  SizedBox(height: 32.h),

                  // Options or Essay
                  if (currentQ.isEssay)
                    TextField(
                      controller: _essayController,
                      maxLines: 8,
                      style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Type your answer here...',
                        hintStyle: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
                        filled: true,
                        fillColor: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : const Color(0xFF131F24),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                      ),
                      onChanged: (val) => _essayAnswers[currentQ.id] = val,
                    )
                  else
                    ...options.asMap().entries.map((entry) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _buildOptionCard(isLight, surfaceColor, entry.key, String.fromCharCode(65 + entry.key), entry.value.text, entry.value.id, currentQ.id),
                      );
                    }),

                  SizedBox(height: 48.h),
                  
                  // Bottom Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (cubit.currentQuestionIndex > 0)
                        TextButton.icon(
                          onPressed: () {
                            cubit.previousQuestion();
                            setState(() => _selectedOptionIndex = -1); // reset selection for simplicity
                          },
                          icon: Icon(Icons.arrow_back, color: ColorsManager.grayMedium, size: 16.sp),
                          label: Text(
                            'Previous',
                            style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.grayMedium),
                          ),
                        )
                      else
                        const SizedBox(),

                      ElevatedButton(
                        onPressed: () {
                          if (currentQ.isEssay) {
                            _essayAnswers[currentQ.id] = _essayController.text;
                          }

                          if (cubit.currentQuestionIndex < cubit.quizTakeEntity!.questions.length - 1) {
                            cubit.nextQuestion();
                            setState(() {
                              final nextQId = cubit.quizTakeEntity!.questions[cubit.currentQuestionIndex].id;
                              final nextQ = cubit.quizTakeEntity!.questions[cubit.currentQuestionIndex];
                              if (nextQ.isEssay) {
                                _essayController.text = _essayAnswers[nextQId] ?? '';
                              } else {
                                _selectedOptionIndex = nextQ.options.indexWhere((o) => o.id == _answers[nextQId]);
                              }
                            });
                          } else {
                            // End of quiz, submit!
                            _submitQuiz();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF26C6DA),
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          elevation: 0,
                        ),
                        child: Row(
                          children: [
                            Text(
                              cubit.currentQuestionIndex < cubit.quizTakeEntity!.questions.length - 1 ? 'Next Question' : 'Submit Quiz',
                              style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8.w),
                            Icon(cubit.currentQuestionIndex < cubit.quizTakeEntity!.questions.length - 1 ? Icons.arrow_forward : Icons.check, color: ColorsManager.white, size: 16.sp),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
          );
        },
      ),
    );
  }

  Widget _buildOptionCard(bool isLight, Color surfaceColor, int index, String letter, String text, int optionId, int questionId) {
    bool isSelected = _selectedOptionIndex == index;
    final activeColor = const Color(0xFF26C6DA);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOptionIndex = index;
          _answers[questionId] = optionId;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.05) : surfaceColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? activeColor : (isLight ? ColorsManager.grayMedium.withValues(alpha: 0.2) : ColorsManager.grayDark),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isLight && !isSelected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isSelected ? activeColor : (isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    color: isSelected ? ColorsManager.white : (isLight ? ColorsManager.grayDark : ColorsManager.grayMedium),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                text,
                style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? activeColor : ColorsManager.grayMedium,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
