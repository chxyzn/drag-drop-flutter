import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/settings/settings.dart';
import 'package:drag_drop/src/utils/CustomAppBar.dart';
import 'package:drag_drop/src/utils/CustomScaffold.dart';
import 'package:drag_drop/src/utils/widgets/leaderboard_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/widgets/leaderboard_tile_widget.dart';

class LeaderboardScreen extends StatefulWidget {
  LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late ScrollController _scrollController;
  late int rank;
  // late List<String> dataList;

  @override
  void initState() {
    rank = 47;
    _scrollController = ScrollController(
      initialScrollOffset: _calculateInitialScrollOffset(),
    );
    super.initState();
  }

  double _calculateInitialScrollOffset() {
    // final itemHeight = 50.0; // Adjust this value based on your item height
    // final rankIndex = rank - 1;
    // final maxAboveItems = 5;
    // final maxBelowItems = 4;

    return 0.0;

    // if (rankIndex < maxAboveItems) {
    //   return 0.0;
    // } else if (rankIndex >= dataList.length - maxBelowItems) {
    //   return (dataList.length - maxBelowItems - maxAboveItems) * itemHeight;
    // } else {
    //   return (rankIndex - maxAboveItems) * itemHeight;
    // }
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
        Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: CustomColor.primaryColor,
                borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Rank',
                    style: w500.size16.colorWhite,
                  ),
                  Text(
                    rank.toString(),
                    style: w700.size24.colorWhite,
                  )
                ],
              ),
            )),
        SizedBox(
          height: 50,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            LeaderboardPlaceholder(
                height: 115,
                backgroundColor: CustomColor.primary60Color,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0)),
                profilePicHeight: 45,
                profilePicWidth: 45,
                topPadding: 7.0,
                profilePic:
                    'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500', // Replace with your profile image URL
                name: 'name',
                starCount: 24,
                rank: 3),
            LeaderboardPlaceholder(
                height: 180,
                backgroundColor: CustomColor.primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                profilePicHeight: 90,
                profilePicWidth: 90,
                topPadding: 20,
                bottomPadding: 7,
                profilePic:
                    'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500', // Replace with your profile image URL
                name: 'name',
                starCount: 24,
                rank: 1),
            LeaderboardPlaceholder(
                height: 140,
                backgroundColor: CustomColor.primary60Color,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0)),
                profilePicHeight: 60,
                profilePicWidth: 60,
                topPadding: 16.0,
                profilePic:
                    'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500', // Replace with your profile image URL
                name: 'name',
                starCount: 24,
                rank: 2)
          ],
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 350,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: 10,
            itemBuilder: (context, index) {
              return LeaderboardTileWidget(
                backgroundColor: CustomColor.primary60Color,
                textColor: CustomColor.primaryColor,
                name: 'name',
                starCount: 24,
                rank: 5,
              );
            },
          ),
        )
      ],
    );
  }
}
