import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
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
            print('object');
          },
          onTrailingPressed: () {
            print('object');
          }),
      body: [
        SizedBox(height: 47.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [],
        )
      ],
    );
  }
}
