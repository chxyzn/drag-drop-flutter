import 'package:drag_drop/src/constants/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/textstyles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String leadingIconName;
  final String trailingIconName;
  final bool isTrailingRequired;
  final bool isTitleString;
  final Widget? titleWidget;
  final Function() onLeadingPressed;
  final Function() onTrailingPressed;

  CustomAppBar({
    this.title,
    required this.leadingIconName,
    required this.trailingIconName,
    this.isTrailingRequired = true,
    required this.onLeadingPressed,
    required this.onTrailingPressed,
    this.isTitleString = true,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20).h,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onLeadingPressed,
            child: Container(
              height: 45.h,
              width: 45.w,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              padding: EdgeInsets.all(10.h),
              child: SvgPicture.asset(
                leadingIconName,
                height: 16.h,
              ),
            ),
          ),
          isTitleString
              ? Container(
                  child: Text(
                    title!,
                    style:
                        w700.size24.copyWith(color: CustomColor.primaryColor),
                  ),
                )
              : titleWidget!,
          isTrailingRequired
              ? GestureDetector(
                  onTap: onTrailingPressed,
                  child: Container(
                    height: 45.h,
                    width: 45.w,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      trailingIconName,
                      height: 16.h,
                    ),
                  ),
                )
              : Container(height: 24.h, width: 75.w)
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(150.h);
}
