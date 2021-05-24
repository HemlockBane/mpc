import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meta/meta.dart';

import '../colors.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox(this.icon,this.label,
      {Key? key,
        required this.onSelect,
        required this.isSelected,
        this.selectedBackgroundColor,
        this.notSelectedBackgroundColor,
        this.selectedTextColor,
        this.notSelectedTextColor,
        this.height,
        this.width,
      }) : super(key: key);

  final IconData icon;
  final String label;
  final ValueChanged<bool> onSelect;
  final bool isSelected;
  final Color? selectedBackgroundColor;
  final Color? selectedTextColor;
  final Color? notSelectedBackgroundColor;
  final Color? notSelectedTextColor;
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
                : Border.all(color: Colors.colorFaded, width: 1,  style: BorderStyle.solid),
        ),
        child: Center(
          child: (widget.isSelected)
              ? SvgPicture.asset('res/drawables/ic_circular_check_mark.svg', color: Colors.primaryColor, width: 44, height: 44,)
              : null,
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      child: SizedBox(
        width: widget.width ?? 44,
        height: widget.height ?? 44,
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