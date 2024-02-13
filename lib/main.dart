import 'package:drag_drop/final.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Game());
}

final List<Widget> widgetOptions = [];

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Game'),
        ),
        body: GameScreen(apiResonse: apiResonse),
      ),
    );
  }
}

Map<String, dynamic> apiResonse = {
  "grid": {"row_size": 5, "column_size": 5},
  "graph": {
    "nodes": [
      {
        "id": 1,
        "shape": {"name": "Rectangle", "height": 3, "width": 2}
      },
      {
        "id": 2,
        "shape": {"name": "Rectangle", "height": 2, "width": 2}
      },
      {
        "id": 3,
        "shape": {"name": "U-Shape", "height": 3, "width": 4}
      },
      {
        "id": 4,
        "shape": {"name": "T-Shape", "height": 2, "width": 1}
      }
    ],
    "edges": [
      [1, 2],
      [2, 3],
      [1, 4],
      [2, 4]
    ]
  }
};
