import 'package:flutter/material.dart' hide Colors;

class PaddedDivider extends StatelessWidget {
  const PaddedDivider({
    Key? key,
    this.bottom,
    this.left,
    this.right,
    this.top,
    this.dividerColor,
    this.dividerThickness,
  }) : super(key: key);

  final double? top;
  final double? bottom;
  final double? right;
  final double? left;
  final Color? dividerColor;
  final double? dividerThickness;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: top ?? 6,
        bottom: bottom ?? 11,
        left: left ?? 0,
        right: right ?? 0,
      ),
      child: Divider(
        thickness: 0.7,
        color: dividerColor ?? Color(0xff966C2E).withOpacity(0.12),
      ),
    );
  }
}
