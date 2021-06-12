import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../colors.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox(
      {Key? key,
        required this.onSelect,
        required this.isSelected,
        this.height,
        this.width,
        this.selectedStateImageRes
      }) : super(key: key);

  final ValueChanged<bool> onSelect;
  final bool isSelected;
  final String? selectedStateImageRes;

  final double? height;
  final double? width;

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  Widget selectedState() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: (widget.isSelected)
            ? null
            : Border.all(
                color: Colors.colorFaded, width: 1, style: BorderStyle.solid),
      ),
      child: Center(
        child: (widget.isSelected)
            ? SvgPicture.asset(
                widget.selectedStateImageRes ?? 'res/drawables/ic_circular_check_mark.svg',
                color: Colors.primaryColor,
                width: widget.width ?? 44,
                height: widget.height ?? 44,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      child: SizedBox(
        width: widget.width ?? 40,
        height: widget.height ?? 40,
        child: TextButton(
          onPressed: () {
            widget.onSelect(true);
          },
          child: Center(
            child: selectedState()
          ),
        ),
      ),
    );
  }
}