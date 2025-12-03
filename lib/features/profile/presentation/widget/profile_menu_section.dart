import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';

class ProfileMenuItem {
  final String icon;
  final String label;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class ProfileMenuSection extends StatelessWidget {
  final String title;
  final List<ProfileMenuItem> items;

  const ProfileMenuSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 8),
            child: Text(
              title,
              style: isLight
                  ? AppLightTextStyles.labelLarge
                  : AppDarkTextStyles.labelLarge,
            ),
          ),
          Center(
            child: Container(
              width: 358,
              decoration: BoxDecoration(
                color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    if (i > 0) const SizedBox(),
                    MenuItemRow(item: items[i]),
                  ],
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItemRow extends StatelessWidget {
  final ProfileMenuItem item;

  const MenuItemRow({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              item.icon,
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 15),
            Text(
              item.label,
              style: isLight
                  ? AppLightTextStyles.labelMedium.copyWith(
                color: ColorsManager.black
              )
                  : AppDarkTextStyles.labelMedium.copyWith(
                color: ColorsManager.white
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}