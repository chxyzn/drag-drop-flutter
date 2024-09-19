import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final List<Widget> helpWidgets = [
  HoldToDrag(),
  Logix(),
];

class GraphBoxHelp extends StatefulWidget {
  const GraphBoxHelp({super.key});

  @override
  State<GraphBoxHelp> createState() => _GraphBoxHelpState();
}

class _GraphBoxHelpState extends State<GraphBoxHelp> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 409.h,
      width: 339.w,
      decoration: BoxDecoration(
        color: CustomColor.backgrondBlue,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //add title text here
            Material(
              color: CustomColor.backgrondBlue,
              child: Text(
                "INSTRUCTIONS",
                style: w700.size36.copyWith(
                  color: CustomColor.primary60Color,
                ),
              ),
            ),
            helpWidgets[i],
            Material(
              child: GestureDetector(
                onTap: () {
                  if (i < helpWidgets.length - 1) {
                    setState(() {
                      i++;
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  width: 265.w,
                  height: 43.h,
                  decoration: BoxDecoration(
                    color: CustomColor.primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      width: 1.w,
                      color: CustomColor.primaryColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: w700.size16.copyWith(
                        color: CustomColor.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HoldToDrag extends StatelessWidget {
  const HoldToDrag({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/jpeg/holdtodrag.jpeg"),
        Material(
          color: CustomColor.backgrondBlue,
          child: Text(
            "Hold the blocks to start dragging.",
            textAlign: TextAlign.center,
            style: w700.size16.copyWith(
              color: CustomColor.primary60Color,
            ),
          ),
        ),
      ],
    );
  }
}

class Logix extends StatelessWidget {
  const Logix({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.asset("assets/jpeg/logix.jpeg"),
          SizedBox(
            height: 18.h,
          ),
          Material(
            color: CustomColor.backgrondBlue,
            child: Text(
              "The blocks are color coded with the graph nodes. Use these blocks to match the adjacencies of the graph.",
              textAlign: TextAlign.center,
              style: w700.size16.copyWith(
                color: CustomColor.primary60Color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
