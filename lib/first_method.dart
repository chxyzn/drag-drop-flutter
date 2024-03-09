import 'package:flutter/material.dart';

List<int> shape = [2, 1, 1];

class FirstMethod extends StatefulWidget {
  const FirstMethod({super.key});

  @override
  State<FirstMethod> createState() => _FirstMethodState();
}

class _FirstMethodState extends State<FirstMethod> {
  late int random;

  @override
  void initState() {
    random = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
        ),
        DraggingObject(
          shape: shape,
        ),
         AcceptingGrid(
          key: ValueKey(random),
        ),
        //create a reset button
        ElevatedButton(
          onPressed: () {
            setState(() {
              random++;
            });
          },
          child: const Text('Reset'),
        ),
      ],
    );
  }
}

class DraggingObject extends StatelessWidget {
  final List<int> shape;
  const DraggingObject({super.key, required this.shape});

  int getHeight() {
    int height = 0;
    for (int i = 0; i < shape.length; i++) {
      if (shape[i] != 0) {
        height += 50;
      }
    }
    return height;
  }

  int getWidth() {
    int maxElement = 0;
    for (int i = 0; i < shape.length; i++) {
      if (shape[i] > maxElement) {
        maxElement = shape[i];
      }
    }
    return maxElement * 50;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getHeight().toDouble(),
      width: getWidth().toDouble(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (int i = 0; i < shape.length; i++)
            if (shape[i] != 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (int j = 0; j < shape[i]; j++) const Block(),
                ],
              )
        ],
      ),
    );
  }
}

class AcceptingGrid extends StatelessWidget {
  const AcceptingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < 3; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int j = 0; j < 3; j++) const BlockAcceptor(),
              ],
            )
        ],
      ),
    );
  }
}

class Block extends StatelessWidget {
  const Block({super.key});

  @override
  Widget build(BuildContext context) {
    return Draggable(
      maxSimultaneousDrags: 3,
      data: 1,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DraggingObject(shape: shape),
          ],
        ),
      ),
      child: Container(
        color: Colors.black,
        height: 50,
        width: 50,
      ),
    );
  }
}

class BlockAcceptor extends StatefulWidget {
  const BlockAcceptor({super.key});

  @override
  State<BlockAcceptor> createState() => _BlockAcceptorState();
}

class _BlockAcceptorState extends State<BlockAcceptor> {
  bool showFilledBlock = false;
  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onAccept: (data) {
        setState(() {
          showFilledBlock = true;
        });
      },
      builder: (context, c, r) {
        if (showFilledBlock) {
          return Container(
            color: const Color.fromARGB(255, 0, 0, 0),
            height: 50,
            width: 50,
          );
        }
        return Container(
          color: (c.isEmpty)
              ? Colors.black.withOpacity(0.2)
              : Colors.black.withOpacity(0.5),
          height: 50,
          width: 50,
        );
      },
    );
  }
}
