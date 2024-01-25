// ignore_for_file: avoid_print, constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';

const int MATRIX_SIZE = 3;

List<List<int>> shape2 = [
  [1, 0, 1],
  [1, 0, 1],
  [1, 1, 1]
];

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
    shape = generateRandomMatrix(rowSize: 3, coloumnSize: 3);
  }

  List<List<int>> matrix = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
  ];

  void resetMatrix() {
    setState(() {
      matrix = [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
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
              height: 180,
              width: 180,
              child: Center(
                child: BaseBlockGenerator(
                  matrix: matrix,
                ),
              ),
            ),
            SizedBox(
              height: 180,
              width: 180,
              child: Center(
                child: TargetBlockGenerator(
                  shape: matrix,
                  onAccept: updateBaseMatrix,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            CustomDraggable(
              shape: shape,
            ),
            CustomDraggable(
              shape: shape2,
            ),
          ],
        ),
        const SizedBox(height: 25),
        GestureDetector(
          onTap: () {
            shape = generateRandomMatrix(rowSize: 3, coloumnSize: 3);

            setState(() {});
          },
          child: Container(
            color: Colors.blue,
            height: 50,
            width: 100,
            child: const Center(
              child: Text('Randomise'),
            ),
          ),
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
              child: Text('Reset'),
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
    return Draggable<List<List<int>>>(
      data: shape,
      feedback: ShapeGenerator(shape: shape),
      childWhenDragging: const Block(),
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
                    ? const Block()
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
                ),
            ],
          )
      ],
    );
  }
}

class BaseBlock extends StatelessWidget {
  final int value;
  const BaseBlock({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      color: value == (1)
          ? const Color.fromARGB(255, 245, 146, 54)
          : const Color.fromRGBO(0, 255, 0, 0.4),
      // : const Color.fromARGB(255, 245, 146, 54).withOpacity(0.3),
    );
  }
}

class Block extends StatelessWidget {
  final double opacity;
  const Block({super.key, this.opacity = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
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
