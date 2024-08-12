import 'dart:async';

import 'package:drag_drop/main.dart';
import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
import 'package:drag_drop/src/constants/game.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/game/game_logic.dart';
import 'package:drag_drop/src/game/game_result_screen.dart';
import 'package:drag_drop/src/graph/graph_view.dart';
import 'package:drag_drop/src/settings/settings.dart';
import 'package:drag_drop/src/utils/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:flutter_svg/flutter_svg.dart';

List<String> graphTheoryLessons = [
  'The total sum of degrees of all the vertices in a graph is equal to twice the number of edges.',
  'The maximum number of edges in a graph with n vertices is n(n-1)/2.',
  'Cycle graph, Complete graph, Bipartite graph, and Complete Bipartite graph are some of the special types of graphs.',
  'A graph is Eulerian if and only if all its vertices are of even degree.',
];

class GameScreen extends StatefulWidget {
  final int level;
  final Map<String, dynamic> apiResonse;
  const GameScreen({super.key, required this.level, required this.apiResonse});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<int> shapesPlacedOnGrid = [];
  late List<List<int>> baseMatrix;
  List<List<List<int>>> baseMatrixStates = [];
  late int gridRowSize;
  late int gridColumnSize;
  late int maxGridLength;
  List<int> questionNodes = [];
  List<List<int>> questionEdges = [];
  List<Map<String, dynamic>> availableNodes = [];

  @override
  void initState() {
    gridRowSize = widget.apiResonse['grid']['row_size'];
    gridColumnSize = widget.apiResonse['grid']['column_size'];

    //set available nodes i.e blocks
    availableNodes = List.from(widget.apiResonse['graph']['nodes']);

    maxGridLength =
        gridRowSize >= gridColumnSize ? gridRowSize : gridColumnSize;

    baseMatrix = GameLogic().initBaseMatrix(gridRowSize, gridColumnSize);

    List apiNodes = widget.apiResonse['graph']['nodes'];
    for (var element in apiNodes) {
      questionNodes.add(element['id']);
    }

    List apiEdges = widget.apiResonse['graph']['edges'];
    print(apiEdges);
    for (var element in apiEdges) {
      // element.first += 1;
      // element.last += 1;
      questionEdges.add(element);
    }

    print('these are questionEdges $questionEdges');

    super.initState();
  }

  void resetBaseMatrix() {
    setState(() {
      baseMatrix = GameLogic().initBaseMatrix(
        gridRowSize,
        gridColumnSize,
      );

      availableNodes = widget.apiResonse['graph']['nodes'];

      print(
          'this is the length of available nodes after reste ${availableNodes.length}');
      print(
          ' this is the length of widget.graph.nodes ${widget.apiResonse['graph']['nodes'].length}');
    });
  }

