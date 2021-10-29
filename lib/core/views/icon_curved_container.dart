import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconCurvedContainer extends StatelessWidget {

  IconCurvedContainer({
    this.width,
    this.height,
    required this.backgroundColor,
    required this.image
  });

  final double? width;
  final double? height;
  final Color backgroundColor;
  final SvgPicture image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      child: Stack(
        children: [
          SvgPicture.asset(
            "res/drawables/ic_savings_icon_bg.svg",
            color: backgroundColor,
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: image
          )
        ],
      ),
    );
  }

}