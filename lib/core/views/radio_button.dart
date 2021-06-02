import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';

/// @author Paul Okeke
class RadioButton<T> extends StatelessWidget {

  final T groupValue;
  final T value;
  final ValueChanged<T?> onChange;
  final Widget? title;

  RadioButton({
    required this.groupValue,
    required this.value,
    required this.onChange,
    this.title
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<T>(
            value: value,
            // fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            //   if(states.contains(MaterialState.disabled)) {
            //     return Colors.grey.withOpacity(0.5);
            //   }
            //   return Colors.red.withOpacity(0.5);
            // }),
            // overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
            //   if(states.contains(MaterialState.disabled)) {
            //     return Colors.primaryColor.withOpacity(0.5);
            //   }
            //   return Colors.primaryColor.withOpacity(0.5);
            // }),
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            groupValue: groupValue,
            onChanged: onChange
        ),
        SizedBox(width: 4,),
        title ?? SizedBox(),
      ],
    );
  }


}