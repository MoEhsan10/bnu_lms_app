import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/colors_manager.dart';

class ForumAnswerCard extends StatelessWidget {
  final String authorName;
  final String timestamp;
  final String answerText;
  final int votes;
  final bool isTopRated;

  const ForumAnswerCard({
    required this.authorName,
    required this.timestamp,
    required this.answerText,
    required this.votes,
    this.isTopRated = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: isTopRated
            ? Border.all(
          color: ColorsManager.green,
          width: 1.5,
        )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: ColorsManager.grayMedium,
                child: Text(
                  authorName[0].toUpperCase(),
                  style: TextStyle(
                    color: ColorsManager.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
                      timestamp,
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
              if (isTopRated)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    color: ColorsManager.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: ColorsManager.white,
                    size: 16,
                  ),
                ),
              SizedBox(width: 12),
              Text(
                'Reply',
                style: TextStyle(
                  fontSize: 13,
                  color: ColorsManager.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            answerText,
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
          SizedBox(height: 12),
          Row(
            children: [
              _buildVoteButton(Icons.arrow_upward, isLight),
              SizedBox(width: 12),
              Text(
                votes.toString(),
                style: TextStyle(
                  fontSize: 16,
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
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isLight
            ? ColorsManager.lightBlueAccent
            : ColorsManager.darkBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        size: 16,
        color: isLight ? ColorsManager.grayDark : ColorsManager.darkTextSecondary,
      ),
    );
  }
}