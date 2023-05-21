import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_guide_render/ui/custom_column_widget.dart';
import 'package:flutter_guide_render/ui/custom_expanded_widget.dart';

import 'custom_box_widget.dart';

class FooWidget extends StatefulWidget {
  const FooWidget({super.key});

  @override
  State<FooWidget> createState() => _FooWidgetState();
}

class _FooWidgetState extends State<FooWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomColumnWidget(
      alignment: CustomColumnAlignment.center,
      children: [
        const CustomExpandedWidget(
          flex: 2,
          child: SizedBox(),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'A definitive guide to\n '
            'RendreObejext in Flutter',
            style: TextStyle(
              fontSize: 32,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'by CreativeCreatorOrMaybeNot',
          ),
        ),
        AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return CustomBoxWidget(
                flex: 3,
                color: const Color(0xafdf32a4),
                rotation: _controller.value * 2 * math.pi,
                onTap: () {
                  if (_controller.isAnimating) {
                    _controller.stop();
                  } else {
                    _controller.repeat();
                  }
                },
              );
            }),
      ],
    );
  }
}
