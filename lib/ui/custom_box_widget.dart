import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_guide_render/ui/custom_column_widget.dart';

class CustomBoxWidget extends LeafRenderObjectWidget {
  final int flex;
  final Color color;

  const CustomBoxWidget({
    super.key,
    required this.flex,
    required this.color,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomBox(flex: flex, color: color);
  }
}

class RenderCustomBox extends RenderBox {
  int _flex;
  Color _color;

  RenderCustomBox({
    required flex,
    required color,
  })  : _flex = flex,
        _color = color;

  int get flex => _flex;

  Color get color => _color;

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
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }
}
