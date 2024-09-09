import 'package:drag_drop/main.dart';
import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
import 'package:drag_drop/src/constants/endpoints.dart';
import 'package:drag_drop/src/constants/game.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/game/game_logic.dart';
import 'package:drag_drop/src/game/game_repo.dart';
import 'package:drag_drop/src/game/game_result_screen.dart';
import 'package:drag_drop/src/graph/graph_view.dart';
import 'package:drag_drop/src/settings/settings.dart';
import 'package:drag_drop/src/utils/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pausable_timer/pausable_timer.dart';

int TOTAL_TIME = 120;

class GameScreen extends ConsumerStatefulWidget {
  final int level;
  final int gridRowSize;
  final int gridColumnSize;
  final String hint;
  final List<int> questionNodes;

  final List<List<int>> questionEdges;
  final List<Map<String, dynamic>> nodes;
  const GameScreen({
    super.key,
    required this.level,
    required this.gridRowSize,
    required this.gridColumnSize,
    required this.questionNodes,
    required this.questionEdges,
    required this.nodes,
    required this.hint,
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  List<int> shapesPlacedOnGrid = [];
  late List<List<int>> baseMatrix;
  List<List<List<int>>> baseMatrixStates = [];
  late int gridRowSize;
  late int gridColumnSize;
  late int maxGridLength;
  List<int> questionNodes = [];
  List<List<int>> questionEdges = [];
  List<Map<String, dynamic>> availableNodes = [];

  bool showSubmitLoader = false;

  @override
  void initState() {
    gridRowSize = widget.gridRowSize;
    gridColumnSize = widget.gridColumnSize;

    //set available nodes i.e blocks
    availableNodes = List.from(widget.nodes);

    maxGridLength =
        gridRowSize >= gridColumnSize ? gridRowSize : gridColumnSize;

    baseMatrix = GameLogic().initBaseMatrix(gridRowSize, gridColumnSize);

    for (var element in widget.questionNodes) {
      questionNodes.add(element);
    }

    for (var element in widget.questionEdges) {
      // element.first += 1;
      // element.last += 1;
      questionEdges.add(element);
    }

    super.initState();
  }

  void resetBaseMatrix() {
    setState(() {
      baseMatrix = GameLogic().initBaseMatrix(
        gridRowSize,
        gridColumnSize,
      );

      TOTAL_TIME = 120;
      ref.read(timeProvider.notifier).update((prev) {
        return TOTAL_TIME;
      });
      availableNodes = widget.nodes;
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Block Clashing!!!',
                  style: w700.size16.copyWith(color: CustomColor.white),
                ),
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Error',
            style: w700.size16.copyWith(color: CustomColor.white),
          )));
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
      Map<String, dynamic> node =
          widget.nodes.firstWhere((element) => element['id'] == idToAdd);
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

  String formattedTime(int seconds) {
    int sec = seconds % 60;
    int min = (seconds / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";

    return "00:$minute:$second";
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
            SingleChildScrollView(
              child: Column(
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
                                    return HintWidget(hint: widget.hint);
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
                    height: 200.h,
                    width: 321.w,
                    child: GraphImageWidget(
                      imgUrl: GplanEndpoints.baseUrl +
                          GplanEndpoints.graphImageUrl +
                          "${widget.level}.png",
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
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
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
                  Consumer(builder: (context, ref, child) {
                    return GestureDetector(
                      onTap: () async {
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
                          setState(() {
                            showSubmitLoader = true;
                          });

                          String time = formattedTime(
                            TOTAL_TIME - ref.read(timeProvider),
                          );
                          int level = widget.level;
                          SubmitSolutionResponse response =
                              await submitSolution(time, level, ref);
                          if (response.statusCode != 200) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'Server Error',
                                style: w700.size16
                                    .copyWith(color: CustomColor.white),
                              ),
                            ));

                            setState(() {
                              showSubmitLoader = false;
                            });
                          }
                          timer.pause();
                          Navigator.of(context)
                              .pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => GameResultScreen(
                                stars: response.score,
                                bestTime: response.bestTime,
                                currentTime: time,
                                level: widget.level,
                              ),
                            ),
                          )
                              .then((_) {
                            setState(() {});
                          });
                          return;
                        }

                        timer.pause();
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
                        showLoader: showSubmitLoader,
                        height: 43.h,
                        width: 160.w,
                        textColor: CustomColor.white,
                        primaryText: 'Submit',
                        borderColor: CustomColor.primaryColor,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TimerText extends ConsumerStatefulWidget {
  TimerText({
    super.key,
  });

  @override
  ConsumerState<TimerText> createState() => _TimerTextState();
}

late PausableTimer timer;

class _TimerTextState extends ConsumerState<TimerText> {
  String formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  int localTime = 120;

  int getLocalTime() {
    return localTime;
  }

  @override
  void initState() {
    super.initState();

    timer = PausableTimer.periodic(const Duration(seconds: 1), () {
      if (localTime == 0) {
        timer.cancel();
        Navigator.pop(context, 'Time Up!');
      }

      localTime--;
      ref.read(timeProvider.notifier).update((prev) {
        return --prev;
      });
    });
    timer.start();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formattedTime(timeInSecond: ref.watch(timeProvider)),
      // ref.watch(timeProvider).toString(),
      style: w700.size24.copyWith(
        color: Colors.white,
      ),
    );
  }
}

class BottomSheetWidget extends ConsumerWidget {
  final Function resetFunction;
  const BottomSheetWidget({
    super.key,
    required this.resetFunction,
  });
  String formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      text:
                          ' ${formattedTime(timeInSecond: ref.watch(timeProvider))}',
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
                      timer.start();
                      ref.read(timeProvider.notifier).update((prev) {
                        return TOTAL_TIME;
                      });
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
                      timer.start();
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

class BlockOptionsWidget extends StatefulWidget {
  final int maxGridLength;
  final List<Map<String, dynamic>> nodes;
  const BlockOptionsWidget(
      {super.key, required this.maxGridLength, required this.nodes});

  @override
  State<BlockOptionsWidget> createState() => _BlockOptionsWidgetState();
}

class _BlockOptionsWidgetState extends State<BlockOptionsWidget> {
  List<List<int>> getShapeMatrix(Map<String, dynamic> node) {
    List dynamicShape = node['shape'];

    List<List<int>> shape = [];

    for (var e in dynamicShape) {
      shape.add(List.from(e));
    }

    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        if (shape[i][j] == 1) {
          shape[i][j] = node['id'];
        }
      }
    }
    return shape;
  }

  List<List<int>> rotateMatrix(List<dynamic> matrix) {
    int n = matrix.length;

    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        int temp = matrix[i][j];
        matrix[i][j] = matrix[j][i];
        matrix[j][i] = temp;
      }
    }

    for (int i = 0; i < n; i++) {
      matrix[i] = matrix[i].reversed.toList();
    }

    // return matrix as List<List<int>>;
    return [];
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
            for (int i = 0; i < widget.nodes.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      rotateMatrix(widget.nodes[i]["shape"]);
                    });
                  },
                  child: CustomDraggable(
                    shape: getShapeMatrix(widget.nodes[i]),
                    color: GraphColors().getColorFromId(widget.nodes[i]['id']),
                  ),
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
  final bool showLoader;
  final double width;
  final double height;
  const CustomContainer({
    super.key,
    required this.color,
    required this.width,
    this.showLoader = false,
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
        child: (showLoader)
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: LinearProgressIndicator(
                  color: CustomColor.white,
                ),
              )
            : Text(
                primaryText,
                textAlign: TextAlign.center,
                style: w700.size16.copyWith(color: textColor),
              ),
      ),
    );
  }
}

class HintWidget extends StatelessWidget {
  final String hint;
  const HintWidget({super.key, required this.hint});

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
                  hint,
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
