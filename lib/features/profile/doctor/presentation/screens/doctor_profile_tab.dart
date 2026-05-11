import 'package:bnu_lms_app/shared/resources/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';

// Import the extracted widgets
import '../widgets/doctor_profile_header.dart';
import '../widgets/contact_and_stats.dart';
import '../widgets/my_courses_section.dart';
import '../widgets/office_hours_card.dart';
import '../widgets/settings_section.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/cubit/profile_cubit.dart';
import '../../../presentation/cubit/profile_state.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../../../../../../shared/routes_manager/routes.dart';

class DoctorProfileTab extends StatefulWidget {
  const DoctorProfileTab({super.key});

  @override
  State<DoctorProfileTab> createState() => _DoctorProfileTabState();
}

class _DoctorProfileTabState extends State<DoctorProfileTab> {
  @override
  void initState() {
    super.initState();
    // Fetch profile once when the tab is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
        }
      },
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Center(
                child: Text(
                  'Profile',
                  style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
                ),
              ),
            ),
  
            SizedBox(height: AppSizes.largeSpacing.h),
  
            // 2. Body
            Expanded(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProfileError) {
                    return Center(child: Text(state.message));
                  } else if (state is ProfileLoaded) {
                    final profile = state.profile;
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
                      child: Column(
                        children: [
                          DoctorProfileHeader(
                            name: profile.fullName,
                            department: profile.faculty,
                          ),
                          SizedBox(height: 24.h),
                          const ContactAndStats(),
                          SizedBox(height: 32.h),
                          const MyCoursesSection(),
                          SizedBox(height: 24.h),
                          const OfficeHoursCard(),
                          SizedBox(height: 32.h),
                          const SettingsSection(),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}