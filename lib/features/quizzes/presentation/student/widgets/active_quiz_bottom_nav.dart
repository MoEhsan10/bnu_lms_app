import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';

class ActiveQuizBottomNav extends StatelessWidget {
  const ActiveQuizBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final surfaceColor = isLight ? ColorsManager.white : ColorsManager.darkSurface;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(top: BorderSide(color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.2) : ColorsManager.grayDark)),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))]
            : [],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(isLight, Icons.grid_view_rounded, 'Questions', isActive: true),
            _buildNavItem(isLight, Icons.library_books_outlined, 'Resources'),
            _buildNavItem(isLight, Icons.bookmark_border_rounded, 'Bookmarks'),
            _buildSubmitItem(context, isLight),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(bool isLight, IconData icon, String label, {bool isActive = false}) {
    final color = isActive ? const Color(0xFF26C6DA) : ColorsManager.grayMedium;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24.sp),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10.sp,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitItem(BuildContext context, bool isLight) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.quizSubmit);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: ColorsManager.blueGray.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.check_circle_outline, color: ColorsManager.blueGray, size: 20.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            'Submit',
            style: TextStyle(
              color: ColorsManager.blueGray,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
