import 'dart:math';

import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';

class DotIndicator extends AnimatedWidget {

  DotIndicator({
    required this.controller,
    required this.itemCount,
    this.color = Colors.primaryColor,

  }) : super(listenable: controller);

  final PageController controller;

  final int itemCount;

  final Color color;// = Colors.primaryColor;

  Widget _buildDot(int index) {
    num selectedPage = controller.page ?? controller.initialPage;

    double selectedness = Curves.easeOut.transform(
      max(0.0, 1.0 - (selectedPage - index).abs()),
    );

    double zoom = 1.0 + (2.0 - 1.0) * selectedness;

    return Container(
      width: 12 * zoom,
      height: 4,
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
      decoration: BoxDecoration(
        color: (selectedPage == index) ? this.color : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        shape: BoxShape.rectangle
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(this.itemCount, _buildDot),
    );
  }

}
