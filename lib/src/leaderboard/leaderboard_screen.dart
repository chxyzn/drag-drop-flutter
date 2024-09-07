import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/leaderboard/leaderboard_repo.dart';
import 'package:drag_drop/src/settings/settings.dart';
import 'package:drag_drop/src/utils/CustomAppBar.dart';
import 'package:drag_drop/src/utils/CustomScaffold.dart';
import 'package:drag_drop/src/utils/widgets/custom_loading.dart';
import 'package:drag_drop/src/utils/widgets/leaderboard_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/widgets/leaderboard_tile_widget.dart';

class LeaderboardScreen extends StatefulWidget {
  LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController(
      initialScrollOffset: _calculateInitialScrollOffset(),
    );
    super.initState();
  }

  double _calculateInitialScrollOffset() {
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: CustomColor.white,
      appBar: CustomAppBar(
        title: 'Leaderboard',
        leadingIconName: SvgAssets.homeIcon,
        trailingIconName: SvgAssets.settingsIcon,
        onLeadingPressed: () {
          Navigator.of(context).pop();
        },
        onTrailingPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SettingsScreen()));
        },
      ),
      body: [
        FutureBuilder(
          future: getLeaderboard(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data != null) {
                return Column(
                  children: [
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: CustomColor.primaryColor,
                          borderRadius: BorderRadius.circular(8.0.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 15.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your Rank',
                                style: w500.size16.colorWhite,
                              ),
                              Text(
                                snapshot.data!.$2.toString(),
                                style: w700.size24.colorWhite,
                              )
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 50.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        snapshot.data!.$1.length <= 2
                            ? SizedBox()
                            : LeaderboardPlaceholder(
                                height: 115.h,
                                backgroundColor: CustomColor.primary60Color,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.r),
                                  bottomLeft: Radius.circular(20.r),
                                ),
                                profilePicHeight: 45.h,
                                profilePicWidth: 45.w,
                                topPadding: 7.0.h,
                                profilePic:
                                    'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                                name: snapshot.data!.$1[2].name,
                                starCount: snapshot.data!.$1[2].score,
                                rank: 3,
                              ),
                        LeaderboardPlaceholder(
                          height: 180.h,
                          backgroundColor: CustomColor.primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                          profilePicHeight: 90.h,
                          profilePicWidth: 90.w,
                          topPadding: 20.h,
                          bottomPadding: 7.h,
                          profilePic:
                              'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                          name: snapshot.data!.$1[0].name,
                          starCount: snapshot.data!.$1[0].score,
                          rank: 1,
                        ),
                        snapshot.data!.$1.length <= 1
                            ? SizedBox()
                            : LeaderboardPlaceholder(
                                height: 140.h,
                                backgroundColor: CustomColor.primary60Color,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.r),
                                  bottomRight: Radius.circular(20.r),
                                ),
                                profilePicHeight: 60.h,
                                profilePicWidth: 60.w,
                                topPadding: 16.h,
                                profilePic:
                                    'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                                name: snapshot.data!.$1[1].name,
                                starCount: snapshot.data!.$1[1].score,
                                rank: 2,
                              )
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    snapshot.data!.$1.length < 3
                        ? SizedBox()
                        : SizedBox(
                            height: 350.h,
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: snapshot.data!.$1.length - 3,
                              itemBuilder: (context, index) {
                                return LeaderboardTileWidget(
                                  backgroundColor: CustomColor.primary60Color,
                                  textColor: CustomColor.primaryColor,
                                  name: snapshot.data!.$1[index + 3].name,
                                  starCount: snapshot.data!.$1[index + 3].score,
                                  rank: index + 4,
                                );
                              },
                            ),
                          )
                  ],
                );
              }
            }
            if (snapshot.hasError) {
              return SingleChildScrollView(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: Expanded(
                    child: Text('An error occurred ${snapshot.error}'),
                  ),
                ),
              );
            }
            return Center(
              child: CustomLoadingIndicator(),
            );
          },
        ),
        // Container(
        //     width: double.infinity,
        //     decoration: BoxDecoration(
        //         color: CustomColor.primaryColor,
        //         borderRadius: BorderRadius.circular(8.0)),
        //     child: Padding(
        //       padding:
        //           const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Text(
        //             'Your Rank',
        //             style: w500.size16.colorWhite,
        //           ),
        //           Text(
        //             rank.toString(),
        //             style: w700.size24.colorWhite,
        //           )
        //         ],
        //       ),
        //     )),
        // SizedBox(
        //   height: 50,
        // ),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   children: [
        //     LeaderboardPlaceholder(
        //         height: 115,
        //         backgroundColor: CustomColor.primary60Color,
        //         borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20.0),
        //             bottomLeft: Radius.circular(20.0)),
        //         profilePicHeight: 45,
        //         profilePicWidth: 45,
        //         topPadding: 7.0,
        //         profilePic:
        //             'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500', // Replace with your profile image URL
        //         name: 'name',
        //         starCount: 24,
        //         rank: 3),
        //     LeaderboardPlaceholder(
        //         height: 180,
        //         backgroundColor: CustomColor.primaryColor,
        //         borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20.0),
        //             topRight: Radius.circular(20.0)),
        //         profilePicHeight: 90,
        //         profilePicWidth: 90,
        //         topPadding: 20,
        //         bottomPadding: 7,
        //         profilePic:
        //             'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500', // Replace with your profile image URL
        //         name: 'name',
        //         starCount: 24,
        //         rank: 1),
        //     LeaderboardPlaceholder(
        //         height: 140,
        //         backgroundColor: CustomColor.primary60Color,
        //         borderRadius: BorderRadius.only(
        //             topRight: Radius.circular(20.0),
        //             bottomRight: Radius.circular(20.0)),
        //         profilePicHeight: 60,
        //         profilePicWidth: 60,
        //         topPadding: 16.0,
        //         profilePic:
        //             'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500', // Replace with your profile image URL
        //         name: 'name',
        //         starCount: 24,
        //         rank: 2)
        //   ],
        // ),
        // SizedBox(
        //   height: 20,
        // ),
        // SizedBox(
        //   height: 350,
        //   child: ListView.builder(
        //     controller: _scrollController,
        //     itemCount: 10,
        //     itemBuilder: (context, index) {
        //       return LeaderboardTileWidget(
        //         backgroundColor: CustomColor.primary60Color,
        //         textColor: CustomColor.primaryColor,
        //         name: 'name',
        //         starCount: 24,
        //         rank: 5,
        //       );
        //     },
        //   ),
        // )
      ],
    );
  }
}
