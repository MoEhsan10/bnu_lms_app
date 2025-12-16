import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/providers/theme_provider.dart';

class ForumQuestionCard extends StatelessWidget {
  final String authorName;
  final String authorRole;
  final String questionTitle;
  final String questionBody;
  final int votes;

  const ForumQuestionCard({
    required this.authorName,
    required this.authorRole,
    required this.questionTitle,
    required this.questionBody,
    required this.votes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: ColorsManager.blue,
                child: Text(
                  authorName[0].toUpperCase(),
                  style: TextStyle(
                    color: ColorsManager.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorName,
                      style: isLight
                          ? AppLightTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorsManager.black,
                      )
                          : AppDarkTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorsManager.darkTextPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      authorRole,
                      style: TextStyle(
                        fontSize: 12,
                        color: isLight
                            ? ColorsManager.grayMedium
                            : ColorsManager.darkTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            questionTitle,
            style: isLight
                ? AppLightTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorsManager.black,
              fontSize: 18,
            )
                : AppDarkTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorsManager.darkTextPrimary,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            questionBody,
            style: isLight
                ? AppLightTextStyles.bodyMedium.copyWith(
              color: ColorsManager.grayDark,
              height: 1.5,
            )
                : AppDarkTextStyles.bodyMedium.copyWith(
              color: ColorsManager.darkTextSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildVoteButton(Icons.arrow_upward, isLight),
              SizedBox(width: 12),
              Text(
                votes.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isLight
                      ? ColorsManager.black
                      : ColorsManager.darkTextPrimary,
                ),
              ),
              SizedBox(width: 12),
              _buildVoteButton(Icons.arrow_downward, isLight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoteButton(IconData icon, bool isLight) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isLight
            ? ColorsManager.lightBlueAccent
            : ColorsManager.darkBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        size: 18,
        color: isLight ? ColorsManager.grayDark : ColorsManager.darkTextSecondary,
      ),
    );
  }
}
