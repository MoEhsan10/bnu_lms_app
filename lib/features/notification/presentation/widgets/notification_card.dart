import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';

enum NotificationType { announcement, quiz, assignment, grade, forum, system }

class NotificationCard extends StatelessWidget {
  final NotificationType type;
  final String title;
  final String body;
  final String time;
  final bool isUnread;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.isUnread = false,
    this.onTap,
  });

  IconData _getIcon() {
    switch (type) {
      case NotificationType.grade:        return Icons.star_border;
      case NotificationType.assignment:   return Icons.error_outline;
      case NotificationType.announcement: return Icons.campaign_outlined;
      case NotificationType.quiz:         return Icons.help_outline;
      case NotificationType.forum:        return Icons.forum_outlined;
      case NotificationType.system:       return Icons.settings_outlined;
    }
  }

  Color _getIconColor(bool isDark) {
    if (type == NotificationType.grade)      return ColorsManager.blue;
    if (type == NotificationType.assignment) return ColorsManager.red;
    return isDark ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium;
  }

  Color _getIconBgColor(bool isDark) {
    if (isDark) return ColorsManager.darkBackground;
    return ColorsManager.white;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkTheme();

    final Color cardBgColor = isUnread
        ? (isDarkMode ? const Color(0xFF0C242A) : const Color(0xFFEAF8FB))
        : (isDarkMode ? ColorsManager.darkSurface : ColorsManager.white);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF1F5F9),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: _getIconBgColor(isDarkMode),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                _getIcon(),
                color: _getIconColor(isDarkMode),
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                              color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                              fontSize: 12.sp,
                            ),
                          ),
                          if (isUnread) ...[
                            SizedBox(width: 4.w),
                            Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                color: type == NotificationType.assignment
                                    ? ColorsManager.red
                                    : ColorsManager.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    body,
                    style: TextStyle(
                      color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark,
                      fontSize: 13.sp,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
