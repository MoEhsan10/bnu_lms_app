import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../domain/entities/calendar_event_entity.dart';
import 'event_card_widget.dart';

class TimelineWidget extends StatelessWidget {
  final List<CalendarEventEntity> events;

  const TimelineWidget({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 56.sp,
              color: ColorsManager.grayMedium,
            ),
            SizedBox(height: 12.h),
            Text(
              'No events for this day',
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorsManager.grayMedium,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final isLast = index == events.length - 1;
        final nodeColor = _typeColor(event.eventType);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Timeline spine ───────────────────────────────────────────
              SizedBox(
                width: 28.w,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Continuous grey vertical line
                    if (!isLast)
                      Positioned.fill(
                        top: 10.h,
                        child: Center(
                          child: Container(
                            width: 2.w,
                            color: const Color(0xFFE5E7EB),
                          ),
                        ),
                      ),
                    // Colored dot overlaid on the line
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: nodeColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: nodeColor.withValues(alpha: 0.35),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              // ── Event card ───────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 14.h),
                  child: EventCardWidget(event: event),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'Quiz':
        return ColorsManager.red;
      case 'Assignment':
        return ColorsManager.blue;
      case 'Lecture':
        return const Color(0xFF3B82F6);
      default:
        return ColorsManager.green;
    }
  }
}
