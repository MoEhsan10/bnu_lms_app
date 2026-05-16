import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/colors_manager.dart';
import '../../domain/entities/calendar_event_entity.dart';

class EventCardWidget extends StatelessWidget {
  final CalendarEventEntity event;

  const EventCardWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final typeColor = _typeColor(event.eventType);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isLight ? 0.06 : 0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: title + type badge ────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: typeColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  event.eventType,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: typeColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          // ── Course title ───────────────────────────────────────────────────
          Text(
            event.courseTitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: ColorsManager.grayMedium,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // ── Description (only if non-empty) ────────────────────────────────
          if (event.description.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              event.description,
              style: TextStyle(
                fontSize: 11.sp,
                color: isLight ? ColorsManager.grayDark : ColorsManager.darkTextSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'Quiz':
        return ColorsManager.red;
      case 'Assignment':
        return ColorsManager.blue;
      case 'Lecture':
        return const Color(0xFF3B82F6); // distinct indigo-blue for Lecture
      default:
        return ColorsManager.green;
    }
  }
}
