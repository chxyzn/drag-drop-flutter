import 'package:drag_drop/src/constants/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final List<Widget>? body;
  final DecorationImage? backgroundImage;
  final Color? backgroundColor;
  final double? verticalPadding;

  const CustomScaffold({
    Key? key,
    this.appBar,
    this.body,
    this.backgroundImage,
    this.backgroundColor,
    this.verticalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget scaffoldBody = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 25.0.w,
        vertical: verticalPadding ?? 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          if (body != null)
            ...body!.map((widget) => Center(child: widget)).toList(),
        ],
      ),
    );

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: appBar,
        backgroundColor: CustomColor.white,
        body: Container(
          decoration: BoxDecoration(
            image: backgroundImage,
            color: backgroundColor,
          ),
          child: SingleChildScrollView(child: scaffoldBody),
        ),
      ),
    );
  }
}
