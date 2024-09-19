import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/game.dart';
import 'package:drag_drop/src/game/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameLogic {
  List<List<int>> initBaseMatrix(int rowSize, int columnSize) {
    List<List<int>> baseMatrix = [];

    for (int i = 0; i < rowSize; i++) {
      List<int> row = List<int>.generate(columnSize, (index) {
        return 0;
      });
      baseMatrix.add(row);
    }

    return baseMatrix;
  }
}

MatrixCoords pickupCoords = const MatrixCoords(row: 0, col: 0);

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
                  onAcceptWithDetails:
                      (DragTargetDetails<List<List<int>>>? data) {
                    onAccept(MatrixCoords(row: i, col: j), data!.data);
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
}

class ShapeGenerator extends StatelessWidget {
  final List<List<int>> shape;
  final Color color;
  final String text;
  final bool compressed;
  const ShapeGenerator({
    super.key,
    required this.shape,
    required this.color,
    this.compressed = false,
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
                    : (shape[i][j] == -1)
                        ? Block(
                            opacity: 0,
                            smallSize: true,
                          )
                        : Block(
                            opacity: 0,
                            smallSize: compressed,
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
      height: GameConstants.blockSize,
      width: GameConstants.blockSize,
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
      height: (smallSize) ? 0 : GameConstants.blockSize,
      width: (smallSize) ? 0 : GameConstants.blockSize,
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
