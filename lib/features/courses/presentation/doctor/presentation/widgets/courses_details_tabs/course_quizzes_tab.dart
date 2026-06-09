import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../quizzes/presentation/cubit/quiz_list_cubit.dart';
import '../../../../../../quizzes/presentation/student/widgets/student_quiz_card.dart';


class CourseQuizzesTab extends StatefulWidget {
  final int courseId;
  const CourseQuizzesTab({super.key, required this.courseId});

  @override
  State<CourseQuizzesTab> createState() => _CourseQuizzesTabState();
}

class _CourseQuizzesTabState extends State<CourseQuizzesTab> {
  @override
  @override
  void initState() {
    super.initState();
    context.read<QuizListCubit>().loadQuizzes(widget.courseId);
    context.read<QuizListCubit>().listenToRealTimeUpdates(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return BlocBuilder<QuizListCubit, QuizListState>(
      builder: (context, state) {
        if (state is QuizListLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF26C6DA)));
        } else if (state is QuizListError) {
          return Center(child: Text(state.message, style: const TextStyle(color: ColorsManager.red)));
        } else if (state is QuizListLoaded) {
          if (state.quizzes.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Text('No quizzes created yet.', style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active Assessments',
                      style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                ...state.quizzes.map((quiz) => StudentQuizCard(
                      quiz: quiz,
                      title: quiz.title,
                      courseTitle: quiz.description,
                      status: quiz.areGradesPublished ? 'PUBLISHED' : 'DRAFT',
                      date: "${quiz.startDate.day}/${quiz.startDate.month}/${quiz.startDate.year}",
                      duration: '${quiz.durationMinutes} Mins',
                      questionsCount: '${quiz.questionCount} Questions',
                      actionText: 'Manage Settings >',
                      isInstructor: true,
                    )),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }


}