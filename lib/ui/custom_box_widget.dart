import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_guide_render/ui/custom_column_widget.dart';

class CustomBoxWidget extends LeafRenderObjectWidget {
  final int flex;
  final Color color;
  final double rotation;
  final VoidCallback? onTap;

  const CustomBoxWidget({
    super.key,
    required this.flex,
    required this.color,
    this.rotation = 0,
    this.onTap,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomBox(
      flex: flex,
      color: color,
      rotation: rotation,
      onTap: onTap,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderCustomBox renderObject) {
    renderObject
      ..flex = flex
      ..color = color
      ..rotation = rotation
      ..onTap = onTap;
  }
}

class RenderCustomBox extends RenderBox {
  int _flex;
  Color _color;
  double _rotation;
  VoidCallback? _onTap;

  RenderCustomBox({
    required int flex,
    required Color color,
    required double rotation,
    required VoidCallback? onTap,
  })  : assert(rotation <= 2 * math.pi && rotation >= 0),
        _flex = flex,
        _color = color,
        _rotation = rotation,
        _onTap = onTap;

  int get flex => _flex;
  set flex(int value) {
    assert(value >= 0);
    if (flex == value) {
      return;
    }

    _flex = value;
    parentData!.flex = _flex;
    markParentNeedsLayout();
  }

  Color get color => _color;
  set color(Color value) {
    if (color == value) {
      return;
    }

    _color = value;
    markNeedsPaint();
  }

  double get rotation => _rotation;
  set rotation(double value) {
    if (rotation == value) {
      return;
    }

    _rotation = value;
    markNeedsPaint();
  }

  VoidCallback? get onTap => _onTap;
  set onTap(VoidCallback? value) {
    if (_onTap == value) {
      return;
    }

    _onTap = value;
    _tapGestureRecognizer.onTap = value;
  }

  late final TapGestureRecognizer _tapGestureRecognizer;

  @override
  CustomColumnParentData? get parentData {
    if (super.parentData == null) {
      return null;
    }
    assert(
      super.parentData is CustomColumnParentData,
      '$CustomBoxWidget can only be a direct child of $CustomColumnWidget',
    );

    return super.parentData as CustomColumnParentData;
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);

    parentData!.flex = flex;
    _tapGestureRecognizer = TapGestureRecognizer(debugOwner: this)
      ..onTap = onTap;
  }

  @override
  void detach() {
    _tapGestureRecognizer.dispose();
    super.detach();
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  bool hitTestSelf(Offset position) {
    return size.contains(position);
  }

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));

    if (event is PointerDownEvent) {
      _tapGestureRecognizer.addPointer(event);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    canvas.save();
    canvas.drawRect(offset & size, Paint()..color = color);

    final smallRectWith = size.shortestSide / (3 - math.sin(rotation));

    canvas.translate(offset.dx + size.width / 2, offset.dy + size.height / 2);
    canvas.rotate(rotation);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: smallRectWith,
        height: smallRectWith,
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = const Color(0xff6a45df),
    );
    canvas.restore();
  }
}
