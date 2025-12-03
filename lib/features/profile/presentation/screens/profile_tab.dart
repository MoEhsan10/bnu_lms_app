import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.profile,
          style: isLight
              ? AppLightTextStyles.headlineLarge
              : AppDarkTextStyles.headlineLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 358,
                height: 300,
                decoration: BoxDecoration(
                  color: ColorsManager.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ColorsManager.white,
                    width: 2,
                  ),
                ),
                child: Column(

                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Amelia',
                      style: isLight
                          ? AppLightTextStyles.headlineLarge
                          : AppDarkTextStyles.headlineLarge,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Cs and engineering',
                      style: isLight
                          ? AppLightTextStyles.bodyMedium
                          : AppDarkTextStyles.bodyMedium,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'ID: 123456',
                      style: isLight
                          ? AppLightTextStyles.bodyMedium
                          : AppDarkTextStyles.bodyMedium,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Year: 3',
                      style: isLight
                          ? AppLightTextStyles.bodyMedium
                          : AppDarkTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),


         Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
             Container(
               alignment: Alignment.center,
                    width: 171,
                    height: 91,
                    decoration: BoxDecoration(
                      color: ColorsManager.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ColorsManager.white,
                        width: 2,
                      ),
                    ),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,

                 children: [

                   Text(
                     'GPA',
                     style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                   ),
                   SizedBox(height: 20),
                   Text(
                     '3.85',
                     style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.bodyMedium,
                   ),
                 ],
               ),
             ),
        Container(
          alignment: Alignment.center,
          width: 171,
          height: 91,
          decoration: BoxDecoration(
            color: ColorsManager.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ColorsManager.white,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [

              Text(
                'Credits',
                style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
              ),
              SizedBox(height: 20),
              Text(
                '92',
                style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
           ],
         ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 171,
                  height: 91,
                  decoration: BoxDecoration(
                    color: ColorsManager.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ColorsManager.white,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [

                      Text(
                        'Attendance',
                        style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                      ),
                      SizedBox(height: 20),
                      Text(
                        '98%',
                        style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 171,
                  height: 91,
                  decoration: BoxDecoration(
                    color: ColorsManager.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ColorsManager.white,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [

                      Text(
                        'Rank',
                        style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                      ),
                      SizedBox(height: 20),
                      Text(
                        '7th',
                        style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),


            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 171,
                  height: 152,
                  decoration: BoxDecoration(
                    color: ColorsManager.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ColorsManager.white,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [

                    Image.asset(
                    'assets/icons/Overlay.png',
                    width: 40,
                    height: 40,),
                      SizedBox(height: 20),
                      Text(
                        'View Transcript',
                        style: isLight ? AppLightTextStyles.labelMedium: AppDarkTextStyles.labelMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 171,
                  height: 152,
                  decoration: BoxDecoration(
                    color: ColorsManager.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ColorsManager.white,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [

                      Image.asset(
                        'assets/icons/progress.png',
                        width: 40,
                        height: 40,),
                      SizedBox(height: 20),
                      Text(
                        'Progress',
                        style: isLight ? AppLightTextStyles.labelMedium: AppDarkTextStyles.labelMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 171,
                  height: 152,
                  decoration: BoxDecoration(
                    color: ColorsManager.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ColorsManager.white,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [

                      Image.asset(
                        'assets/icons/Payments.png',
                        width: 40,
                        height: 40,),
                      SizedBox(height: 20),
                      Text(
                        'Tutition Payments',
                        style: isLight ? AppLightTextStyles.labelMedium: AppDarkTextStyles.labelMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 171,
                  height: 152,
                  decoration: BoxDecoration(
                    color: ColorsManager.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ColorsManager.white,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [

                      Image.asset(
                        'assets/icons/Certificates.png',
                        width: 40,
                        height: 40,),
                      SizedBox(height: 20),
                      Text(
                        'Certificates',
                        style: isLight ? AppLightTextStyles.labelMedium: AppDarkTextStyles.labelMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 171,
                  height: 152,
                  decoration: BoxDecoration(
                    color: ColorsManager.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ColorsManager.white,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [

                      Image.asset(
                        'assets/icons/attendance report.png',
                        width: 40,
                        height: 40,),
                      SizedBox(height: 20),
                      Text(
                        'Attendace Report',
                        style: isLight ? AppLightTextStyles.labelMedium: AppDarkTextStyles.labelMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 171,
                  height: 152,
                  decoration: BoxDecoration(
                    color: ColorsManager.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ColorsManager.white,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [

                      Image.asset(
                        'assets/icons/Sessions.png',
                        width: 40,
                        height: 40,),
                      SizedBox(height: 20),
                      Text(
                        'Advising Sessions',
                        style: isLight ? AppLightTextStyles.labelMedium: AppDarkTextStyles.labelMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text('Account',  style: isLight ? AppLightTextStyles.labelLarge: AppDarkTextStyles.labelLarge,),
                  Container(
                    alignment: Alignment.center,
                    width: 358,
                    decoration: BoxDecoration(
                      color: ColorsManager.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ColorsManager.white,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 15), // spacing from left edge
                            Image.asset(
                              'assets/icons/edit profile.png',
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(width: 15), // space between icon and text
                            Text(
                              'Edit Profile',
                              style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
                            ),
                            Spacer(), // يدفع السهم لليمين
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 15), // spacing from left edge
                            Image.asset(
                              'assets/icons/Change password2.png',
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(width: 15), // space between icon and text
                            Text(
                              'Change Password',
                              style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
                            ),
                            Spacer(), // يدفع السهم لليمين
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ],
                        ),

          ],
        ),
      ),
          ]
      )
    ),
            SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text('Support',  style: isLight ? AppLightTextStyles.labelLarge: AppDarkTextStyles.labelLarge,),
                      Container(
                        alignment: Alignment.center,
                        width: 358,
                        decoration: BoxDecoration(
                          color: ColorsManager.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: ColorsManager.white,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 15), // spacing from left edge
                                Image.asset(
                                  'assets/icons/help center.png',
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(width: 15), // space between icon and text
                                Text(
                                  'Help Center',
                                  style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
                                ),
                                Spacer(), // يدفع السهم لليمين
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 15), // spacing from left edge
                                Image.asset(
                                  'assets/icons/contact support.png',
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(width: 15), // space between icon and text
                                Text(
                                  'Contact Support',
                                  style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
                                ),
                                Spacer(), // يدفع السهم لليمين
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ]
                )
            ),
        SizedBox(height: 20,),
            ElevatedButton(onPressed: () {

            }, child:Text('log out')
            )
          ]
        ),
    )
    );
  }
}
