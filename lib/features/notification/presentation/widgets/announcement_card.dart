import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';

enum AnnouncementUrgency { info, reminder, urgent }

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String course;
  final String target;
  final String time;
  final int reachCount;
  final bool isPinned;
  final AnnouncementUrgency urgency;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onView;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.course,
    required this.target,
    required this.time,
    required this.reachCount,
    this.isPinned = false,
    this.urgency = AnnouncementUrgency.info,
    required this.onEdit,
    required this.onDelete,
    required this.onView,
  });

  Color _getUrgencyColor() {
    switch (urgency) {
      case AnnouncementUrgency.urgent:
        return ColorsManager.red;
      case AnnouncementUrgency.reminder:
        return Colors.orange;
      case AnnouncementUrgency.info:
      return ColorsManager.grayMedium;
    }
  }

  String _getUrgencyText() {
    switch (urgency) {
      case AnnouncementUrgency.urgent:
        return 'URGENT';
      case AnnouncementUrgency.reminder:
        return 'REMINDER';
      case AnnouncementUrgency.info:
      return 'INFO';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'To: $target',
                  style: TextStyle(
                    color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  if (isPinned) ...[
                    Icon(Icons.push_pin, size: 14.sp, color: ColorsManager.blue),
                    SizedBox(width: 4.w),
                  ],
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _getUrgencyColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      _getUrgencyText(),
                      style: TextStyle(
                        color: _getUrgencyColor(),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            course,
            style: TextStyle(
              color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Divider(color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF1F5F9)),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14.sp, color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium),
                  SizedBox(width: 4.w),
                  Text(
                    time,
                    style: TextStyle(
                      color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Icon(Icons.remove_red_eye_outlined, size: 14.sp, color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium),
                  SizedBox(width: 4.w),
                  Text(
                    '$reachCount Reached',
                    style: TextStyle(
                      color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onView,
                    child: Icon(Icons.open_in_new, size: 20.sp, color: ColorsManager.blue),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: onEdit,
                    child: Icon(Icons.edit_outlined, size: 20.sp, color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(Icons.delete_outline, size: 20.sp, color: ColorsManager.red),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
