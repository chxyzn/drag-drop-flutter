import 'package:drag_drop/fourth_method.dart';
import 'package:drag_drop/game_logic.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final Map<String, dynamic> apiResonse;
  const GameScreen({super.key, required this.apiResonse});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<int>> baseMatrix;
  late int gridRowSize;
  late int gridColumnSize;
  late int maxGridLength;

  @override
  void initState() {
    gridRowSize = widget.apiResonse['grid']['row_size'];
    gridColumnSize = widget.apiResonse['grid']['column_size'];

    maxGridLength =
        gridRowSize >= gridColumnSize ? gridRowSize : gridColumnSize;

    baseMatrix = GameLogic().initBaseMatrix(
      gridRowSize,
      gridColumnSize,
    );
    super.initState();
  }

  void onBlockAccept(
    MatrixCoords touchdownCoords,
    List<List<int>> shapeMatrix,
  ) {
    bool canUpdate = true;
    int num1 = -1;
    int num2 = -1;
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
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Block Clashing!!!'),
              ));
              break;
            }
          } else {
            canUpdate = false;
            break;
          }
        }
      }
    }

    if (canUpdate) {
      setState(() {
        for (int x = 0; x < gridRowSize; x++) {
          for (int y = 0; y < gridColumnSize; y++) {
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

  @override
  Widget build(BuildContext context) {
    print(baseMatrix);
    print(gridRowSize);
    print(gridColumnSize);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Stack(
            children: [
              Center(
                child: SizedBox(
                  height: gridRowSize * 52,
                  width: gridColumnSize * 52,
                  child: Center(
                    child: BaseBlockGenerator(
                      matrix: baseMatrix,
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: gridRowSize * 52,
                  width: gridColumnSize * 52,
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
          const SizedBox(
            height: 50,
          ),
          BlockOptionsWidget(
            nodes: widget.apiResonse['graph']['nodes'],
          ),
        ],
      ),
    );
  }
}

class BlockOptionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> nodes;
  const BlockOptionsWidget({super.key, required this.nodes});

  List<List<int>> getShapeMatrix(Map<String, dynamic> node) {
    switch (node['shape']['name']) {
      case 'Rectangle':
        return GameLogic().rectangle(
          node['id'],
          node['shape']['height'],
          node['shape']['width'],
        );
      case 'U-Shape':
        return GameLogic().uShape(
          node['id'],
          node['shape']['height'],
          node['shape']['width'],
        );
      case 'T-Shape':
        return GameLogic().tShape(
          node['id'],
          node['shape']['height'],
          node['shape']['width'],
        );
      default:
        return GameLogic().lShape(
          node['id'],
          node['shape']['height'],
          node['shape']['width'],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (int i = 0; i < nodes.length; i++)
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: CustomDraggable(shape: getShapeMatrix(nodes[i])),
            )
        ],
      ),
    );
  }
}
