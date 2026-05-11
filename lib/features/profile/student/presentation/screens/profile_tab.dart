import 'package:bnu_lms_app/shared/resources/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../presentation/cubit/profile_cubit.dart';
import '../../../presentation/cubit/profile_state.dart';
import '../widget/profile_action_card.dart';
import '../widget/profile_header.dart';
import '../widget/profile_menu_section.dart';
import '../widget/profile_stats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../../../../../shared/routes_manager/routes.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
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
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            return SingleChildScrollView(
              child: Padding(
                padding: REdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeaderCard(
                      name: profile.fullName,
                      department: profile.faculty,
                      studentId: profile.id.length > 8 ? profile.id.substring(0, 8) : profile.id, 
                      year: profile.academicYear,
                      profileImage: ImagesManager.profileImage,
                    ),
                    SizedBox(height: 24.h),
                    const ProfileStatsGrid(), 
                    SizedBox(height: 24.h),
                    const PaymentCard(),
                    SizedBox(height: 16.h),
                    const AdvisingSessionCard(),
                    SizedBox(height: 24.h),
                    ProfileMenuSection(
                      title: localizations.account,
                      items: [
                        ProfileMenuItem(
                          icon: IconsManager.editProfile,
                          label: localizations.editProfile,
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: IconsManager.password,
                          label: localizations.changePassword,
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    ProfileMenuSection(
                      title: localizations.support,
                      items: [
                        ProfileMenuItem(
                          icon: IconsManager.helpCenter,
                          label: localizations.helpCenter,
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: IconsManager.contactSupport,
                          label: localizations.contactSupport,
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: IconsManager.warning, 
                          label: 'Log Out',
                          onTap: () async {
                            await context.read<AuthCubit>().logout();
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context, 
                                Routes.login, 
                                (route) => false,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}