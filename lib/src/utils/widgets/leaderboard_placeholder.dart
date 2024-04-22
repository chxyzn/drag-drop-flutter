import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/Colors.dart';
import '../../constants/textstyles.dart';

class LeaderboardPlaceholder extends StatelessWidget {
  final double height;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final double profilePicHeight;
  final double profilePicWidth;
  final String profilePic;
  final String name;
  final int starCount;
  final int rank;
  final double topPadding;
  final double? bottomPadding;

  const LeaderboardPlaceholder({
    required this.height,
    required this.backgroundColor,
    required this.borderRadius,
    required this.profilePicHeight,
    required this.profilePicWidth,
    required this.profilePic,
    required this.name,
    required this.starCount,
    required this.rank,
    required this.topPadding,
    this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: height,
            decoration:
                BoxDecoration(color: backgroundColor, borderRadius: borderRadius
                    // BorderRadius.only(
                    //     topLeft: Radius.circular(20.0),
                    //     bottomLeft: Radius.circular(20.0))
                    ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: topPadding, bottom: bottomPadding ?? 0.0),
                  child: Container(
                    width: profilePicWidth, // Adjust width as needed
                    height: profilePicHeight, // Adjust height as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Circular shape
                      color: Colors
                          .grey[300], // Background color for the container
                    ),
                    child: ClipOval(
                      child: Image.network(
                        profilePic,
                        fit: BoxFit.cover, // Cover the entire container
                      ),
                    ),
                  ),
                ),
                Text(
                  name,
                  style: w500.size18.colorWhite,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        size: 20.h,
                        color: CustomColor.goldStarColor,
                      ),
                      // Image.asset(
                      //   PngAssets.starIcon,
                      //   height: 20,
                      //   width: 20,
                      // ),
                      Text(
                        starCount.toString(),
                        style: w700.size16.colorWhite,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Text(
            rank.toString(),
            style: w700.size18.colorBlack,
          )
        ],
      ),
    );
  }
}
