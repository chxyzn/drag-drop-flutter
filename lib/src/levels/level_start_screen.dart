import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
import 'package:drag_drop/src/constants/levels.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/game/game_screen.dart';
import 'package:drag_drop/src/graph/graph_view.dart';
import 'package:drag_drop/src/settings/settings.dart';
import 'package:drag_drop/src/utils/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LevelStartScreen extends StatefulWidget {
  final int level;
  const LevelStartScreen({
    super.key,
    required this.level,
  });

  @override
  State<LevelStartScreen> createState() => _LevelStartScreenState();
}

class _LevelStartScreenState extends State<LevelStartScreen> {
  List<int> questionNodes = [];
  List<List<int>> questionEdges = [];

  @override
  void initState() {
    List apiNodes = levels[widget.level - 1]['graph']['nodes'];
    for (var element in apiNodes) {
      questionNodes.add(element['id']);
    }

    List apiEdges = levels[widget.level - 1]['graph']['edges'];
    for (var element in apiEdges) {
      questionEdges.add(element);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          isTitleString: false,
          titleWidget: Row(
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
          leadingIconName: SvgAssets.homeIcon,
          trailingIconName: SvgAssets.settingsIcon,
          onLeadingPressed: () {
            Navigator.of(context).pop();
          },
          onTrailingPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Text(
              'Level ${widget.level}',
              style: w700.size48.copyWith(
                color: CustomColor.primaryColor,
                height: 48.sp / 58.h,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 347.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    PngAssets.graphBackgrond,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: GraphWidget(
                nodes: questionNodes,
                edges: questionEdges,
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) {
                          return GameScreen(
                            level: widget.level,
                            apiResonse: levels[widget.level - 1],
                          );
                        }),
                      ),
                    );
                  },
                  child: CustomButton(
                    width: 342.w,
                    color: CustomColor.primaryColor,
                    textColor: CustomColor.white,
                    svgPath: SvgAssets.startNowIcon,
                    primaryText: 'Start Now!',
                    borderColor: CustomColor.primaryColor,
                  ),
                ),
                CustomButton(
                  width: 342.w,
                  color: CustomColor.backgrondBlue,
                  textColor: CustomColor.primaryColor,
                  primaryText: 'Best Time',
                  borderColor: CustomColor.primaryColor,
                  secondaryText: '05:00',
                ),
                CustomButton(
                  width: 342.w,
                  color: Colors.white,
                  textColor: Colors.black,
                  primaryText: 'Remove Ads',
                  borderColor: Colors.black,
                  svgPath: SvgAssets.removeAdsIcon,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// give either svgPath or secondaryText
class CustomButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final Color borderColor;
  final String? svgPath;
  final String primaryText;
  final String? secondaryText;
  final double width;
  const CustomButton({
    super.key,
    this.svgPath,
    this.secondaryText,
    required this.color,
    required this.width,
    required this.textColor,
    required this.primaryText,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: borderColor,
          width: 1.w,
        ),
      ),
      padding: EdgeInsets.all(18.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            primaryText,
            textAlign: TextAlign.center,
            style: w700.size16.copyWith(color: textColor),
          ),
          (svgPath == null && secondaryText != null)
              ? Text(
                  secondaryText ?? '',
                  textAlign: TextAlign.center,
                  style: w700.size16.copyWith(color: textColor),
                )
              : SvgPicture.asset(
                  svgPath ?? '',
                  height: 24.h,
                  width: 24.w,
                  fit: BoxFit.cover,
                )
        ],
      ),
    );
  }
}
