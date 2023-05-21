import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

enum CustomColumnAlignment {
  start,
  end,
  center,
}

class CustomColumnWidget extends MultiChildRenderObjectWidget {
  final CustomColumnAlignment alignment;

  const CustomColumnWidget({
    super.key,
    super.children = const [],
    this.alignment = CustomColumnAlignment.center,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomColumn(alignment: alignment);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCustomColumn renderObject) {
    renderObject.alignment = alignment;
  }
}

class CustomColumnParentData extends ContainerBoxParentData<RenderBox> {
  int? flex;
}

class RenderCustomColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomColumnParentData> {
  RenderCustomColumn({
    required CustomColumnAlignment alignment,
  }) : _alignment = alignment;

  CustomColumnAlignment _alignment;

  CustomColumnAlignment get alignment => _alignment;
  set alignment(CustomColumnAlignment value) {
    if (alignment == value) {
      return;
    }

    _alignment = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! CustomColumnParentData) {
      child.parentData = CustomColumnParentData();
    }
  }

  @override
  void performLayout() {
    size = _performLayout(constraints: constraints, dry: false);

    var child = firstChild;
    var childOffset = const Offset(0, 0);
    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      final dx = switch (alignment) {
        CustomColumnAlignment.start => 0.0,
        CustomColumnAlignment.end => size.width - child.size.width,
        CustomColumnAlignment.center => (size.width - child.size.width) / 2,
      };
      childParentData.offset = Offset(dx, childOffset.dy);
      childOffset += Offset(0, child.size.height);

      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _performLayout(constraints: constraints, dry: true);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    var height = 0.0;

    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      height += child.getMinIntrinsicHeight(width);

      child = childParentData.nextSibling;
    }

    return height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    var height = 0.0;

    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      height += child.getMaxIntrinsicHeight(width);

      child = childParentData.nextSibling;
    }

    return height;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    var width = 0.0;

    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      width = math.max(width, child.getMinIntrinsicWidth(height));

      child = childParentData.nextSibling;
    }

    return width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    var width = 0.0;

    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      width = math.max(width, child.getMaxIntrinsicWidth(height));

      child = childParentData.nextSibling;
    }

    return width;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToFirstActualBaseline(baseline);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  Size _performLayout({
    required BoxConstraints constraints,
    required bool dry,
  }) {
    var width = 0.0;
    var height = 0.0;
    var totalFlex = 0;
    RenderBox? lastFlexChild;

    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      final flex = childParentData.flex ?? 0;

      if (flex > 0) {
        totalFlex += flex;
        lastFlexChild = child;
      } else {
        late final Size childSize;
        if (!dry) {
          child.layout(
            BoxConstraints(maxWidth: constraints.maxWidth),
            parentUsesSize: true,
          );
          childSize = child.size;
        } else {
          childSize = child.getDryLayout(
            BoxConstraints(maxWidth: constraints.maxWidth),
          );
        }
        height += childSize.height;
        width = math.max(width, childSize.width);
      }
      child = childParentData.nextSibling;
    }

    final flexHeight = (constraints.maxHeight - height) / totalFlex;
    child = lastFlexChild;
    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      final flex = childParentData.flex ?? 0;

      if (flex > 0) {
        final childHeight = flexHeight * flex;
        late final Size childSize;
        if (!dry) {
          child.layout(
            BoxConstraints(
              minHeight: childHeight,
              maxHeight: childHeight,
              maxWidth: constraints.maxWidth,
            ),
            parentUsesSize: true,
          );
          childSize = child.size;
        } else {
          childSize = child.getDryLayout(
            BoxConstraints(
              minHeight: childHeight,
              maxHeight: childHeight,
              maxWidth: constraints.maxWidth,
            ),
          );
        }
        height += childSize.height;
        width = math.max(width, childSize.width);
      }

      child = childParentData.previousSibling;
    }

    return Size(width, height);
  }
}
