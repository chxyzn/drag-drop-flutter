import 'package:flutter/material.dart';

List<List<int>> shape1 = [
  [1, 1, 1],
  [1, 0, 0],
  [1, 0, 0]
];
List<List<int>> shape2 = [
  [0, 0, 0],
  [0, 1, 1],
  [0, 1, 0],
];
List<List<int>> shape3 = [
  [0, 0, 0],
  [0, 0, 0],
  [0, 0, 1],
];

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

  bool canModifyMatrix(MatrixCoords startCoords, List<List<int>> shape) {
    bool canModify = true;
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        if (shape[i][j] == 1) {
          try {
            if (matrix[startCoords.row + i][startCoords.col + j] == 1) {
              canModify = false;
              break;
            }
          } on RangeError {
            canModify = false;
            break;
          }
        }
      }
    }
    return canModify;
  }

  int modifyMatrixFromCoords(MatrixCoords startCoords, List<List<int>> shape) {
    try {
      for (int i = startCoords.row; i < matrix.length; i++) {
        for (int j = startCoords.col; j < matrix[i].length; j++) {
          matrix[i][j]++;
        }
      }
    } on RangeError {
      debugPrint('out of range');
      return 1;
    }
    return 0;
  }

  void resetMatrix() {
    setState(() {
      matrix = [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  modifyMatrix: modifyMatrix,
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
              CustomDragTarget(shape: shape1),
              const SizedBox(
                width: 20,
              ),
              CustomDragTarget(shape: shape2),
              const SizedBox(
                width: 20,
              ),
              CustomDragTarget(shape: shape3),
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

class CustomDragTarget extends StatelessWidget {
  final List<List<int>> shape;
  const CustomDragTarget({super.key, required this.shape});

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
                shape[i][j] == 1 ? const Block() : const SizedBox.shrink(),
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
                DragTarget<List<List<int>>>(
                  onAccept: (List<List<int>> matrix) {
                    debugPrint('--------------------------\n\n');
                    debugPrint('Target accepted at $i, $j');
                    if (canModifyMatrix(MatrixCoords(row: i, col: j), matrix)) {
                      int val = modifyMatrix(matrix);
                      showSnackbar(val, context);
                    } else {
                      debugPrint('cannot modify');
                    }

                    debugPrint('\n\n--------------------------');
                  },
                  builder: (context, candidates, rejects) {
                    return const Block();
                  },
                ),
            ],
          ),
      ],
    );
  }

  void showSnackbar(int val, BuildContext context) {
    if (val == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correct!'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
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
      color: Colors.black.withOpacity(0.7),
    );
  }
}

class MatrixCoords {
  final int row;
  final int col;
  const MatrixCoords({required this.row, required this.col});
}
