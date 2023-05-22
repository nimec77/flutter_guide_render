import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CustomProxyWidget extends SingleChildRenderObjectWidget {
  const CustomProxyWidget({super.key, required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RendomCustomProxy();
  }
}

class RendomCustomProxy extends RenderProxyBox {
  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    canvas.saveLayer(
      offset & size,
      Paint()..color = const Color(0x3f000000),
    );
    context.paintChild(child!, offset);
    canvas.restore();
  }
}
