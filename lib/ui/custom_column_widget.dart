import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CustomColumnWidget extends MultiChildRenderObjectWidget {
  const CustomColumnWidget({super.key, super.children = const []});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomColumn();
  }
}

class CustomColumnParentData extends ContainerBoxParentData<RenderBox> {
  int? flex;
}

class RenderCustomColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomColumnParentData> {
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
      childParentData.offset = Offset(0, childOffset.dy);
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
