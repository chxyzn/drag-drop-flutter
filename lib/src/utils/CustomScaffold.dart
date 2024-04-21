import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final List<Widget>? body;
  final DecorationImage? backgroundImage;
  final Color? backgroundColor;

  const CustomScaffold({
    Key? key,
    this.appBar,
    this.body,
    this.backgroundImage,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget scaffoldBody = SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (body != null)
              ...body!.map((widget) => Center(child: widget)).toList(),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
        decoration: BoxDecoration(
          image: backgroundImage,
          color: backgroundColor,
        ),
        child: SingleChildScrollView(child: scaffoldBody),
      ),
    );
  }
}
