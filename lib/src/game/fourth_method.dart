// ignore_for_file: avoid_print, constant_identifier_names

import 'dart:math';

import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/graph/graph_view.dart';
import 'package:drag_drop/src/game/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const int MATRIX_SIZE = 5;
MatrixCoords pickupCoords = const MatrixCoords(row: 0, col: 0);

List<List<int>> shape = [
  [5, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
];

List<List<int>> shape3x3 = [
  [3, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0]
];

List<List<int>> shape4x4 = [
  [0, 0, 0, 0, 0],
  [4, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0]
];

List<List<int>> shape2x2 = [
  [2, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
];

// List<List<int>> shape2 = [
//   [1, 0, 1],
//   [1, 0, 1],
//   [1, 1, 1]
// ];
class FourthMethod extends StatefulWidget {
  const FourthMethod({super.key});

  @override
  State<FourthMethod> createState() => _FourthMethodState();
}

class _FourthMethodState extends State<FourthMethod> {
  List<List<int>> baseMatrix = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
  ];

  void resetBaseMatrix() {
    setState(() {
      baseMatrix = [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
      ];
    });
  }

  void updateBaseMatrixNew(
    MatrixCoords touchdownCoords,
    List<List<int>> shapeMatrix,
  ) {
    bool canUpdate = true;
    int num1 = -2;
    int num2 = -2;
    for (int x = 0; x < MATRIX_SIZE; x++) {
      for (int y = 0; y < MATRIX_SIZE; y++) {
        if (shapeMatrix[x][y] > 0) {
          num1 = x + touchdownCoords.row - pickupCoords.row;
          num2 = y + touchdownCoords.col - pickupCoords.col;
          if (num1 >= 0 &&
              num1 < MATRIX_SIZE &&
              num2 >= 0 &&
              num2 < MATRIX_SIZE) {
            if (baseMatrix[num1][num2] > 0) {
              canUpdate = false;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Block Clashing!!!'),
              ));
              break;
            }
          } else {
            print('---------------------------');

            print('went wrong at x = $x and y = $y');
            print(
                'these are pickupCoords now ${pickupCoords.row}, ${pickupCoords.col}');
            print(
                ' touchDownCoords ${touchdownCoords.row}, ${touchdownCoords.col}');
            print('num 1 $num1, num 2 $num2');
            canUpdate = false;
            break;
          }
        }
      }
    }

    if (canUpdate) {
      setState(() {
        for (int x = 0; x < MATRIX_SIZE; x++) {
          for (int y = 0; y < MATRIX_SIZE; y++) {
            if (shapeMatrix[x][y] > 0) {
              baseMatrix[x + touchdownCoords.row - pickupCoords.row]
                      [y + touchdownCoords.col - pickupCoords.col] =
                  shapeMatrix[x][y];
            }
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.red, content: Text('Error')));
    }
  }

  List<List<int>> getAdjacentEdges() {
    List<List<int>> edgesList = [];
    for (var i = 0; i < MATRIX_SIZE - 1; i++) {
      for (var j = 0; j < MATRIX_SIZE - 1; j++) {
        if (baseMatrix[i][j] > 0 &&
            baseMatrix[i][j + 1] > 0 &&
            baseMatrix[i][j] != baseMatrix[i][j + 1]) {
          if (!edgesList.contains([baseMatrix[i][j], baseMatrix[i][j + 1]])) {
            edgesList.add([baseMatrix[i][j], baseMatrix[i][j + 1]]);
          }
        }
      }
    }
    for (var i = 0; i < MATRIX_SIZE - 1; i++) {
      for (var j = 0; j < MATRIX_SIZE - 1; j++) {
        if (baseMatrix[j][i] > 0 &&
            baseMatrix[j + 1][i] > 0 &&
            baseMatrix[j][i] != baseMatrix[j + 1][i]) {
          if (!edgesList.contains([baseMatrix[j][i], baseMatrix[j + 1][i]])) {
            edgesList.add([baseMatrix[j][i], baseMatrix[j + 1][i]]);
          }
        }
      }
    }
    return edgesList;
  }

  // void generateAdjacentGraph(){
  //   for(int i = 0; i<MATRIX_SIZE; i++){
  //     for(int j = 0; j<MATRIX_SIZE; j++){
  //       if(matrix[i][j] == 1){
  //         if(i-1 >= 0 && matrix[i-1][j] == 1){
  //           print('adjacent to ${i-1}, $j');
  //         }
  //         if(i+1 < MATRIX_SIZE && matrix[i+1][j] == 1){
  //           print('adjacent to ${i+1}, $j');
  //         }
  //         if(j-1 >= 0 && matrix[i][j-1] == 1){
  //           print('adjacent to $i, ${j-1}');
  //         }
  //         if(j+1 < MATRIX_SIZE && matrix[i][j+1] == 1){
  //           print('adjacent to $i, ${j+1}');
  //         }
  //       }
  //     }
  //   }
  // }

  List<List<int>> generateRandomMatrix(
      {required int rowSize, required int coloumnSize, required blockNumber}) {
    List<List<int>> returnMatrix = [];
    returnMatrix = List.generate(
        coloumnSize, (index) => List.generate(rowSize, (index) => -1));

    for (int i = 0; i < coloumnSize; i++) {
      for (int j = 0; j < rowSize; j++) {
        returnMatrix[i][j] = (Random().nextInt(2) == 0) ? 0 : blockNumber;
      }
    }
    return returnMatrix;
  }

  void printShape(List<List<int>> shape, String? identifier) {
    for (int i = 0; i < shape.length; i++) {
      print('printing ${identifier ?? 'shape'}: ${shape[i]} \t\t\t $i');
    }
  }

  List<List<int>> generateNxNIn5x5Matrix(
      {required int N, required int blockNumber}) {
    List<List<int>> returnMatrix =
        List.generate(5, (index) => List.generate(5, (index) => 0));

    for (int i = 0; i < N; i++) {
      for (int j = 0; j < N; j++) {
        returnMatrix[i][j] = Random().nextInt(2) == 0 ? 0 : blockNumber;
      }
    }
    return returnMatrix;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Stack(
            children: [
              SizedBox(
                height: 270,
                width: 270,
                child: Center(
                  child: BaseBlockGenerator(
                    matrix: baseMatrix,
                  ),
                ),
              ),
              SizedBox(
                height: 270,
                width: 270,
                child: Center(
                  child: TargetBlockGenerator(
                    shape: baseMatrix,
                    onAccept: updateBaseMatrixNew,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 25),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    CustomDraggable(
                      shape: shape,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const VerticalDivider(
                      width: 4,
                      color: Colors.black,
                      thickness: 2,
                      endIndent: 4,
                      indent: 3,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    CustomDraggable(
                      shape: shape3x3,
                    ),
                    const VerticalDivider(
                      width: 4,
                      color: Colors.black,
                      thickness: 2,
                      endIndent: 4,
                      indent: 3,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    CustomDraggable(
                      shape: shape4x4,
                    ),
                    const VerticalDivider(
                      width: 4,
                      color: Colors.black,
                      thickness: 2,
                      endIndent: 4,
                      indent: 3,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    CustomDraggable(
                      shape: shape2x2,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      shape = generateRandomMatrix(
                          rowSize: 5, coloumnSize: 5, blockNumber: 5);

                      setState(() {});
                    },
                    child: Container(
                      color: Colors.blue,
                      height: 50,
                      width: 125,
                      child: const Center(
                        child: Text(
                          'Randomise 5x5',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      shape3x3 = generateNxNIn5x5Matrix(N: 3, blockNumber: 3);

                      setState(() {});
                    },
                    child: Container(
                      color: Colors.blue,
                      height: 50,
                      width: 125,
                      child: const Center(
                        child: Text(
                          'Randomise 3x3',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      shape4x4 = generateNxNIn5x5Matrix(N: 4, blockNumber: 4);

                      setState(() {});
                    },
                    child: Container(
                      color: Colors.blue,
                      height: 50,
                      width: 125,
                      child: const Center(
                        child: Text(
                          'Randomise 4x4',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      shape2x2 = generateNxNIn5x5Matrix(N: 2, blockNumber: 2);

                      setState(() {});
                    },
                    child: Container(
                      color: Colors.blue,
                      height: 50,
                      width: 125,
                      child: const Center(
                        child: Text(
                          'Randomise 2x2',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  resetBaseMatrix();
                },
                child: Container(
                  color: Colors.red,
                  height: 50,
                  width: 100,
                  child: const Center(
                    child: Text(
                      'Reset',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  List<List<int>> edges = getAdjacentEdges();

                  List<int> nodes = [];
                  for (List<int> edge in edges) {
                    for (int node in edge) {
                      if (!nodes.contains(node)) {
                        nodes.add(node);
                      }
                    }
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GraphViewPage(
                        isSolutionCorrect: true,
                        graphTheoryText: '',
                        nodes: nodes,
                        edges: edges,
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.black,
                  height: 50,
                  width: 100,
                  child: const Center(
                    child: Text(
                      'View Graph',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TargetBlockGenerator extends StatelessWidget {
  final List<List<int>> shape;
  final Function onAccept;
  const TargetBlockGenerator(
      {super.key, required this.shape, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < shape.length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int j = 0; j < shape[i].length; j++) //row traversal
                DragTarget<List<List<int>>>(
                  onAccept: (List<List<int>> data) {
                    onAccept(MatrixCoords(row: i, col: j), data);
                  },
                  builder: (context, candidates, rejects) {
                    return const Block(
                      opacity: 0,
                      padding: EdgeInsets.all(1),
                    );
                  },
                ),
            ],
          ),
      ],
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class ShapeGenerator extends StatelessWidget {
  final List<List<int>> shape;
  final Color color;
  final String text;
  const ShapeGenerator({
    super.key,
    required this.shape,
    required this.color,
    this.text = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < shape.length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int j = 0; j < shape[i].length; j++) //row traversal
                (shape[i][j] > 0)
                    ? GestureDetector(
                        onTapUp: (_) {
                          print('onTapUp picked shape at $i, $j');
                        },
                        onTapDown: (_) {
                          print('onTapDown picked shape at $i, $j');
                          pickupCoords = MatrixCoords(row: i, col: j);
                        },
                        child: Block(
                          color: color,
                          text: text,
                          border: true,
                        ),
                      )
                    : const Block(
                        opacity: 0,
                        smallSize: true,
                      ),
            ],
          )
      ],
    );
  }
}

class BaseBlockGenerator extends StatelessWidget {
  final List<List<int>> matrix;
  const BaseBlockGenerator({
    super.key,
    required this.matrix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < matrix.length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int j = 0; j < matrix[i].length; j++) //row traversal
                BaseBlock(
                  value: matrix[i][j],
                  border: true,
                ),
            ],
          )
      ],
    );
  }
}

class BaseBlock extends StatelessWidget {
  final int value;
  final bool border;
  const BaseBlock({super.key, required this.value, this.border = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.w,
      width: 38.w,
      decoration: BoxDecoration(
          color: value > 0
              ? GraphColors().getColorFromId(value)
              : CustomColor.backgrondBlue,
          border: border
              ? Border.all(color: CustomColor.gridBorderColor, width: 1)
              : null),
      child: Center(
          child: Text(
        value > 0 ? value.toString() : '',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      )),
    );
  }
}

class Block extends StatelessWidget {
  final double opacity;
  final EdgeInsets padding;
  final Color color;
  final String text;
  final bool border;
  final bool smallSize;
  const Block({
    super.key,
    this.opacity = 1,
    this.padding = EdgeInsets.zero,
    this.color = Colors.black,
    this.text = '',
    this.border = false,
    this.smallSize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding,
      height: (smallSize) ? 0 : 38.w,
      width: (smallSize) ? 0 : 38.w,
      decoration: BoxDecoration(
        color: color.withOpacity(opacity),
        border: border
            ? Border.all(color: CustomColor.gridBorderColor, width: 2.w)
            : null,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
