import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
import 'package:drag_drop/src/constants/enums.dart';
import 'package:drag_drop/src/constants/help_widgets.dart';
import 'package:drag_drop/src/constants/instructions-screen.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/home/encrypted_storage_widget.dart';
import 'package:drag_drop/src/home/home_repo.dart';
import 'package:drag_drop/src/leaderboard/leaderboard_screen.dart';
import 'package:drag_drop/src/levels/level_start_screen.dart';
import 'package:drag_drop/src/levels/all_levels_screen.dart';
import 'package:drag_drop/src/settings/settings.dart';
import 'package:drag_drop/src/utils/CustomScaffold.dart';
import 'package:drag_drop/src/utils/encrypted_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  final bool openedFromLogin;
  const HomeScreen({
    super.key,
    this.openedFromLogin = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget StarsCountWidget(String stars) {
    return Text(
      stars,
      style: w700.size18.copyWith(
        color: CustomColor.primaryColor,
      ),
    );
  }

  Widget RankWidget(String rank) {
    return Center(
      child: Text(
        'My Rank: $rank',
        textAlign: TextAlign.center,
        style: w700.size16.copyWith(
          color: CustomColor.darkerDarkBlack,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: CustomColor.white,
      backgroundImage: DecorationImage(
        image: AssetImage(PngAssets.backgroundImageDots),
        fit: BoxFit.cover,
        opacity: 0.25,
      ),
      body: [
        Container(
          margin: EdgeInsets.only(top: 30.h, bottom: 65.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () async {
                  showDialog(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.3),
                      barrierDismissible: true,
                      builder: ((context) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 100.h, horizontal: 40.w),
                          child: GraphBoxHelp(),
                        );
                      }));
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
                  // Text(
                  //   '$GLOBAL_STARS',
                  //   style: w700.size18.copyWith(
                  //     color: CustomColor.primaryColor,
                  //   ),
                  // ),
                  EncryptedStorageWidget(
                    provider: starsHomeScreenProvider,
                    child: StarsCountWidget,
                    value: "stars",
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ),
                  );
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
          "",
          textAlign: TextAlign.center,
          style: w700.size18.copyWith(color: CustomColor.greenTextColor),
        ),
        GestureDetector(
          onTap: () async {
            String? recentLevel = await EncryptedStorage()
                .read(key: EncryptedStorageKey.recent.value);

            if (recentLevel != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LevelStartScreen(
                    level: int.parse(recentLevel),
                  ),
                ),
              );
              return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: CustomColor.primaryColor,
                content: Text(
                  'No recent level found!, Go to All levels to start playing!',
                  style: w700.size16.copyWith(color: CustomColor.white),
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
        Consumer(
          builder: (context, ref, child) {
            return GestureDetector(
              onTap: () {
                ref.invalidate(starsHomeScreenProvider);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AllLevelsScreen(),
                  ),
                );
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
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {},
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
                  child: EncryptedStorageWidget(
                    provider: myRankHomeScreenProvider,
                    child: RankWidget,
                    value: "rank",
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
          onTap: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InstructionsPage(),
              ),
            );
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
                  'Instructions',
                  textAlign: TextAlign.center,
                  style: w700.size16.copyWith(
                    color: CustomColor.darkerDarkBlack,
                  ),
                ),
                Icon(
                  (Icons.help_outline),
                  color: CustomColor.darkerDarkBlack,
                  size: 32.h,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
