// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'package:drag_drop/src/constants/Colors.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class GraphViewPage extends StatelessWidget {
  final bool isSolutionCorrect;
  final List<int> nodes;
  final String graphTheoryText;
  final List<List<int>> edges;
  const GraphViewPage({
    super.key,
    required this.isSolutionCorrect,
    required this.graphTheoryText,
    required this.nodes,
    required this.edges,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph View'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Center(
              child: Text(
                (isSolutionCorrect) ? 'Correct Solution' : 'Incorrect Solution',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: (isSolutionCorrect) ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              (isSolutionCorrect) ? graphTheoryText : "",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: GraphWidget(
              nodes: nodes,
              edges: edges,
            ),
          ),
        ],
      ),
    );
  }
}

class GraphWidget extends StatefulWidget {
  final List<int> nodes;
  final List<List<int>> edges;
  const GraphWidget({
    super.key,
    required this.nodes,
    required this.edges,
  });

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  final Graph graph = Graph();

  @override
  void initState() {
    super.initState();
    List<Node> graphNodes = widget.nodes.map((e) => Node.Id(e)).toList();

    widget.edges.forEach((edge) {
      int a = edge.first + 1;
      int b = edge.last + 1;
      int a_index;
      int b_index;

      a_index = widget.nodes.indexOf(a);
      b_index = widget.nodes.indexOf(b);

      if (a_index == -1 || b_index == -1) {
        print('=================');
        print(widget.nodes);
        print(a);
        print(b);
      }

      graph.addEdge(graphNodes[a_index], graphNodes[b_index]);
    });
    graph.isTree = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
                constrained: false,
                alignment: Alignment.center,
                boundaryMargin: EdgeInsets.all(10),
                minScale: 1,
                maxScale: 1,
                child: ClipRect(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: GraphView(
                      graph: graph,
                      animated: false,
                      algorithm: FruchtermanReingoldAlgorithm(),
                      paint: Paint()
                        ..color = Colors.green
                        ..strokeWidth = 1
                        ..style = PaintingStyle.stroke,
                      builder: (Node node) {
                        // I can decide what widget should be shown here based on the id
                        var a = node.key!.value as int?;
                        return circularNode(a);
                      },
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

Widget circularNode(int? i) {
  return Container(
    // height: 14.r,
    // width: 14.r,
    width: 35,
    height: 35,
    decoration: BoxDecoration(
      color: GraphColors().getColorFromId(i ?? 0),
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        '$i',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
