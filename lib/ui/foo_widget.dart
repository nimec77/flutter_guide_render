import 'package:flutter/material.dart';
import 'package:flutter_guide_render/ui/custom_column_widget.dart';
import 'package:flutter_guide_render/ui/custom_expanded_widget.dart';

import 'custom_box_widget.dart';

class FooWidget extends StatefulWidget {
  const FooWidget({super.key});

  @override
  State<FooWidget> createState() => _FooWidgetState();
}

class _FooWidgetState extends State<FooWidget> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return const CustomColumnWidget(
      alignment: CustomColumnAlignment.center,
      children: [
        CustomExpandedWidget(
          flex: 2,
          child: SizedBox(),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'A definitive guide to\n '
            'RendreObejext in Flutter',
            style: TextStyle(
              fontSize: 32,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'by CreativeCreatorOrMaybeNot',
          ),
        ),
        CustomBoxWidget(
          flex: 3,
          color: Color(0xafdf32a4),
        ),
      ],
    );
  }
}
