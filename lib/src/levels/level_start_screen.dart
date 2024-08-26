import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/game/game_repo.dart';
import 'package:drag_drop/src/game/game_screen.dart';
import 'package:drag_drop/src/graph/graph_view.dart';
import 'package:drag_drop/src/home/encrypted_storage_widget.dart';
import 'package:drag_drop/src/home/home_repo.dart';
import 'package:drag_drop/src/levels/levels_repo.dart';
import 'package:drag_drop/src/settings/settings.dart';
import 'package:drag_drop/src/utils/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    super.initState();
  }

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Level ${widget.level}',
                style: w700.size48.copyWith(
                  color: CustomColor.primaryColor,
                  height: 48.sp / 58.h,
                ),
              ),
            ),
            FutureBuilder(
              future: getLevel(id: widget.level, context: context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text("Unknown Error Occured ${snapshot.error}");
                  }
                  if (snapshot.data != null && snapshot.hasData) {
                    return LevelStartScreenWidget(
                      level: widget.level,
                      nodeMap: snapshot.data!.$1,
                      nodes: snapshot.data!.$2,
                      edges: snapshot.data!.$3,
                      rowSize: snapshot.data!.$4,
                      colSize: snapshot.data!.$5,
                      hint: snapshot.data!.$6,
                      BestComletitionTime: snapshot.data!.$7,
                    );
                  }
                }
                return CircularProgressIndicator();
              },
            ),
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

class LevelStartScreenWidget extends StatelessWidget {
  final int level;
  final int rowSize;
  final int colSize;
  final String hint;
  final String BestComletitionTime;
  final List<int> nodes;
  final List<List<int>> edges;
  final List<Map<String, dynamic>> nodeMap;
  const LevelStartScreenWidget({
    super.key,
    required this.level,
    required this.rowSize,
    required this.colSize,
    required this.hint,
    required this.BestComletitionTime,
    required this.nodes,
    required this.nodeMap,
    required this.edges,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            nodes: nodes,
            edges: edges,
          ),
        ),
        SizedBox(
          height: 40.h,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Consumer(
              builder: (context, ref, child) {
                return GestureDetector(
                  onTap: () async {
                    ref.read(timeProvider.notifier).update((time) {
                      return 120;
                    });
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) {
                          return GameScreen(
                            level: level,
                            gridRowSize: rowSize,
                            gridColumnSize: colSize,
                            questionNodes: nodes,
                            nodes: nodeMap,
                            questionEdges: edges,
                            hint: hint,
                          );
                        }),
                      ),
                    );

                    if (result != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result.toString(),
                            style:
                                w700.size16.copyWith(color: CustomColor.white),
                          ),
                        ),
                      );
                    }
                  },
                  child: CustomButton(
                    width: 342.w,
                    color: CustomColor.primaryColor,
                    textColor: CustomColor.white,
                    svgPath: SvgAssets.startNowIcon,
                    primaryText: 'Start Now!',
                    borderColor: CustomColor.primaryColor,
                  ),
                );
              },
            ),
            CustomButton(
              width: 342.w,
              color: CustomColor.backgrondBlue,
              textColor: CustomColor.primaryColor,
              primaryText: 'Best Time',
              borderColor: CustomColor.primaryColor,
              secondaryText:
                  BestComletitionTime.isEmpty ? '-' : BestComletitionTime,
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
    );
  }
}
