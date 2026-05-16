import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/assets_manager.dart';
import '../../../../../shared/resources/colors_manager.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';


class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: ColorsManager.blue,
            child: ClipOval(
              child: Image.asset(
                ImagesManager.profileImage,
                fit: BoxFit.cover,
                width: 48.w,
                height: 48.h,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person);
                },
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.welcomeBack,
                  style: isLight
                      ? AppLightTextStyles.labelMedium.copyWith(
                          color: ColorsManager.blue,
                        )
                      : AppDarkTextStyles.labelMedium.copyWith(
                          color: ColorsManager.blue,
                        ),
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthSuccess) {
                      return Text(
                        state.auth.firstName,
                        style: isLight
                            ? AppLightTextStyles.labelLarge
                            : AppDarkTextStyles.labelLarge,
                      );
                    }
                    return Text(
                      'Welcome',
                      style: isLight
                          ? AppLightTextStyles.labelLarge
                          : AppDarkTextStyles.labelLarge,
                    );
                  },
                ),
              ],
            ),
          ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.notifications);
              },
              child: const ImageIcon(AssetImage(IconsManager.notification)),
            ),
            SizedBox(width: 20.w),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.settings);
              },
              child: const Icon(Icons.settings),
            ),
          ],
        ),
      ],
    );
  }
}
