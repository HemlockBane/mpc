import 'package:flutter/material.dart' hide Colors;

import '../colors.dart';

class GenericListPlaceholder extends Container {

  final Widget imagePlaceholder;
  final String message;

  GenericListPlaceholder(this.imagePlaceholder, this.message);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        imagePlaceholder,
        SizedBox(height: 16,),
        Flexible(
            fit: FlexFit.loose,
            child: Text(
              this.message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.colorPrimaryDark),
            )
        )
      ],
    );
  }
}