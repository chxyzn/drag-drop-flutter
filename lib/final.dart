import 'package:drag_drop/fourth_method.dart';
import 'package:drag_drop/game_logic.dart';
import 'package:drag_drop/graph_view.dart';
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

  void resetBaseMatrix() {
    setState(() {
      baseMatrix = GameLogic().initBaseMatrix(
        gridRowSize,
        gridColumnSize,
      );
    });
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
        for (int i = 0; i < gridRowSize; i++) {}
      });
    } else {
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

  bool isSolutionCorrect(List<List<int>> inputEdges) {
    List<List<int>> correctEdges = widget.apiResonse['graph']['edges'];
    if (inputEdges.length != correctEdges.length) {
      return false;
    }
    for (int i = 0; i < inputEdges.length; i++) {
      for (int j = 0; j < correctEdges.length; j++) {
        if (inputEdges[i][0] == correctEdges[j][0] &&
            inputEdges[i][1] == correctEdges[j][1]) {
          break;
        }
        if (j == correctEdges.length - 1) {
          return false;
        }
      }
    }
    return true;
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
            maxGridLength: maxGridLength,
            nodes: widget.apiResonse['graph']['nodes'],
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  resetBaseMatrix();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  color: Colors.red,
                  child: const Center(
                    child: Text('Reset'),
                  ),
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              GestureDetector(
                onTap: () {
                  List<List<int>> edges = removeDuplicates(getAdjacentEdges());

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
                        isSolutionCorrect: isSolutionCorrect(edges),
                        nodes: nodes,
                        edges: edges,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: 50,
                  color: Colors.green,
                  child: const Center(
                    child: Text('Graph View'),
                  ),
                ),
              ),
            ],
          )
        ],
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
    switch (node['shape']['name']) {
      case 'Rectangle':
        return GameLogic().rectangle(
          node['id'],
          node['shape']['height'],
          node['shape']['width'],
          maxGridLength,
        );
      case 'U-Shape':
        return GameLogic().uShape(
          node['id'],
          node['shape']['height'],
          node['shape']['width'],
          maxGridLength,
        );
      case 'T-Shape':
        return GameLogic().tShape(
          node['id'],
          node['shape']['height'],
          node['shape']['width'],
          maxGridLength,
        );
      default:
        return GameLogic().lShape(
          node['id'],
          node['shape']['height'],
          node['shape']['width'],
          maxGridLength,
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
