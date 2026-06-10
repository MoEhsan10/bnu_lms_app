import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../assignments/presentation/tabs/student_assignments_tab.dart';
import '../widgets/courses_details/course_description_section.dart';
import '../../shared_widgets/course_header_card.dart';
import '../widgets/courses_details/upcoming_event_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/di/injection.dart';
import '../../shared_widgets/role_based_grade_navigation_button.dart';
import '../../cubit/course_details_cubit/course_details_cubit.dart';
import '../../cubit/course_details_cubit/course_details_state.dart';
import 'package:bnu_lms_app/features/courses/domain/entities/course_entity.dart';



class CourseDetailsScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;
  final String instructor;
  final String courseCode;
  final IconData icon;

  const CourseDetailsScreen({
    required this.courseId,
    required this.courseTitle,
    required this.instructor,
    this.courseCode = 'SWE-301',
    this.icon = Icons.computer,
    super.key,
  });

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Static data for demonstration
  final String courseDescription =
      'This course covers advanced concepts in software engineering, focusing on design patterns, agile methodologies, and large-scale system architecture. Students will gain hands-on experience through a semester-long project.';

  final List<String> learningOutcomes = [
    'Analyze complex software requirements.',
    'Apply various design patterns to solve problems.',
    'Implement and test large-scale software systems.',
  ];


  final List<Map<String, dynamic>> upcomingEvents = [
    {
      'title': 'Midterm Exam Schedule',
      'description':
      'The midterm exam has been scheduled for Nov 15th. Please check the \'Assignments\' tab for more details.',
      'date': 'Nov 1, 2023',
      'icon': Icons.event_note,
    },
    {
      'title': 'Project Proposal Submissions',
      'description':
      'The deadline for project proposal submission is approaching. Please submit your documents before Oct 28th.',
      'date': 'Oct 22, 2023',
      'icon': Icons.assignment_turned_in,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      backgroundColor: isLight
          ? ColorsManager.lightBackground
          : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Course Details',
          style: isLight
              ? AppLightTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          )
              : AppDarkTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => getIt<CourseDetailsCubit>()..fetchCourseDetails(widget.courseId),
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
                  CourseHeaderCard(
                    title: course.title,
                    instructor: course.instructorName,
                    courseCode: widget.courseCode,
                    icon: widget.icon,
                  ),
                  RoleBasedGradeNavigationButton(
                    courseId: widget.courseId,
                    courseTitle: course.title,
                  ),
                  _buildTabBar(isLight),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOverviewTab(isLight, course),
                        StudentAssignmentsTab(courseId: course.id),
                        _buildUpcomingTab(isLight), // TODO: replace with real API later
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
    );
  }

  Widget _buildTabBar(bool isLight) {
    return Container(
      color: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      child: TabBar(
        controller: _tabController,
        labelColor: ColorsManager.blue,
        dividerColor: Colors.transparent,
        unselectedLabelColor: isLight
            ? ColorsManager.grayMedium
            : ColorsManager.darkTextSecondary,
        indicatorColor: ColorsManager.blue,
        indicatorWeight: 2,
        labelStyle: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Assignments'),
          Tab(text: 'Upcoming'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(bool isLight, CourseDetailEntity course) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          CourseDescriptionSection(description: course.description.isEmpty ? courseDescription : course.description),
          SizedBox(height: 32.h),
          
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Modules',
              style: isLight
                  ? AppLightTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold)
                  : AppDarkTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16.h),
          
          if (course.modules.isEmpty)
             Padding(
              padding: REdgeInsets.symmetric(horizontal: 16),
              child: Text('No modules available yet.', style: TextStyle(color: ColorsManager.grayDark)),
            ),

          ...course.modules.map((module) => ExpansionTile(
                title: Text(module.title, style: TextStyle(fontWeight: FontWeight.w600)),
                children: module.lessons.map((lesson) => ListTile(
                      title: Text(lesson.title),
                      leading: Icon(Icons.play_circle_outline, color: ColorsManager.blue),
                      subtitle: Text('${lesson.contents.length} attachments'),
                    )).toList(),
              )),
              
          SizedBox(height: 24.h),
        ],
      ),
    );
  }


  Widget _buildUpcomingTab(bool isLight) {
    return SingleChildScrollView(
      child: Padding(
        padding: REdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Text(
              'Recent Announcements',
              style: isLight
                  ? AppLightTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              )
                  : AppDarkTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            ...upcomingEvents.map((event) {
              return UpcomingEventCard(
                title: event['title'],
                date: event['date'],
                description: event['description'],
                icon: event['icon'],
              );
            }),
          ],
        ),
      ),
    );
  }
}
