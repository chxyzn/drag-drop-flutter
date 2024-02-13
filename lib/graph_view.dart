// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls


import 'package:drag_drop/fourth_method.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class GraphViewPage extends StatelessWidget {
  final List<List<int>> baseMatrix;
  final List<int> nodes;
  final List<List<int>> edges;
  const GraphViewPage({
    super.key,
    required this.baseMatrix,
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
            height: 270,
            width: 270,
            child: Center(
              child: BaseBlockGenerator(
                matrix: baseMatrix,
              ),
            ),
          ),
          GraphWidget(
            nodes: nodes,
            edges: edges,
          ),
        ],
      ),
    );
  }
}

class GraphWidget extends StatefulWidget {
  final List<int> nodes;
  final List<List<int>> edges;
  const GraphWidget({super.key, required this.nodes, required this.edges});

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  final Graph graph = Graph();
  late Algorithm _algorithm;

  @override
  void initState() {
    super.initState();
    List<Node> graphNodes = widget.nodes.map((e) => Node.Id(e)).toList();
    widget.edges.forEach((edge) {
      int a = edge.first;
      int b = edge.last;
      int a_index = widget.nodes.indexOf(a);
      int b_index = widget.nodes.indexOf(b);
      graph.addEdge(graphNodes[a_index], graphNodes[b_index]);
    });

    _algorithm = FruchtermanReingoldAlgorithm(iterations: 1000);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 300,
        child: Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                constrained: false,
                boundaryMargin: const EdgeInsets.all(0),
                minScale: 0.001,
                maxScale: 100,
                child: GraphView(
                  graph: graph,
                  algorithm: _algorithm,
                  paint: Paint()
                    ..color = Colors.green
                    ..strokeWidth = 1
                    ..style = PaintingStyle.fill,
                  builder: (Node node) {
                    var a = node.key!.value as int?;

                    return circularNode(a);
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

Widget circularNode(int? i) {
  return Container(
    height: 43,
    width: 43,
    decoration: const ShapeDecoration(
      color: Color(0xFFFF956C),
      shape: OvalBorder(
        side: BorderSide(width: 4.2, color: Color(0xFFC6C5B2)),
      ),
    ),
    child: Center(
      child: Text(
        '$i',
        textAlign: TextAlign.center,
      ),
    ),
  );
}
