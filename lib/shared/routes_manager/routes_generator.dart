import 'package:bnu_lms_app/features/courses/presentation/ta/presentation/screens/ta_assignment_grade_screen.dart';
import 'package:bnu_lms_app/features/home/presentation/ta/presentation/screens/ta_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Use absolute imports consistently for a cleaner file header
import 'package:bnu_lms_app/shared/di/injection.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_list_cubit.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_taking_cubit.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_grading_cubit.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_results_cubit.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:bnu_lms_app/features/ai_chat/presentation/screens/ai_chat_screen.dart';
import 'package:bnu_lms_app/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:bnu_lms_app/features/auth/presentation/screens/login_screen.dart';
import 'package:bnu_lms_app/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:bnu_lms_app/features/courses/presentation/doctor/presentation/screens/doctor_courses_details_screen.dart';
import 'package:bnu_lms_app/features/courses/presentation/student/screens/courses_details_screen.dart';

import 'package:bnu_lms_app/features/gate/presentation/screens/gate_screen.dart';
import 'package:bnu_lms_app/features/grades/presentation/screens/grades_screen.dart';

import 'package:bnu_lms_app/features/notification/presentation/screens/notifications_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/screens/quiz_details_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/screens/quiz_questions_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/screens/student_quiz_dashboard_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/screens/quiz_creation_wizard_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/student/screens/quiz_intro_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/student/screens/active_quiz_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/student/screens/quiz_submit_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/student/screens/quiz_results_screen.dart';

import '../../features/courses/presentation/ta/presentation/screens/ta_course_details_screen.dart';
import '../../features/forums/presentation/doctor/presentation/screens/doctor_question_details_screen.dart';
import '../../features/forums/domain/entities/forum_entities.dart';
import '../../features/forums/presentation/student/presentation/screens/forums_details_screen.dart';
import '../../features/home/presentation/doctor/presentation/screens/doctor_home_screen.dart';
import '../../features/home/presentation/student/screen/home_screen.dart';
import '../../features/quizzes/domain/entities/quiz_entity.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

class RoutesGenerator {
  static Route<dynamic>? getRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // -------------------------
      // CORE ROUTES
      // -------------------------
      case Routes.main:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case Routes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.aiChat:
        return MaterialPageRoute(builder: (_) => const AiChatScreen());

      // -------------------------
      // CATEGORY ROUTES
      // -------------------------
      case Routes.calendar:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case Routes.quizzes:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizListCubit>(),
            child: const StudentQuizDashboardScreen(),
          ),
        );
      case Routes.grades:
        return MaterialPageRoute(builder: (_) => const GradesScreen());
      case Routes.attendance:
        return MaterialPageRoute(builder: (_) => const AttendanceScreen());
      case Routes.entrance:
        return MaterialPageRoute(builder: (_) => const GateScreen());
      case Routes.quizWizard:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizGradingCubit>(),
            child: const QuizCreationWizardScreen(),
          ),
        );

      // -------------------------
      // QUIZ ROUTES
      // -------------------------
      case Routes.quizDetails:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizGradingCubit>(),
            child: const QuizDetailsScreen(),
          ),
        );
      case Routes.quizQuestions:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizGradingCubit>(),
            child: const QuizQuestionsScreen(),
          ),
        );
      case Routes.quizResults:
        final resultsArgs = args as Map<String, dynamic>?;
        if (resultsArgs == null || !resultsArgs.containsKey('quiz')) return _unDefinedRoute();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizResultsCubit>(),
            child: QuizResultsScreen(quiz: resultsArgs['quiz'] as QuizEntity),
          ),
        );
      case Routes.studentQuizDashboard:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizListCubit>(),
            child: const StudentQuizDashboardScreen(),
          ),
        );
      case Routes.quizIntro:
        final quizArgs = args as Map<String, dynamic>?;
        if (quizArgs == null || !quizArgs.containsKey('quiz')) return _unDefinedRoute();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizTakingCubit>(),
            child: QuizIntroScreen(quiz: quizArgs['quiz'] as QuizEntity),
          ),
        );
      case Routes.activeQuiz:
        final activeArgs = settings.arguments as Map<String, dynamic>?;
        final int quizId = activeArgs?['quizId'] ?? 0;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizTakingCubit>(),
            child: ActiveQuizScreen(quizId: quizId),
          ),
        );
      case Routes.quizSubmit:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizTakingCubit>(),
            child: const QuizSubmitScreen(),
          ),
        );

      // -------------------------
      // FORUMS ROUTES
      // -------------------------
      case Routes.forumsDetails:
        final forumTitle = (args as Map<String, dynamic>?)?['forumTitle'] as String? ?? 'Forum Discussion';
        return MaterialPageRoute(
          builder: (_) => ForumsDetailsScreen(forumTitle: forumTitle),
        );

      // -------------------------
      // COURSE ROUTES
      // -------------------------
      case Routes.coursesDetails:
        final courseArgs = args as Map<String, dynamic>?;
        if (courseArgs == null || !courseArgs.containsKey('courseId')) return _unDefinedRoute();

        return MaterialPageRoute(
          builder: (_) => CourseDetailsScreen(
            courseId: courseArgs['courseId'] as int,
            courseTitle: courseArgs['courseTitle'] as String? ?? 'Unknown Course',
            instructor: courseArgs['instructor'] as String? ?? 'Unknown Instructor',
            courseCode: courseArgs['courseCode'] as String? ?? 'N/A',
            icon: courseArgs['icon'] as IconData? ?? Icons.computer,
          ),
        );

      // -------------------------
      // DOCTOR VIEW ROUTES
      // -------------------------
      case Routes.doctorDashboard:
        return MaterialPageRoute(builder: (_) => const DoctorHomeScreen());

      case Routes.doctorCoursesDetails:
        final doctorCourseArgs = args as Map<String, dynamic>?;
        if (doctorCourseArgs == null || !doctorCourseArgs.containsKey('courseId')) return _unDefinedRoute();
        return MaterialPageRoute(
          builder: (_) => DoctorCourseDetailsScreen(
            courseId: doctorCourseArgs['courseId'] as int,
            courseTitle: doctorCourseArgs['courseTitle'] as String? ?? 'Unknown Course',
          ),
        );

      case Routes.doctorQuestionDetails: 
        final questionArgs = args as Map<String, dynamic>?;
        if (questionArgs == null || !questionArgs.containsKey('discussion')) {
          return _unDefinedRoute();
        }

        return MaterialPageRoute(
          builder: (_) => DoctorQuestionDetailsScreen(
            discussion: questionArgs['discussion'] as DiscussionEntity,
          ),
        );

      // -------------------------
      // TA VIEW ROUTES
      // -------------------------
      case Routes.taDashboard:
        return MaterialPageRoute(builder: (_) => const TaHomeScreen());

      case Routes.taCoursesDetails:
        final taCourseArgs = args as Map<String, dynamic>?;
        if (taCourseArgs == null || !taCourseArgs.containsKey('courseId')) return _unDefinedRoute();
        return MaterialPageRoute(
          builder: (_) => TaCourseDetailsScreen(
            courseId: taCourseArgs['courseId'] as int,
            courseTitle: taCourseArgs['courseTitle'] as String? ?? 'Unknown Course',
          )
        );

      case Routes.taAssignmentGrades:
        return MaterialPageRoute(
          builder: (_) => const TaAssignmentGradeScreen(),
        );

      default:
        return _unDefinedRoute();
    }
  }

  static Route<dynamic> _unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('No Route Found')),
        body: const Center(child: Text('Route not found')),
      ),
    );
  }
}