  void onBlockAccept(
    MatrixCoords touchdownCoords,
    List<List<int>> shapeMatrix,
  ) async {
    bool canUpdate = true;
    int num1 = -2;
    int num2 = -2;
    for (int x = 0; x < gridRowSize; x++) {
      for (int y = 0; y < gridColumnSize; y++) {
        if (shapeMatrix[x][y] > 0) {
          num1 = x + touchdownCoords.row - pickupCoords.row;
          num2 = y + touchdownCoords.col - pickupCoords.col;

          if (num1 >= 0 &&
              num1 < gridRowSize &&
              num2 >= 0 &&
              num2 < gridColumnSize) {
            if (baseMatrix[num1][num2] > 0) {
              canUpdate = false;
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Block Clashing!!!'),
              ));
              // break;
              return;
            }
          } else {
            canUpdate = false;
            break;
          }
        }
      }
    }

    if (canUpdate) {
      int idOfElementToRemove = 0;

      setState(() {
        List<List<int>> baseMatrixState = GameLogic().initBaseMatrix(
          gridRowSize,
          gridColumnSize,
        );
        copyMatrix(baseMatrix, baseMatrixState);
        baseMatrixStates.add(baseMatrixState);
        for (int x = 0; x < gridRowSize; x++) {
          for (int y = 0; y < gridColumnSize; y++) {
            if (shapeMatrix[x][y] > 0) {
              idOfElementToRemove = shapeMatrix[x][y];
              baseMatrix[x + touchdownCoords.row - pickupCoords.row]
                      [y + touchdownCoords.col - pickupCoords.col] =
                  shapeMatrix[x][y];
            }
          }
        }

        availableNodes = availableNodes
            .where((element) => element['id'] != idOfElementToRemove)
            .toList();

        shapesPlacedOnGrid.add(idOfElementToRemove);
      });

      final canVibrate = await Haptics.canVibrate();

      if (canVibrate && enableHaptics) {
        await Haptics.vibrate(HapticsType.success);
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.red, content: Text('Error')));
    }
  }

  List<List<int>> getAdjacentEdges() {
    List<List<int>> edgesList = [];
    int a = 0;
    int b = 0;
    List<int> edge = [];
    for (int i = 0; i < gridRowSize; i++) {
      for (int j = 0; j < gridColumnSize; j++) {
        a = baseMatrix[i][j];
        if (j + 1 < gridColumnSize) {
          b = baseMatrix[i][j + 1];
          edge = sort([a, b]);
          if (a != 0 && b != 0 && a != b && !edgesList.contains(edge)) {
            edgesList.add(edge);
          }
        }
        if (i + 1 < gridRowSize) {
          b = baseMatrix[i + 1][j];
          edge = sort([a, b]);
          if (a != 0 && b != 0 && a != b && !edgesList.contains(edge)) {
            edgesList.add(edge);
          }
        }
      }
    }
    return edgesList;
  }

  List<int> sort(List<int> list) {
    list.sort();
    return list;
  }

  List<List<int>> removeDuplicates(List<List<int>> list) {
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < list.length; j++) {
        if (i != j && list[i][0] == list[j][0] && list[i][1] == list[j][1]) {
          list.removeAt(j);
        }
      }
    }
    return list;
  }

  bool isSolutionCorrect(
      List<List<int>> inputEdges, List<List<int>> correctEdges) {
    List<List<int>> correctEdgesCopy = [];
    correctEdges.forEach((element) {
      correctEdgesCopy.add([element[0] + 1, element[1] + 1]);
    });
    if (inputEdges.length != correctEdgesCopy.length) {
      print('lengths are not equal');
      return false;
    }

    for (int i = 0; i < correctEdgesCopy.length; i++) {
      int value1 = uniqueCommutativeBinaryOperation(
          correctEdgesCopy[i][0], correctEdgesCopy[i][1]);

      for (int j = 0; j < inputEdges.length; j++) {
        int value2 = uniqueCommutativeBinaryOperation(
            inputEdges[j][0], inputEdges[j][1]);
        if (value1 == value2) {
          break;
        }
        if (j == inputEdges.length - 1) {
          print('edges are not equal');
          return false;
        }
      }
    }

    return true;
  }

  int uniqueCommutativeBinaryOperation(int a, int b) {
    if (a > b) {
      return ((a - 1) * a / 2 + b).toInt();
    } else {
      return ((b - 1) * b / 2 + a).toInt();
    }
  }

  void undo() {
    if (baseMatrixStates.isEmpty) return; //add snackbar or something
    setState(() {
      copyMatrix(baseMatrixStates.last, baseMatrix);
      baseMatrixStates.removeLast();

      //adding the shape in options again
      int idToAdd = shapesPlacedOnGrid.last;
      Map<String, dynamic> node = widget.apiResonse['graph']['nodes']
          .firstWhere((element) => element['id'] == idToAdd);
      availableNodes.insert(0, node);
      shapesPlacedOnGrid.removeLast();
    });
  }

  void copyMatrix(
      List<List<int>> referenceMatrix, List<List<int>> targetMatrix) {
    setState(() {
      for (int i = 0; i < gridRowSize; i++) {
        for (int j = 0; j < gridColumnSize; j++) {
          targetMatrix[i][j] = referenceMatrix[i][j];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          leadingIconName: SvgAssets.backIcon,
          trailingIconName: SvgAssets.settingsIcon,
          onLeadingPressed: () {
            Navigator.of(context).pop();
          },
          title: 'Level ${widget.level.toString()}',
          onTrailingPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ),
            );
          },
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 321.w,
                  margin: EdgeInsets.symmetric(horizontal: 25.0.w),
                  decoration: BoxDecoration(
                    color: CustomColor.primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                barrierColor: Colors.black.withOpacity(0.3),
                                barrierDismissible: true,
                                builder: ((context) {
                                  return HintWidget();
                                }));
                          },
                          child: CustomGameButton(
                            svgPath: SvgAssets.hintIcon,
                            text: 'Hint',
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: w600.size15.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            TimerText(),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            resetBaseMatrix();
                          },
                          child: CustomGameButton(
                            svgPath: SvgAssets.resetIcon,
                            text: 'Reset',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: CustomColor.backgrondBlue,
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                    border: Border.all(
                      color: CustomColor.dividerGrey,
                      width: 1.w,
                    ),
                  ),
                  height: 140.h,
                  width: 321.w,
                  child: GraphWidget(
                    nodes: questionNodes,
                    edges: questionEdges,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        height: gridRowSize * GameConstants.gridBlockSize,
                        width: gridColumnSize * GameConstants.gridBlockSize,
                        child: Center(
                          child: BaseBlockGenerator(
                            matrix: baseMatrix,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: gridRowSize * GameConstants.gridBlockSize,
                        width: gridColumnSize * GameConstants.gridBlockSize,
                        child: Center(
                          child: TargetBlockGenerator(
                            shape: baseMatrix,
                            onAccept: onBlockAccept,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                BlockOptionsWidget(
                  maxGridLength: maxGridLength,
                  nodes: availableNodes,
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      undo();
                    },
                    child: CustomContainer(
                      color: CustomColor.backgrondBlue,
                      height: 43.h,
                      width: 160.w,
                      textColor: CustomColor.primaryColor,
                      primaryText: 'Undo',
                      borderColor: CustomColor.primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 11.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      List<List<int>> edges =
                          removeDuplicates(getAdjacentEdges());

                      List<int> nodes = [];
                      for (List<int> edge in edges) {
                        for (int node in edge) {
                          if (!nodes.contains(node)) {
                            nodes.add(node);
                          }
                        }
                      }
                      bool correctSolution =
                          isSolutionCorrect(edges, questionEdges);

                      if (correctSolution) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GameResultScreen(
                              level: widget.level,
                            ),
                          ),
                        );
                        return;
                      }

                      showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.3),
                          barrierDismissible: true,
                          builder: ((context) {
                            return BottomSheetWidget(
                              resetFunction: resetBaseMatrix,
                            );
                          }));
                    },
                    child: CustomContainer(
                      color: CustomColor.primaryColor,
                      height: 43.h,
                      width: 160.w,
                      textColor: CustomColor.white,
                      primaryText: 'Submit',
                      borderColor: CustomColor.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimerText extends StatefulWidget {
  const TimerText({
    super.key,
  });

  @override
  State<TimerText> createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  int totalTime = 120;

  String formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (totalTime == 0) {
          timer.cancel();
          Navigator.pop(context, 'Time Up!');
        }
        totalTime--;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formattedTime(timeInSecond: totalTime),
      style: w700.size24.copyWith(
        color: Colors.white,
      ),
    );
  }
}

