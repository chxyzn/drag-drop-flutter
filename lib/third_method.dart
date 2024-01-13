import 'package:flutter/material.dart';

List<int> shape1 = [2, 1, 1];
List<int> shape2 = [0, 2, 1];
List<int> shape3 = [0, 0, 1];

class ThirdMethod extends StatefulWidget {
  const ThirdMethod({super.key});

  @override
  State<ThirdMethod> createState() => _ThirdMethodState();
}

class _ThirdMethodState extends State<ThirdMethod> {
  List<List<int>> matrix = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
  ];

  int modifyMatrix(List<List<int>> referenceMatrix) {
    List<MatrixCoords> updateCoords = [];
    bool canUpdate = true;
    for (int i = 0; i < referenceMatrix.length; i++) {
      for (int j = 0; j < referenceMatrix[i].length; j++) {
        if (referenceMatrix[i][j] == 1) {
          MatrixCoords coords = MatrixCoords(row: i, col: j);
          updateCoords.add(coords);
        }
      }
    }

    for (MatrixCoords coords in updateCoords) {
      if (matrix[coords.row][coords.col] == 1) {
        canUpdate = false;
        break;
      }
    }

    if (canUpdate) {
      for (MatrixCoords coords in updateCoords) {
        matrix[coords.row][coords.col]++;
      }
      setState(() {
        debugPrint('matrix updated');
        printMatrix();
      });
      return 0;
    }

    return 1;
  }

  void printMatrix() {
    for (int i = 0; i < matrix.length; i++) {
      debugPrint(matrix[i].toString());
    }
  }

  bool canModifyMatrix(MatrixCoords startCoords, List<int> shape) {
    bool canModify = true;
    int someting = 0;
    for (int i = 0; i < shape.length; i++) {
      try {
        for (int j = 0; j < shape[i]; j++) {
          if (matrix[startCoords.row + someting][startCoords.col + j] == 1) {
            canModify = false;
            break;
          }
        }
        if (shape[i] != 0) {
          someting++;
        }
      } on RangeError catch (e) {
        debugPrint('out of range canModifyMatrix');
        debugPrint(e.toString());

        return false;
      }
    }
    return canModify;
  }

  int modifyMatrixFromCoords(MatrixCoords startCoords, List<int> shape) {
    int something = 0;
    try {
      for (int i = 0; i < shape.length; i++) {
        for (int j = 0; j < shape[i]; j++) {
          matrix[startCoords.row + something][startCoords.col + j]++;
        }
        if (shape[i] != 0) {
          something++;
        }
      }
      setState(() {
        debugPrint('matrix updated');
        printMatrix();
      });
      checkForEndofGame();
    } on RangeError catch (e) {
      debugPrint('out of range modifyMatrixFromCoords');
      debugPrint(e.toString());
      return 1;
    }
    return 0;
  }

  void resetMatrix() {
    printMatrix();
    setState(() {
      matrix = [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ];
    });
  }

  void checkForEndofGame() {
    if (matrix.every((element) => element.every((element) => element == 1))) {
      debugPrint('Game Over');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Game Over',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
                  modifyMatrix: modifyMatrixFromCoords,
                  canModifyMatrix: canModifyMatrix,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 100,
        ),
        SizedBox(
          height: 200,
          width: 400,
          child: ListView(
            padding: const EdgeInsets.only(left: 16),
            scrollDirection: Axis.horizontal,
            children: [
              CustomDraggable(shape: shape1),
              const SizedBox(
                width: 20,
              ),
              CustomDraggable(shape: shape2),
              const SizedBox(
                width: 20,
              ),
              CustomDraggable(shape: shape3),
            ],
          ),
        ),
        const SizedBox(
          height: 100,
        ),
        ElevatedButton(
          onPressed: resetMatrix,
          child: const Text('Reset'),
        ),
      ],
    );
  }
}

class CustomDraggable extends StatelessWidget {
  final List<int> shape;
  const CustomDraggable({super.key, required this.shape});

  @override
  Widget build(BuildContext context) {
    return Draggable<List<int>>(
      data: shape,
      feedback: ShapeGenerator(shape: shape),
      childWhenDragging: const Block(),
      child: ShapeGenerator(shape: shape),
    );
  }
}

class ShapeGenerator extends StatelessWidget {
  final List<int> shape;

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
              for (int j = 0; j < shape[i]; j++) //row traversal
                const Block(),
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

class TargetBlockGenerator extends StatelessWidget {
  final Function modifyMatrix;
  final Function canModifyMatrix;
  const TargetBlockGenerator(
      {super.key, required this.modifyMatrix, required this.canModifyMatrix});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < 3; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int j = 0; j < 3; j++) //row traversal
                DragTarget<List<int>>(
                  onAccept: (List<int> matrix) {
                    debugPrint('--------------------------\n\n');
                    debugPrint('Target accepted at $i, $j');
                    debugPrint('Target data: $matrix');
                    if (canModifyMatrix(MatrixCoords(row: i, col: j), matrix)) {
                      modifyMatrix(MatrixCoords(row: i, col: j), matrix);
                      showSnackBar(context, 'Placed Successfully');
                    } else {
                      showSnackBar(context, 'Cannot Place at $i, $j');
                    }

                    debugPrint('\n\n--------------------------');
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
