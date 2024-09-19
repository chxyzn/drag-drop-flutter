import 'package:drag_drop/src/constants/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Instructions', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor:
            CustomColor.primaryColor, // Dark blue color from the image
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionWidget(
                'Rules',
                [
                  RuleWidget(
                    'Objective',
                    'Place blocks on the grid to match the graph\'s connections without creating new connections.',
                  ),
                  RuleWidget(
                    'Shapes',
                    'Each shape represents a node from the graph.',
                  ),
                  RuleWidget(
                    'Placement Rules',
                    [
                      'Shapes must fit inside the grid and cannot overlap.',
                      'Shapes can be rotated clockwise by 90°. Double tap to rotate.',
                    ],
                  ),
                  RuleWidget(
                    'Hints',
                    'Hints will give the location of one block for levels after 10.',
                  ),
                  RuleWidget(
                    'Undoo',
                    'You can undo your moves at any time.',
                  ),
                  RuleWidget(
                    'Stars',
                    'Stars are awarded based on completion time.',
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              SectionWidget(
                'Tips',
                [
                  TipWidget(
                    'Understand the Graph First',
                    'Before placing shapes, look at the connections of nodes.',
                  ),
                  TipWidget(
                    'Start with Corners',
                    'Try to find out which block might be a corner piece in the grid.',
                  ),
                  TipWidget(
                    'Rotate Wisely',
                    'For most of the levels you might not need to rotate the blocks.',
                  ),
                  TipWidget(
                    'Use Undo',
                    'Don\'t hesitate to undo moves if a shape placement feels incorrect.',
                  ),
                  TipWidget(
                    'Work Backwards',
                    'If stuck, consider starting from most wierd looking shape.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget SectionWidget(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: CustomColor.primaryColor,
          ),
        ),
        SizedBox(height: 16.h),
        ...children,
      ],
    );
  }

  Widget RuleWidget(String title, dynamic content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• $title:',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: CustomColor.primaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        if (content is String)
          Text(content)
        else if (content is List<String>)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content.map((item) => Text('$item')).toList(),
          ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget TipWidget(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• $title',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,

            color: Color(0xFF0A3D62), // Dark blue color from the image
          ),
        ),
        SizedBox(height: 8.h),
        Text(content),
        SizedBox(height: 16.h),
      ],
    );
  }
}
