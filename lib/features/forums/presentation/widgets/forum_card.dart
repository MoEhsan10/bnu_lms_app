import 'package:bnu_lms_app/features/forums/data/forums_data.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/providers/theme_provider.dart';

class ForumCard extends StatelessWidget {
  final ForumsData forum;

  const ForumCard({required this.forum, super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: AssetImage(forum.image), radius: 30),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  forum.title,
                  style: isLight
                      ? AppLightTextStyles.labelLarge.copyWith(
                          color: ColorsManager.black,
                        )
                      : AppDarkTextStyles.labelLarge.copyWith(
                    color: ColorsManager.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  forum.description,
                  style: isLight
                      ? AppLightTextStyles.labelMedium
                      : AppDarkTextStyles.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
