import 'package:drag_drop/first_method.dart';
import 'package:drag_drop/second_method.dart';
import 'package:drag_drop/third_method.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Game());
}

final List<Widget> widgetOptions = [
  const FirstMethod(),
  const SecondMethod(),
  const ThirdMethod(),
];

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Text(''),
              ),
              ListTile(
                title: const Text(
                  'Method 1',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  _scaffoldKey.currentState!.openEndDrawer();

                  setState(() {
                    selectedIndex = 0;
                  });
                },
              ),
              ListTile(
                title: const Text(
                  'Method 2',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  _scaffoldKey.currentState!.openEndDrawer();

                  setState(() {
                    selectedIndex = 1;
                  });
                },
              ),
              ListTile(
                title: const Text(
                  'Method 3',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  _scaffoldKey.currentState!.openEndDrawer();

                  setState(() {
                    selectedIndex = 2;
                  });
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('Game'),
        ),
        body: widgetOptions[selectedIndex],
      ),
    );
  }
}
