import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String department;
  final String studentId;
  final int year;
  final String profileImage;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.department,
    required this.studentId,
    required this.year,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 320,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isLight ?  ColorsManager.white : ColorsManager.darkSurface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                backgroundImage: AssetImage(profileImage),
              ),
              const SizedBox(height: 10),
              Text(
                name,
                style: isLight
                    ? AppLightTextStyles.headlineLarge
                    : AppDarkTextStyles.headlineLarge,
              ),
              const SizedBox(height: 5),
              Text(
                department,
                style: isLight
                    ? AppLightTextStyles.bodyMedium
                    : AppDarkTextStyles.bodyMedium,
              ),
              const SizedBox(height: 5),
              Text(
                'ID: $studentId',
                style: isLight
                    ? AppLightTextStyles.bodyMedium
                    : AppDarkTextStyles.bodyMedium,
              ),
              const SizedBox(height: 5),
              Text(
                'Year: $year',
                style: isLight
                    ? AppLightTextStyles.bodyMedium
                    : AppDarkTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}