import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/login/login_screen.dart';
import 'package:drag_drop/src/utils/CustomAppBar.dart';
import 'package:drag_drop/src/utils/CustomScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: CustomColor.white,
      appBar: CustomAppBar(
        title: "Settings",
        leadingIconName: SvgAssets.homeIcon,
        trailingIconName: SvgAssets.cicrcleHelp,
        isTrailingRequired: false,
        onLeadingPressed: () {
          Navigator.of(context).pop();
        },
        onTrailingPressed: () {
          print('object');
        },
      ),
      body: [
        SizedBox(height: 22.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Account",
              style: w700.size14.copyWith(color: CustomColor.primaryColor),
            ),
            Text("")
          ],
        ),
        SizedBox(height: 18.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: CustomColor.imgBgColorGrey,
              child: Image.asset(
                PngAssets.avatarPlaceholder,
                height: 25.h,
              ),
              radius: 32.h,
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Erling Haaland",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                      color: CustomColor.primaryColor,
                      height: 0.7.h),
                ),
                Text(
                  "erling.haaland@gmail.com",
                  style: w500.size15.copyWith(color: CustomColor.primaryColor),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 20.5.h),
        Divider(
          thickness: 1.3.sp,
          color: CustomColor.dividerGrey,
        ),
        SizedBox(height: 27.5.h),
        CustomTile(
          leadingIcon: Image.asset(PngAssets.soundLogo),
          Text: 'Sound',
        ),
        CustomTile(
          leadingIcon: Image.asset(PngAssets.hapticsLogo),
          Text: 'Haptics',
        ),
        CustomTile(
          leadingIcon: Icon(
            Icons.design_services_outlined,
            color: CustomColor.primaryColor,
            size: 24.h,
          ),
          Text: 'Edit Username',
        ),
        CustomTile(
          leadingIcon: Image.asset(PngAssets.developersLogo),
          Text: 'Developers',
        ),
        SizedBox(height: 100.h),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: ((context) => LoginScreen())));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: CustomColor.logOutDangerRed),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Log Out",
                  style: w600.size16.copyWith(color: CustomColor.tileBgBlue),
                ),
                Icon(
                  Icons.logout,
                  size: 24.h,
                  color: CustomColor.white,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class CustomTile extends StatefulWidget {
  CustomTile({super.key, this.leadingIcon, required this.Text});

  final Widget? leadingIcon;
  final String Text;

  @override
  State<CustomTile> createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: CustomColor.tileBgBlue),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 24.h,
                  margin: EdgeInsets.only(right: 16.w),
                  child: widget.leadingIcon,
                ),
                Text(
                  widget.Text,
                  style: w600.size16.copyWith(color: CustomColor.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
