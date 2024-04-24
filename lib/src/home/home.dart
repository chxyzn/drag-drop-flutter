import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/leaderboard/leaderboard_screen.dart';
import 'package:drag_drop/src/levels/level_start_screen.dart';
import 'package:drag_drop/src/settings/settings.dart';
import 'package:drag_drop/src/utils/CustomScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: CustomColor.white,
      body: [
        Container(
          margin: EdgeInsets.only(top: 30.h, bottom: 65.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  print('You tapped \"hints\"');
                },
                child: Image(
                  image: AssetImage(PngAssets.cicrcleHelp),
                  height: 24.h,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 20.h,
                    color: CustomColor.goldStarColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '15/24',
                    style: w700.size18.copyWith(
                      color: CustomColor.primaryColor,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsScreen()));
                },
                child: Image(
                  image: AssetImage(PngAssets.settingsLogo),
                  height: 24.h,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 32.h),
          child: Image.asset(
            PngAssets.gplanLogo,
            width: 90,
            height: 90,
          ),
        ),
        Container(
          child: Text('GPLAN',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 70.sp,
                  color: CustomColor.primaryColor,
                  height: 0.8.h)
              //w600.size70.copyWith(color: CustomColor.primaryColor),
              ),
        ),
        Text(
          'The Game',
          style: w600.size30.copyWith(color: CustomColor.primaryColor),
        ),
        SizedBox(
          height: 60.h,
        ),
        Text(
          '25 minutes away from\nDaily Rewards!',
          textAlign: TextAlign.center,
          style: w700.size18.copyWith(color: CustomColor.greenTextColor),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LevelStartScreen(
                  level: 9,
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(top: 10.h),
            decoration: BoxDecoration(
              color: CustomColor.primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.all(18.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jump Back In!',
                  textAlign: TextAlign.center,
                  style: w700.size16.copyWith(color: CustomColor.white),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: CustomColor.white,
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            print('You tapped \"All Levels\"');
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: CustomColor.darkerDarkBlack,
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.all(18.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Levels',
                  textAlign: TextAlign.center,
                  style: w700.size16.copyWith(color: CustomColor.white),
                ),
                Image.asset(
                  PngAssets.trophyLogo,
                  height: 24.h,
                )
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  print('You tapped \"My Rank: 6\"');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18.5.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CustomColor.darkerDarkBlack,
                      width: 1.h,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    color: CustomColor.white,
                  ),
                  child: Center(
                    child: Text(
                      'My Rank: 6',
                      textAlign: TextAlign.center,
                      style: w700.size16.copyWith(
                        color: CustomColor.darkerDarkBlack,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LeaderboardScreen()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18.5.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CustomColor.darkerDarkBlack,
                      width: 1.h,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    color: CustomColor.white,
                  ),
                  child: Center(
                    child: Text(
                      'Leaderboard',
                      textAlign: TextAlign.center,
                      style: w700.size16.copyWith(
                        color: CustomColor.darkerDarkBlack,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            print("You chose to \"Remove Ads!\"");
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: CustomColor.darkerDarkBlack,
                width: 1.h,
              ),
              borderRadius: BorderRadius.circular(8.r),
              color: CustomColor.white,
            ),
            padding: EdgeInsets.all(18.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Remove Ads',
                  textAlign: TextAlign.center,
                  style: w700.size16.copyWith(
                    color: CustomColor.darkerDarkBlack,
                  ),
                ),
                Image.asset(
                  PngAssets.adRemovalLogo,
                  height: 24.h,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
