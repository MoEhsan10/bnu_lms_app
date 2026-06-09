import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

import '../../../shared_widgets/course_header_card.dart';
import '../widgets/doctor_courses_details/about_course_section.dart';
import '../widgets/courses_details_tabs/course_assignments_tab.dart';
import '../widgets/courses_details_tabs/course_attendance_tab.dart';
import '../widgets/courses_details_tabs/course_grades_tab.dart';
import '../widgets/courses_details_tabs/course_materials_tab.dart';
import '../widgets/courses_details_tabs/course_quizzes_tab.dart';
import '../widgets/courses_details_tabs/course_students_tab.dart';
import '../widgets/doctor_courses_details/learning_outcomes_section.dart';
import '../widgets/doctor_courses_details/next_session_section.dart';
import '../widgets/doctor_courses_details/overview_stats_row.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../shared/di/injection.dart';
import '../../../cubit/course_details_cubit/course_details_cubit.dart';
import '../../../cubit/course_details_cubit/course_details_state.dart';
import 'package:bnu_lms_app/features/courses/domain/entities/course_entity.dart';
import '../../../../../quizzes/presentation/cubit/quiz_list_cubit.dart';

class DoctorCourseDetailsScreen extends StatelessWidget {
  final int courseId;
  final String courseTitle;

  const DoctorCourseDetailsScreen({
    required this.courseId,
    required this.courseTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return DefaultTabController(
      length: 7, // Updated to 7 to fit all your tabs
      child: Scaffold(
        backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isLight ? ColorsManager.black : ColorsManager.white,
              size: 20.sp,
            ),
          ),
          title: Text(
            'Course Details',
            style: isLight
                ? AppLightTextStyles.headlineLarge
                : AppDarkTextStyles.headlineLarge,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert_rounded,
                color: isLight ? ColorsManager.black : ColorsManager.white,
              ),
            ),
          ],
        ),
        body: BlocProvider(
          create: (context) => getIt<CourseDetailsCubit>()..fetchCourseDetails(courseId),
          child: BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
            builder: (context, state) {
              if (state is CourseDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CourseDetailsError) {
                return Center(child: Text(state.message, style: TextStyle(color: ColorsManager.red)));
              } else if (state is CourseDetailsLoaded || state is CourseActionLoading || state is CourseActionError) {
                
                CourseDetailEntity? course;
                if (state is CourseDetailsLoaded) course = state.course;
                if (state is CourseActionLoading) course = state.course;
                if (state is CourseActionError) course = state.course;

                if (course == null) return const SizedBox();

                return Column(
                  children: [
                    // 1. The Shared Header Banner
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: CourseHeaderCard(
                        title: course.title,
                        courseCode: 'CS302', // backend missing this, keeping placeholder
                        instructor: course.instructorName,
                        icon: Icons.data_object,
                      ),
                    ),

                    // 2. The Tab Bar
                    TabBar(
                      isScrollable: true,
                      indicatorColor: ColorsManager.blue,
                      labelColor: ColorsManager.blue,
                      unselectedLabelColor: ColorsManager.grayMedium,
                      labelStyle: AppLightTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700),
                      unselectedLabelStyle: AppLightTextStyles.titleMedium,
                      tabAlignment: TabAlignment.start,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Students'),
                        Tab(text: 'Assignments'),
                        Tab(text: 'Quizzes'),
                        Tab(text: 'Materials'),
                        Tab(text: 'Attendance'),
                        Tab(text: 'Grades'),
                      ],
                    ),

                    // 3. The Tab Content (Scrollable)
                    Expanded(
                      child: TabBarView(
                        children: [
                          // 1. Overview Tab Content
                          SingleChildScrollView(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const OverviewStatsRow(),
                                SizedBox(height: 24.h),
                                const AboutCourseSection(),
                                SizedBox(height: 24.h),
                                const LearningOutcomesSection(),
                                SizedBox(height: 24.h),
                                const NextSessionSection(),
                                SizedBox(height: 80.h), // Padding for FAB
                              ],
                            ),
                          ),

                          // 2. Students Tab
                          const CourseStudentsTab(),

                          // 3. Assignments Tab
                          CourseAssignmentsTab(courseId: course.id),

                          // 4. Quizzes Tab
                          BlocProvider(
                            create: (_) => getIt<QuizListCubit>()..loadQuizzes(course!.id),
                            child: CourseQuizzesTab(courseId: course.id),
                          ),

                          // 5. Materials Tab (Pass the course to this one so we can show modules)
                          const CourseMaterialsTab(),

                          // 6. Attendance Tab
                          CourseAttendanceTab(courseId: course.id),

                          // 7. Grades Tab
                          const CourseGradesTab(),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
        // Floating Action Button
      ),
    );
  }
}