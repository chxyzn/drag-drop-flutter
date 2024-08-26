import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/home/encrypted_storage_widget.dart';
import 'package:drag_drop/src/home/home.dart';
import 'package:drag_drop/src/home/home_repo.dart';
import 'package:drag_drop/src/levels/level_start_screen.dart';
import 'package:drag_drop/src/levels/levels_repo.dart';
import 'package:drag_drop/src/settings/settings.dart';
import 'package:drag_drop/src/utils/CustomAppBar.dart';
import 'package:drag_drop/src/utils/CustomScaffold.dart';
import 'package:drag_drop/src/utils/encrypted_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllLevelsScreen extends StatefulWidget {
  const AllLevelsScreen({
    super.key,
  });

  @override
  State<AllLevelsScreen> createState() => _AllLevelsScreenState();
}

class _AllLevelsScreenState extends State<AllLevelsScreen> {
  Map<int, int> levelsVSstars = {
    1: 2,
    2: 2,
    3: 1,
    4: 1,
    5: 0,
    6: 3,
    7: 0,
    8: 2,
    9: 3,
    10: 1,
    11: 1,
    12: 1,
    13: 0,
    14: 3,
    15: 2,
    16: 1,
    17: 2,
    18: 1,
    19: 0,
    20: 2,
    21: 0,
    22: 3,
    23: 2,
    24: 0,
    25: 2,
    26: 1,
    27: 2,
    28: 1,
    29: 0,
    30: 2,
    31: 2,
    32: 3,
    33: 0,
    34: 1
  };

  Widget StarsCountWidget(String stars) {
    return Text(
      stars,
      style: w700.size18.copyWith(
        color: CustomColor.primaryColor,
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
      appBar: CustomAppBar(
        title: "All Levels",
        leadingIconName: SvgAssets.homeIcon,
        trailingIconName: SvgAssets.settingsIcon,
        onLeadingPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: ((context) => HomeScreen()),
            ),
          );
        },
        onTrailingPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => SettingsScreen()),
            ),
          );
        },
      ),
      body: [
        FutureBuilder(
          future: getAllLevels(context),
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data?.$3 != "") {
              return Text(
                  "Error Occured with Status code ${snapshot.data?.$2} \nDescription: ${snapshot.data?.$3}");
            }
            if (snapshot.hasData && snapshot.data != null) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10.h, bottom: 30.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: 20.h,
                          color: CustomColor.goldStarColor,
                        ),
                        SizedBox(width: 08.w),
                        // Text(
                        //   '$GLOBAL_STARS',
                        //   style: w700.size24.copyWith(
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
                  ),
                  SizedBox(
                    height: 620.h,
                    child: GridView.builder(
                        itemCount: snapshot.data?.$1.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return LevelGridTile(
                            level: index + 1,
                            stars: snapshot.data?.$1[index].stars ?? 0,
                            isLocked: !((snapshot.data?.$1[index].isCompleted ??
                                    false) ||
                                (snapshot.data?.$1[index].isNext ?? false)),
                            isNext: snapshot.data?.$1[index].isNext ?? false,
                          );
                        }),
                  )
                ],
              );
            }

            return Center(
              child: CircularProgressIndicator(
                color: CustomColor.primaryColor,
              ),
            );
          },
        ),
        // Container(
        //   margin: EdgeInsets.only(top: 10.h, bottom: 30.h),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Icon(
        //         Icons.star,
        //         size: 20.h,
        //         color: CustomColor.goldStarColor,
        //       ),
        //       SizedBox(width: 08.w),
        //       Text(
        //         '${widget.currentNumberOfStars}/${(widget.lastLevelCompleted) * 3}',
        //         style: w700.size24.copyWith(
        //           color: CustomColor.primaryColor,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(
        //   height: 620.h,
        //   child: GridView.builder(
        //       itemCount: widget.totalNumberOfLevels,
        //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 4, // number of items in each row
        //       ),
        //       physics: BouncingScrollPhysics(),
        //       itemBuilder: (context, index) {
        //         return LevelGridTile(
        //           level: index + 1,
        //           stars: levelsVSstars.values.elementAt(index),
        //           isLocked: index > widget.lastLevelCompleted,
        //           isNext: index == widget.lastLevelCompleted,
        //         );
        //       }),
        // )
      ],
    );
  }
}

class LevelGridTile extends StatelessWidget {
  final int level;
  final int stars;
  final bool isLocked;
  final bool isNext;
  const LevelGridTile({
    super.key,
    required this.level,
    required this.stars,
    required this.isLocked,
    required this.isNext,
  });

  @override
  Widget build(BuildContext context) {
    return !isLocked
        ? GestureDetector(
            onTap: () async {
              await EncryptedStorage()
                  .write(key: "recent", value: level.toString());
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LevelStartScreen(
                    level: level,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
              width: 75.w,
              height: 75.h,
              padding: EdgeInsets.only(
                top: 9.h,
                bottom: 01.h,
                left: 5.w,
                right: 5.w,
              ),
              decoration: BoxDecoration(
                color: CustomColor.primaryColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  Text(
                    level.toString(),
                    style: w900.size24.copyWith(
                      color: CustomColor.white,
                    ),
                  ),
                  SizedBox(height: isNext ? 6.h : 3.h),
                  isNext
                      ? Text(
                          'Up Next',
                          style: w600.size12.copyWith(
                            color: CustomColor.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              size: 20.h,
                              color: stars >= 1
                                  ? CustomColor.goldStarColor
                                  : CustomColor.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.6.h),
                              child: Icon(
                                Icons.star,
                                size: 20.h,
                                color: stars >= 2
                                    ? CustomColor.goldStarColor
                                    : CustomColor.white,
                              ),
                            ),
                            Icon(
                              Icons.star,
                              size: 20.h,
                              color: stars == 3
                                  ? CustomColor.goldStarColor
                                  : CustomColor.white,
                            ),
                          ],
                        ),
                ],
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
            width: 75.w,
            height: 75.h,
            decoration: BoxDecoration(
              color: CustomColor.imgBgColorGrey,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              size: 48.h,
              color: CustomColor.white,
              weight: 2.h,
            ),
          );
  }
}
