import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String instructor;
  final String image;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    this.title = "Mobile App Development",
    this.instructor = "Dr. Ahmed Hassan",
    this.image = "https://via.placeholder.com/150",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// صورة الكورس
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                image,
                width: 70.w,
                height: 70.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 70.w,
                    height: 70.w,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.book,
                      size: 30.sp,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),

            SizedBox(width: 14.w),

            /// القسم الخاص بالنصوص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// عنوان الكورس
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  /// اسم الدكتور
                  Text(
                    instructor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            /// السهم
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: Colors.grey[600],
            )
          ],
        ),
      ),
    );
  }
}