import 'dart:math';

import 'package:flutter/material.dart';

class SecondMethod extends StatefulWidget {
  const SecondMethod({Key? key}) : super(key: key);

  @override
  SecondMethodState createState() => SecondMethodState();
}

class SecondMethodState extends State<SecondMethod> {
  List<int> shape1 = [2, 1, 1];
  List<int> shape2 = [0, 1, 1];
  List<int> shape3 = [1, 1, 1];

  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 60,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomDraggable(shape: shape1),
            CustomDraggable(shape: shape2),
            CustomDraggable(shape: shape3),
          ],
        ),
        const SizedBox(
          height: 90,
        ),
        SizedBox(
          width: 155,
          height: 150,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: CustomTarget(
                  key: ValueKey(value),
                  shape: shape1,
                ),
              ),
              Positioned(
                top: 50,
                left: 50,
                child: CustomTarget(
                  key: ValueKey(value),
                  shape: shape2,
                ),
              ),
              Positioned(
                left: 100,
                child: CustomTarget(
                  key: ValueKey(value),
                  shape: shape3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 90,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Random random = Random();
              setState(() {
                value++;
                // shape1 = [random.nextInt(3), random.nextInt(3), random.nextInt(3)];
                // shape2 = [random.nextInt(3), random.nextInt(3), random.nextInt(3)];
                // shape3 = [random.nextInt(3), random.nextInt(3), random.nextInt(3)];
              });
            },
            child: const Text('Reset'),
          ),
        ),
      ],
    );
  }
}

class CustomDraggable extends StatelessWidget {
  final List<int> shape;
  const CustomDraggable({super.key, required this.shape});

  @override
  Widget build(BuildContext context) {
    return Draggable<List<int>>(
      data: shape,
      feedback: BlockGenerator(shape: shape),
      child: BlockGenerator(shape: shape),
    );
  }
}

class CustomTarget extends StatefulWidget {
  final List<int> shape;
  const CustomTarget({super.key, required this.shape});

  @override
  State<CustomTarget> createState() => _CustomTargetState();
}

class _CustomTargetState extends State<CustomTarget> {
  bool accepted = false;
  @override
  Widget build(BuildContext context) {
    return DragTarget<List<int>>(
      builder: (context, c, r) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: BlockGenerator(
            shape: widget.shape,
            opacity: accepted ? 1 : 0.2,
          ),
        );
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (data) {
        print('this is the data received $data');
        if (data == widget.shape) {
          setState(() {
            accepted = true;
          });
          // showSnackBarGlobal(context, 'Correct!');
        } else {
          // showSnackBarGlobal(context, 'Incorrect!');
        }
      },
    );
  }
}

class BlockGenerator extends StatelessWidget {
  final double opacity;
  const BlockGenerator({
    super.key,
    required this.shape,
    this.opacity = 1,
  });

  final List<int> shape;

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
              for (int j = 0; j < shape[i]; j++)
                Block(
                  opacity: opacity,
                ),
            ],
          )
      ],
    );
  }
}

class Block extends StatelessWidget {
  final double opacity;
  const Block({super.key, this.opacity = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      color: Colors.black.withOpacity(opacity),
    );
  }
}
