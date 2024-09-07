import 'package:drag_drop/src/constants/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.discreteCircle(
        color: CustomColor.primaryColor,
        secondRingColor: CustomColor.primary60Color,
        thirdRingColor: CustomColor.darkerDarkBlack,
        size: 40.h,
      ),
    );
  }
}
