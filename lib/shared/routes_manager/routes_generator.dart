import 'package:bnu_lms_app/features/ai_chat/presentation/screens/ai_chat_screen.dart';
import 'package:bnu_lms_app/features/gate/presentation/screens/gate_screen.dart';
import 'package:bnu_lms_app/features/grades/presentation/screens/grade_screen.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screen/home_screen.dart';
import '../../features/notification/presentation/screens/notifications_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';

// Category screens
import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/quizzes/presentation/screens/quizzes_screen.dart';
import '../../features/attendance/presentation/screens/attendance_screen.dart';

class RoutesGenerator {
  static Route<dynamic>? getRoute(RouteSettings settings) {
    switch (settings.name) {

      case Routes.main:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );

      case Routes.settings:
        return MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        );

      case Routes.notifications:
        return MaterialPageRoute(
          builder: (context) => const NotificationsScreen(),
        );

      case Routes.login:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );

      case Routes.aiChat:
        return MaterialPageRoute(
          builder: (context) => const AiChatScreen(),
        );

    // -------------------------
    //   CATEGORY ROUTES
    // -------------------------

      // case Routes.courses:
      //   return MaterialPageRoute(
      //     builder: (context) => const CoursesScreen(),
      //   );

      case Routes.calendar:
        return MaterialPageRoute(
          builder: (context) => const CalendarScreen(),
        );

      case Routes.quizzes:
        return MaterialPageRoute(
          builder: (context) => const QuizzesScreen(),
        );

      case Routes.grades:
        return MaterialPageRoute(
          builder: (context) => const GradesScreen(),
        );

      case Routes.attendance:
        return MaterialPageRoute(
          builder: (context) => const AttendanceScreen(),
        );

      case Routes.entrance:
        return MaterialPageRoute(
          builder: (context) => const GateScreen(),
        );

      default:
        return _unDefinedRoute();
    }
  }

  static Route<dynamic> _unDefinedRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('No Route Found'),
        ),
        body: const Center(
          child: Text('No Route Found'),
        ),
      ),
    );
  }
}
