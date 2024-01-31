// ignore_for_file: avoid_print, constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';

const int MATRIX_SIZE = 5;
MatrixCoords pickupCoords = const MatrixCoords(row: 0, col: 0);

List<List<int>> shape2 = [
  [0, 0, 0, 0, 0],
  [0, 1, 1, 0, 0],
  [0, 1, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0]
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
  late List<List<int>> shape;
  @override
  void initState() {
    super.initState();
    shape = generateRandomMatrix(rowSize: 5, coloumnSize: 5);
  }

  List<List<int>> matrix = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
  ];

  void resetMatrix() {
    setState(() {
      matrix = [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
      ];
    });
  }

  MatrixCoords findStartCoords(List<List<int>> shape) {
    int row = 0;
    int col = 0;
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        if (shape[i][j] == 1) {
          row = i;
          col = j;
          return MatrixCoords(row: row, col: col);
        }
      }
    }
    return MatrixCoords(row: row, col: col);
  }

  void updateBaseMatrixNew(
    MatrixCoords touchdownCoords,
    List<List<int>> shapeMatrix,
  ) {
    bool canUpdate = true;
    int num1 = -1;
    int num2 = -1;
    for (int x = 0; x < MATRIX_SIZE; x++) {
      for (int y = 0; y < MATRIX_SIZE; y++) {
        if (shapeMatrix[x][y] == 1) {
          num1 = x + touchdownCoords.row - pickupCoords.row;
          num2 = y + touchdownCoords.col - pickupCoords.col;
          if (num1 >= 0 &&
              num1 < MATRIX_SIZE &&
              num2 >= 0 &&
              num2 < MATRIX_SIZE) {
            if (matrix[num1][num2] == 1) {
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
            if (shapeMatrix[x][y] == 1) {
              matrix[x + touchdownCoords.row - pickupCoords.row]
                  [y + touchdownCoords.col - pickupCoords.col] = 1;
            }
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.red, content: Text('Error')));
    }
  }

  void updateBaseMatrix(MatrixCoords touchdownCoords, List<List<int>> data) {
    setState(() {
      MatrixCoords startCoords = findStartCoords(data);
      //traverse through data martrix starting from start coodrds
      int i = startCoords.row;
      int j = startCoords.col;

      print('-------------------------');
      print('Start coords: ${startCoords.row}, ${startCoords.col}');
      print('Touchdown coords: ${touchdownCoords.row}, ${touchdownCoords.col}');

      printShape(data, 'data');

      int touchDownCol = touchdownCoords.col;

      int counter = 0;
      int counter2 = 0;
      try {
        for (i; i < MATRIX_SIZE; i++) {
          for (j; j < MATRIX_SIZE; j++) {
            if (data[i][j] == 1) {
              print('$i, $j == 1');
              print('counter: $counter');
              print('counter2: $counter2');
              matrix[touchdownCoords.row + counter2][touchDownCol + counter] =
                  1;
            }
            counter++;
          }
          j = 0;
          counter = 0;
          counter2++;
          touchDownCol = 0;
        }
      } on RangeError {
        print('Out of bounds');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Out of bounds'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
          ),
        );
      }

      print('After update');
      printShape(matrix, 'matrix');
    });
  }

  List<List<int>> generateRandomMatrix(
      {required int rowSize, required int coloumnSize}) {
    List<List<int>> returnMatrix = [];
    returnMatrix = List.generate(
        coloumnSize, (index) => List.generate(rowSize, (index) => -1));

    for (int i = 0; i < coloumnSize; i++) {
      for (int j = 0; j < rowSize; j++) {
        returnMatrix[i][j] = Random().nextInt(2);
      }
    }
    return returnMatrix;
  }

  void printShape(List<List<int>> shape, String? identifier) {
    for (int i = 0; i < shape.length; i++) {
      print('printing ${identifier ?? 'shape'}: ${shape[i]} \t\t\t $i');
    }
  }

  List<List<int>> generate3x3In5x5Matrix() {
    List<List<int>> returnMatrix =
        List.generate(5, (index) => List.generate(5, (index) => 0));

    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        returnMatrix[i][j] = Random().nextInt(2);
      }
    }
    return returnMatrix;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  matrix: matrix,
                ),
              ),
            ),
            SizedBox(
              height: 270,
              width: 270,
              child: Center(
                child: TargetBlockGenerator(
                  shape: matrix,
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
                  shape: shape2,
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
                shape = generateRandomMatrix(rowSize: 5, coloumnSize: 5);

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
            GestureDetector(
              onTap: () {
                shape2 = generate3x3In5x5Matrix();

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
          ],
        ),
        const SizedBox(height: 25),
        GestureDetector(
          onTap: () {
            resetMatrix();
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
      ],
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

class CustomDraggable extends StatelessWidget {
  final List<List<int>> shape;
  const CustomDraggable({super.key, required this.shape});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<List<List<int>>>(
      data: shape,
      feedback: ShapeGenerator(shape: shape),
      childWhenDragging: SizedBox(
        height: 50 * MATRIX_SIZE.toDouble(),
        width: 50 * MATRIX_SIZE.toDouble(),
      ),
      child: ShapeGenerator(shape: shape),
    );
  }
}

class ShapeGenerator extends StatelessWidget {
  final List<List<int>> shape;
  const ShapeGenerator({super.key, required this.shape});

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
                (shape[i][j] == 1)
                    ? GestureDetector(
                        onTapUp: (_) {
                          print('onTapUp picked shape at $i, $j');
                        },
                        onTapDown: (_) {
                          print('onTapDown picked shape at $i, $j');
                          pickupCoords = MatrixCoords(row: i, col: j);
                        },
                        // onForcePressStart: (_) {
                        //   print('picked shape at $i, $j');
                        // },
                        // onPanStart: (_) {
                        //   print('onPanStart picked shape at $i, $j');
                        // },
                        // onPanUpdate: (_) {
                        //   print('onPanUpdate picked shape at $i, $j');
                        // },
                        // onTertiaryLongPressStart: (_) {
                        //   print(
                        //       'onTertiaryLongPressStart picked shape at $i, $j');
                        // },
                        // onTap: () {
                        //   print('onTap picked shape at $i, $j');
                        // },
                        child: const Block(),
                      )
                    : const Block(
                        opacity: 0,
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
                  padding: EdgeInsets.all(1),
                ),
            ],
          )
      ],
    );
  }
}

class BaseBlock extends StatelessWidget {
  final int value;
  final EdgeInsets padding;
  const BaseBlock(
      {super.key, required this.value, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      margin: padding,
      color: value == (1)
          ? const Color.fromARGB(255, 245, 146, 54)
          : const Color.fromRGBO(0, 255, 0, 0.4),
      // : const Color.fromARGB(255, 245, 146, 54).withOpacity(0.3),
    );
  }
}

class Block extends StatelessWidget {
  final double opacity;
  final EdgeInsets padding;
  const Block({super.key, this.opacity = 1, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding,
      height: 50,
      width: 50,
      color: Colors.black.withOpacity(opacity),
    );
  }
}

class MatrixCoords {
  final int row;
  final int col;
  const MatrixCoords({required this.row, required this.col});
}
