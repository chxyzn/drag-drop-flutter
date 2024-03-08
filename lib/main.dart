import 'package:drag_drop/final.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Game());
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

final List<Widget> widgetOptions = [];

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Map<String, dynamic> currentLevel;

  @override
  void initState() {
    currentLevel = level1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        key: _scaffoldKey,
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Text(
                      'Levels',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Level 1'),
                  onTap: () {
                    setState(() {
                      currentLevel = level1;
                    });
                  },
                ),
                ListTile(
                  title: const Text('Level 2'),
                  onTap: () {
                    print('Level 2');
                    print(level2['grid']);
                    setState(() {
                      currentLevel = level2;
                    });
                  },
                ),
                ListTile(
                  title: const Text('Level 3'),
                  onTap: () {
                    print('Level 3');
                    setState(() {
                      currentLevel = level3;
                    });
                  },
                ),
                ListTile(
                  title: const Text('Level 4'),
                  onTap: () {
                    print('Level 4');
                    setState(() {
                      currentLevel = level4;
                    });
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: const Text('Game'),
          ),
          body:
              GameScreen(key: ValueKey(currentLevel), apiResonse: currentLevel),
        ),
      ),
    );
  }
}

Map<String, dynamic> level1 = {
  "grid": {"row_size": 5, "column_size": 5},
  "graph": {
    "nodes": [
      {
        "id": 1,
        "shape": {"name": "Rectangle", "height": 3, "width": 2}
      },
      {
        "id": 2,
        "shape": {"name": "Rectangle", "height": 5, "width": 2}
      },
      {
        "id": 3,
        "shape": {"name": "Rectangle", "height": 1, "width": 2}
      },
      {
        "id": 4,
        "shape": {"name": "Rectangle", "height": 1, "width": 2}
      },
      {
        "id": 5,
        "shape": {"name": "Rectangle", "height": 5, "width": 1}
      },
    ],
    "edges": [
      [1, 2],
      [1, 3],
      [1, 4],
      [2, 3],
      [2, 4],
      [2, 5],
    ]
  }
};

Map<String, dynamic> level2 = {
  "grid": {"row_size": 5, "column_size": 5},
  "graph": {
    "nodes": [
      {
        "id": 1,
        "shape": {"name": "Rectangle", "height": 2, "width": 4}
      },
      {
        "id": 2,
        "shape": {"name": "Rectangle", "height": 2, "width": 2}
      },
      {
        "id": 3,
        "shape": {"name": "Rectangle", "height": 3, "width": 1}
      },
      {
        "id": 4,
        "shape": {"name": "Rectangle", "height": 3, "width": 2}
      },
      {
        "id": 5,
        "shape": {"name": "Rectangle", "height": 3, "width": 1}
      },
    ],
    "edges": [
      [1, 3],
      [1, 4],
      [1, 5],
      [2, 3],
      [4, 5],
      [2, 4]
    ]
  }
};

Map<String, dynamic> level3 = {
  "grid": {"row_size": 5, "column_size": 5},
  "graph": {
    "nodes": [
      {
        "id": 1,
        "shape": {"name": "Rectangle", "height": 1, "width": 1}
      },
      {
        "id": 2,
        "shape": {"name": "Rectangle", "height": 1, "width": 2}
      },
      {
        "id": 3,
        "shape": {"name": "Rectangle", "height": 1, "width": 3}
      },
      {
        "id": 4,
        "shape": {"name": "Rectangle", "height": 4, "width": 4}
      },
      {
        "id": 5,
        "shape": {"name": "Rectangle", "height": 3, "width": 1}
      },
    ],
    "edges": [
      [1, 4],
      [1, 5],
      [2, 3],
      [2, 4],
      [3, 4],
      [3, 5],
      [4, 5],
    ]
  }
};

Map<String, dynamic> level4 = {
  "grid": {"row_size": 5, "column_size": 5},
  "graph": {
    "nodes": [
      {
        "id": 1,
        "shape": {"name": "Rectangle", "height": 5, "width": 2}
      },
      {
        "id": 2,
        "shape": {"name": "Rectangle", "height": 3, "width": 1}
      },
      {
        "id": 3,
        "shape": {"name": "Rectangle", "height": 2, "width": 1}
      },
      {
        "id": 4,
        "shape": {"name": "Rectangle", "height": 5, "width": 1}
      },
      {
        "id": 5,
        "shape": {"name": "Rectangle", "height": 5, "width": 1}
      },
    ],
    "edges": [
      [1, 2],
      [1, 3],
      [1, 4],
      [2, 3],
      [4, 5],
    ]
  }
};
