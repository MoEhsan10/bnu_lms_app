import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';

class ProfileStatsGrid extends StatelessWidget {
  const ProfileStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatCard(label: 'GPA', value: '3.85'),
            StatCard(label: 'Credits', value: '92'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatCard(label: 'Attendance', value: '98%'),
            StatCard(label: 'Rank', value: '7th'),
          ],
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      alignment: Alignment.center,
      width: 150,
      height: 91,
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white :ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: isLight
                ? AppLightTextStyles.bodyMedium
                : AppDarkTextStyles.bodyMedium,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: isLight
                ? AppLightTextStyles.headlineLarge
                : AppDarkTextStyles.headlineLarge,
          ),
        ],
      ),
    );
  }
}