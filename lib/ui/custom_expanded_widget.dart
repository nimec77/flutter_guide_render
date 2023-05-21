import 'package:flutter/widgets.dart';

import 'custom_column_widget.dart';

class CustomExpandedWidget extends ParentDataWidget<CustomColumnParentData> {
  final int flex;

  const CustomExpandedWidget({
    super.key,
    required super.child,
    this.flex = 1,
  }) : assert(flex > 0);

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData as CustomColumnParentData;

    if (parentData.flex != flex) {
      parentData.flex = flex;
      final targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => CustomColumnWidget;
}
