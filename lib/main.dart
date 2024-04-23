import 'package:drag_drop/src/constants/levels.dart';
import 'package:drag_drop/src/game/game_result_screen.dart';
import 'package:drag_drop/src/game/game_screen.dart';

import 'package:drag_drop/src/levels/level_start_screen.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

//this widget will handle whether to show login screen or home screen
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      child: MaterialApp(home: GameResultScreen()),
    );
  }
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Map<String, dynamic> currentLevel;
  int level = 1;

  @override
  void initState() {
    currentLevel = levels.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
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
                for (var i = 0; i < levels.length; i++)
                  ListTile(
                    title: Text('Level ${i + 1}'),
                    onTap: () {
                      setState(() {
                        currentLevel = levels[i];
                        level = i + 1;
                      });
                    },
                  ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text('Level $level'),
          ),
          body: GameScreen(
            key: ValueKey(currentLevel),
            apiResonse: currentLevel,
          ),
        ),
      ),
    );
  }
}
