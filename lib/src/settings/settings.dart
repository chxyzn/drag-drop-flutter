import 'package:drag_drop/main.dart';
import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
import 'package:drag_drop/src/constants/enums.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/login/login_repo.dart';
import 'package:drag_drop/src/settings/setting_repo.dart';
import 'package:drag_drop/src/utils/CustomAppBar.dart';
import 'package:drag_drop/src/utils/CustomScaffold.dart';
import 'package:drag_drop/src/utils/encrypted_storage.dart';
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
    print("this is username $GLOBAL_USERNAME");
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
        onTrailingPressed: () {},
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
                  GLOBAL_USERNAME,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                      color: CustomColor.primaryColor,
                      height: 0.7.h),
                ),
                Text(
                  "${GLOBAL_EMAIL}",
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
          leadingIcon: Image.asset(PngAssets.hapticsLogo),
          Text: 'Haptics',
          switchRequired: true,
          switchOn: enableHaptics,
          onSwitchChanged: (value) async {
            enableHaptics = value;
            await EncryptedStorage().write(
                key: EncryptedStorageKey.haptics.value,
                value: value.toString());
          },
        ),
        SizedBox(height: 50.h),
        GestureDetector(
          onTap: () async {
            await logout(context);
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
        ),
        SizedBox(
          height: 16.h,
        ),
        GestureDetector(
          onTap: () async {
            showDialog(context: context, builder: (context) => DeleteAccount());
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: CustomColor.logOutDangerRed,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delete Account",
                  style: w600.size16.copyWith(color: CustomColor.tileBgBlue),
                ),
                Icon(
                  Icons.delete,
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

// ignore: must_be_immutable
class CustomTile extends StatefulWidget {
  final Widget? leadingIcon;
  final String Text;
  bool switchRequired;
  final Function? onSwitchChanged;
  bool? switchOn;

  CustomTile({
    super.key,
    this.leadingIcon,
    required this.Text,
    this.switchRequired = false,
    this.onSwitchChanged,
    this.switchOn,
  });

  @override
  State<CustomTile> createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 18.w, vertical: widget.switchRequired ? 8.h : 16.h),
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: CustomColor.tileBgBlue,
        ),
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
            widget.switchRequired
                ? Switch(
                    value: widget.switchOn ?? false,
                    onChanged: ((value) {
                      setState(() {
                        widget.switchOn = value;
                      });
                      widget.onSwitchChanged!(value);
                    }),
                    activeTrackColor: CustomColor.primaryColor,
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Delete Account",
        style: w700.size16.copyWith(color: CustomColor.primaryColor),
      ),
      content: Text(
        "Are you sure you want to delete your account?\nThis will delete all your data and you will be logged out.",
        style: w500.size14.copyWith(color: CustomColor.primaryColor),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: w600.size16.copyWith(color: CustomColor.primaryColor),
          ),
        ),
        TextButton(
          onPressed: () async {
            await deleteAccount(context);
          },
          child: Text(
            "Delete",
            style: w600.size16.copyWith(color: CustomColor.logOutDangerRed),
          ),
        ),
      ],
    );
  }
}
