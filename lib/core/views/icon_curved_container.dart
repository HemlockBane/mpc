import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconCurvedContainer extends StatelessWidget {

  IconCurvedContainer({
    this.width,
    this.height,
    required this.backgroundColor,
    required this.image,
    this.padding = const EdgeInsets.all(6)
  });

  final double? width;
  final double? height;
  final Color backgroundColor;
  final SvgPicture image;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      child: Stack(
        children: [
          SvgPicture.asset(
            "res/drawables/ic_m_bg.svg",
            color: backgroundColor,
          ),
          Positioned(
              top: padding.top,
              left: padding.left,
              right: padding.right,
              bottom: padding.bottom,
              child: image
          )
        ],
      ),
    );
  }

}