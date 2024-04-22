import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaderboardTileWidget extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String name;
  final int starCount;
  final int rank;

  const LeaderboardTileWidget(
      {Key? key,
      required this.backgroundColor,
      required this.textColor,
      required this.name,
      required this.starCount,
      required this.rank})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 4,
                  child: Text(
                    name,
                    style: w600.size16.copyWith(color: textColor),
                  )),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      size: 20.h,
                      color: CustomColor.goldStarColor,
                    ),
                    Text(
                      starCount.toString(),
                      style: w700.size16.copyWith(color: textColor),
                    )
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      rank.toString(),
                      style: w700.size16.copyWith(color: textColor),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
