import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';

import '../../data/models/notification_model.dart';
import '../widgets/notification_card.dart'; // To reuse NotificationType mapping or icons if needed

class NotificationDetailsScreen extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailsScreen({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    // Map notification type to icon and colors
    final typeEnum = NotificationType.values[notification.type];
    IconData iconData = Icons.notifications;
    Color iconColor = ColorsManager.blue;
    Color bgColor = const Color(0xFFEAF8FB);

    switch (typeEnum) {
      case NotificationType.announcement:
        iconData = Icons.campaign_outlined;
        iconColor = ColorsManager.blue;
        bgColor = const Color(0xFFEBF8FE);
        break;
      case NotificationType.quiz:
        iconData = Icons.quiz_outlined;
        iconColor = const Color(0xFF8B5CF6);
        bgColor = const Color(0xFFF3E8FF);
        break;
      case NotificationType.assignment:
        iconData = Icons.assignment_outlined;
        iconColor = const Color(0xFFF59E0B);
        bgColor = const Color(0xFFFEF3C7);
        break;
      case NotificationType.grade:
        iconData = Icons.star_border;
        iconColor = const Color(0xFF10B981);
        bgColor = const Color(0xFFD1FAE5);
        break;
      case NotificationType.forum:
        iconData = Icons.forum_outlined;
        iconColor = const Color(0xFFEC4899);
        bgColor = const Color(0xFFFCE7F3);
        break;
      case NotificationType.system:
        iconData = Icons.info_outline;
        iconColor = ColorsManager.grayMedium;
        bgColor = isLight ? const Color(0xFFF1F5F9) : ColorsManager.darkSurface;
        break;
    }

    final typeString = typeEnum.name.toUpperCase();

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFF8FAFC) : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isLight ? ColorsManager.black : ColorsManager.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notification',
          style: isLight 
            ? AppLightTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold)
            : AppDarkTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Container(
          decoration: BoxDecoration(
            color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: isLight
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 4))]
                : null,
            border: isLight ? null : Border.all(color: ColorsManager.darkBackground),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Circle
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isLight ? bgColor : bgColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: iconColor, size: 32.sp),
              ),
              SizedBox(height: 20.h),
              
              // Pill Category
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isLight ? bgColor : bgColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  typeString,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Title
              Text(
                notification.title,
                textAlign: TextAlign.center,
                style: isLight 
                    ? AppLightTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold)
                    : AppDarkTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),

              // Time Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time, size: 14.sp, color: ColorsManager.grayMedium),
                  SizedBox(width: 6.w),
                  Text(
                    DateFormat('MMM d, yyyy • h:mm a').format(notification.createdAt),
                    style: TextStyle(
                      color: ColorsManager.grayMedium,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              // Metadata (Sender & Course Placeholder)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isLight ? const Color(0xFFF8FAFC) : ColorsManager.darkBackground,
                  borderRadius: BorderRadius.circular(16.r),
                  border: isLight ? Border.all(color: const Color(0xFFE2E8F0)) : null,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 20.sp, color: ColorsManager.blue),
                        SizedBox(width: 12.w),
                        Text(
                          'Sender:',
                          style: TextStyle(
                            color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            notification.senderName ?? 'System',
                            style: TextStyle(
                              color: isLight ? ColorsManager.black : ColorsManager.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Icon(Icons.menu_book_outlined, size: 20.sp, color: const Color(0xFF8B5CF6)),
                        SizedBox(width: 12.w),
                        Text(
                          'Course:',
                          style: TextStyle(
                            color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            notification.courseName ?? 'General',
                            style: TextStyle(
                              color: isLight ? ColorsManager.black : ColorsManager.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Message Content
              if (notification.message.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: isLight ? const Color(0xFFF8FAFC) : ColorsManager.darkBackground,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        notification.message,
                        style: isLight 
                          ? AppLightTextStyles.bodyMedium.copyWith(height: 1.6, color: const Color(0xFF334155))
                          : AppDarkTextStyles.bodyMedium.copyWith(height: 1.6),
                      ),
                    ],
                  ),
                ),
              if (notification.message.isNotEmpty) SizedBox(height: 24.h),

              // Optionally Course/Instructor metadata could be fetched if linked,
              // for now we show a placeholder box that can be expanded later if the backend includes them
              // in the Notification model.
              
              if (!notification.isRead) ...[
                SizedBox(height: 24.h),
                Text(
                  'Mark as Read',
                  style: TextStyle(
                    color: ColorsManager.grayMedium,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
