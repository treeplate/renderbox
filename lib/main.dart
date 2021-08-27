import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp(width: 20, height: 30, color: Colors.yellow));
}

class MyApp extends RenderObjectWidget {
  const MyApp({
    this.width,
    this.height,
    Key? key,
    this.color = const Color(0x00000000),
  }) : super(key: key);
  final double? width;
  final double? height;
  final Color color;
  @override
  RenderObjectElement createElement() {
    return MyElement(this);
  }

  @override
  RenderBox createRenderObject(BuildContext context) {
    return MyRenderBox(width, height, color);
  }
}

class MyRenderBox extends RenderBox {
  MyRenderBox(this.width, this.height, this.color);
  final double? width;
  final double? height;
  final Color color;
  late final Paint _color = Paint()..color = color;

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.drawRect(offset & size, _color);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return Size(
      max(
        min(
          constraints.biggest.width,
          width ?? double.infinity,
        ),
        constraints.smallest.width,
      ),
      max(
        min(
          constraints.biggest.height,
          height ?? double.infinity,
        ),
        constraints.smallest.height,
      ),
    );
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  bool get sizedByParent => false;
}

class MyElement extends RenderObjectElement {
  MyElement(RenderObjectWidget widget) : super(widget);
}