class BottomSheetWidget extends StatelessWidget {
  final Function resetFunction;
  const BottomSheetWidget({
    super.key,
    required this.resetFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 409.h,
        width: 339.w,
        decoration: BoxDecoration(
          color: CustomColor.backgrondBlue,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Oops! Your\nSolution Is\n',
                style: w700.size36.copyWith(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'Incorrect',
                    style: w700.size36.copyWith(
                      color: CustomColor.logOutDangerRed,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.w),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text:
                      'You can reset and try again, or continue with the current time Of',
                  style: w700.size16.copyWith(
                    color: CustomColor.primary60Color,
                  ),
                  children: [
                    TextSpan(
                      text: ' 4:00',
                      style: w700.size16.copyWith(
                        color: CustomColor.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Material(
                  child: GestureDetector(
                    onTap: () {
                      resetFunction();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 265.w,
                      height: 43.h,
                      decoration: BoxDecoration(
                        color: CustomColor.backgrondBlue,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          width: 1.w,
                          color: CustomColor.primaryColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Reset and Try Again',
                          style: w700.size16.copyWith(
                            color: CustomColor.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 11.h),
                Material(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
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
          ],
        ),
      ),
    );
  }
}

class BlockOptionsWidget extends StatelessWidget {
  final int maxGridLength;
  final List<Map<String, dynamic>> nodes;
  const BlockOptionsWidget(
      {super.key, required this.maxGridLength, required this.nodes});

  List<List<int>> getShapeMatrix(Map<String, dynamic> node) {
    List<List<int>> shape = node['shape'];
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        if (shape[i][j] == 1) {
          shape[i][j] = node['id'];
        }
      }
    }
    return shape;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColor.backgrondBlue,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 16,
            ),
            for (int i = 0; i < nodes.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CustomDraggable(
                  shape: getShapeMatrix(nodes[i]),
                  color: GraphColors().getColorFromId(nodes[i]['id']),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class MatrixCoords {
  final int row;
  final int col;
  const MatrixCoords({required this.row, required this.col});
}

class CustomDraggable extends StatelessWidget {
  final List<List<int>> shape;
  final Color color;
  final String text;
  const CustomDraggable({
    super.key,
    required this.shape,
    this.color = Colors.black,
    this.text = '',
  });

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<List<List<int>>>(
      data: shape,
      feedback: ShapeGenerator(
        shape: shape,
        color: color,
        text: text,
      ),
      childWhenDragging: SizedBox.shrink(),
      child: ShapeGenerator(
        shape: shape,
        color: color,
        text: text,
      ),
    );
  }
}

class CustomGameButton extends StatelessWidget {
  final String svgPath;
  final String text;
  const CustomGameButton({
    super.key,
    required this.svgPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      width: 44.w,
      decoration: BoxDecoration(
        color: CustomColor.backgrondBlue,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(svgPath),
          const SizedBox(
            height: 10,
          ),
          Text(
            text,
            style: w700.size9.copyWith(
              color: CustomColor.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Color color;
  final Color textColor;
  final Color borderColor;
  final String primaryText;
  final double width;
  final double height;
  const CustomContainer({
    super.key,
    required this.color,
    required this.width,
    required this.height,
    required this.textColor,
    required this.primaryText,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: borderColor,
          width: 1.w,
        ),
      ),
      child: Center(
        child: Text(
          primaryText,
          textAlign: TextAlign.center,
          style: w700.size16.copyWith(color: textColor),
        ),
      ),
    );
  }
}

class HintWidget extends StatelessWidget {
  const HintWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 409.h,
        width: 339.w,
        decoration: BoxDecoration(
          color: CustomColor.backgrondBlue,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 101.w,
                  right: 101.w,
                  top: 73.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hint',
                      style: w700.size36.copyWith(
                        color: CustomColor.goldStarColor,
                      ),
                    ),
                    SvgPicture.asset(
                      SvgAssets.hintIcon,
                      height: 36.h,
                      width: 36.h,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        CustomColor.goldStarColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 35.w, right: 35.w, top: 25.h),
                child: Text(
                  'Proident dolore esse do cillum velit ea excepteur mollit tempor adipisicing qui elit ullamco. Labore laborum esse tempor anim deserunt excepteur cupidatat Lorem ea dolor Lorem qui eiusmod ut. Et sunt commodo ea laboris quis dolor dolore.',
                  textAlign: TextAlign.center,
                  style: w700.size16.copyWith(
                    color: CustomColor.primary60Color,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
