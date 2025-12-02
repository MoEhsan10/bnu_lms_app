import 'package:bnu_lms_app/features/courses/presentation/widgets/course_card.dart';
import 'package:bnu_lms_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class CoursesTab extends StatelessWidget {
  const CoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            localizations.courses,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            dividerColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            padding: REdgeInsets.symmetric(horizontal: 16),
            labelPadding: REdgeInsets.only(right: 12),
            indicator: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(24.r),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.blueGrey,
            labelStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(
                child: Container(
                  padding: REdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: const Text('All'),
                ),
              ),
              Tab(
                child: Container(
                  padding: REdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: const Text('Unread'),
                ),
              ),
              Tab(
                child: Container(
                  padding: REdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: const Text('Announcements'),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCourseList(),
            _buildCourseList(),
            _buildCourseList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseList() {
    return ListView.builder(
      padding: REdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return CourseCard(
          title: "Mobile App Development ${index + 1}",
          instructor: "Dr. Ahmed Hassan",
          image: "https://via.placeholder.com/150",
          onTap: () {
            print("Course ${index + 1} tapped");
          },
        );
      },
    );
  }
}