import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/home/home.dart';
import 'package:drag_drop/src/settings/settings.dart';
import 'package:drag_drop/src/utils/CustomAppBar.dart';
import 'package:drag_drop/src/utils/CustomScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllLevelsScreen extends StatefulWidget {
  final int totalNumberOfLevelsPlayed;
  final int currentNumberOfStars;

  const AllLevelsScreen({
    super.key,
    required this.totalNumberOfLevelsPlayed,
    required this.currentNumberOfStars,
  });

  @override
  State<AllLevelsScreen> createState() => _AllLevelsScreenState();
}

class _AllLevelsScreenState extends State<AllLevelsScreen> {
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
              builder: ((context) => HomeScreen(
                    totalNumberOfLevelsPlayed: widget.totalNumberOfLevelsPlayed,
                    currentNumberOfStars: widget.currentNumberOfStars,
                  )),
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
              Text(
                '${widget.currentNumberOfStars}/${widget.totalNumberOfLevelsPlayed * 3}',
                style: w700.size18.copyWith(
                  color: CustomColor.primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: 16.h,
            bottom: 10.h,
            left: 13.w,
            right: 13.w,
          ),
          decoration: BoxDecoration(
            color: CustomColor.primaryColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              Text(
                '2',
                style: w900.size24.copyWith(
                  color: CustomColor.white,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    size: 20.h,
                    color: CustomColor.goldStarColor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.6.h),
                    child: Icon(
                      Icons.star,
                      size: 20.h,
                      color: CustomColor.goldStarColor,
                    ),
                  ),
                  Icon(
                    Icons.star,
                    size: 20.h,
                    color: CustomColor.goldStarColor,
                  ),
                ],
              ),
            ],
          ),
        )
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
    return const Placeholder();
  }
}
