import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(
    const BoxPositioner(
      MyBox(
        width: 60,
        height: 50,
        color: Colors.yellow,
      ),
      Offset(0, 0),
    ),
  );
}

/// Box Positioner:
/// This widget is like a [Positioned], but takes the position as an [Offset] instead of a left-top-bottom-right-choose-two.

class BoxPositioner extends RenderObjectWidget {
  final RenderObjectWidget child;
  final Offset offset;
  const BoxPositioner(this.child, this.offset, {Key? key}) : super(key: key);

  @override
  RenderObjectElement createElement() {
    return MyBPElement(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return BoxPositionerRenderObject(
      child.createRenderObject(context) as RenderBox?,
      offset,
    );
  }
}

class BoxPositionerRenderObject extends RenderShiftedBox {
  final Offset offset;

  BoxPositionerRenderObject(RenderBox? child, this.offset) : super(child);
  @override
  bool sizedByParent = true;
  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  void performLayout() {
    Size childSize = getDryLayout(BoxConstraints.loose(constraints.biggest));
    if (childSize.isEmpty) childSize = constraints.biggest;
    child!.layout(BoxConstraints.loose(childSize));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child!, offset + this.offset);
  }
}

class MyBPElement extends RenderObjectElement {
  MyBPElement(RenderObjectWidget widget) : super(widget);
}

/// MyBox:
/// This is a [RenderObjectWidget] version of what is basically a [SizedBox]/[ColoredBox] combo, or a primitive [Container].

class MyBox extends RenderObjectWidget {
  const MyBox({
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
    return MyBoxElement(this);
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

class MyBoxElement extends RenderObjectElement {
  MyBoxElement(RenderObjectWidget widget) : super(widget);
}
