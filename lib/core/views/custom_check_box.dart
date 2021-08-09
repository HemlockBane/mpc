import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../colors.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({Key? key,
        required this.onSelect,
        required this.isSelected,
        this.height,
        this.width,
        this.padding,
        this.selectedStateImageRes
      }) : super(key: key);

  final ValueChanged<bool> onSelect;
  final bool isSelected;
  final String? selectedStateImageRes;

  final double? height;
  final double? width;
  final EdgeInsets? padding;

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  Widget selectedState() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: widget.isSelected ? widget.padding ?? EdgeInsets.all(10) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: widget.isSelected ? Colors.primaryColor : Color(0XFFF0F6FF),
        shape: BoxShape.circle,
        border: (widget.isSelected)
            ? null
            : Border.all(color: Colors.primaryColor, width: 1.5, style: BorderStyle.solid),
      ),
      child: Center(
        child: (widget.isSelected)
            ? SvgPicture.asset(
                widget.selectedStateImageRes ?? 'res/drawables/ic_check_mark.svg',
                color: Colors.white,
                width: 22,
                height: 22,
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
        width: widget.width ?? 49,
        height: widget.height ?? 49,
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