import 'package:flutter/material.dart';
import '../widget/profile_header.dart';
import '../widget/profile_menu_section.dart';
import '../widget/profile_section.dart';
import '../widget/profile_stats.dart';


class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeaderCard(
              name: 'Amelia',
              department: 'CS and Engineering',
              studentId: '123456',
              year: 3,
              profileImage: 'assets/profile.jpg',
            ),
            const SizedBox(height: 20),
            const ProfileStatsGrid(),
            const SizedBox(height: 20),
            const ProfileActionButtons(),
            const SizedBox(height: 20),
            ProfileMenuSection(
              title: 'Account',
              items: [
                ProfileMenuItem(
                  icon: 'assets/icons/edit_profile.png',
                  label: 'Edit Profile',
                  onTap: () {
                    // Navigate to edit profile
                  },
                ),
                ProfileMenuItem(
                  icon: 'assets/icons/password.png',
                  label: 'Change Password',
                  onTap: () {
                    // Navigate to change password
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ProfileMenuSection(
              title: 'Support',
              items: [
                ProfileMenuItem(
                  icon: 'assets/icons/help_center.png',
                  label: 'Help Center',
                  onTap: () {
                    // Navigate to help center
                  },
                ),
                ProfileMenuItem(
                  icon: 'assets/icons/contact_support.png',
                  label: 'Contact Support',
                  onTap: () {
                    // Navigate to contact support
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}