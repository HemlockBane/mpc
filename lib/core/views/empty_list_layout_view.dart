import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';

class EmptyLayoutView extends Container {
  final String? imageRes;
  final String description;

  EmptyLayoutView(this.description, {this.imageRes});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(imageRes ?? 'res/drawables/ic_empty_record_state.svg'),
        SizedBox(height: 24,),
        Padding(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Text(
              description,
              style: TextStyle(color: Colors.colorPrimaryDark, fontSize: 16), textAlign: TextAlign.center,
            ),
        ),
        SizedBox(height: 200,)
      ],
    );
  }
}
