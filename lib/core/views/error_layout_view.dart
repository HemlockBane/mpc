import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';

class ErrorLayoutView extends Container {
  final VoidCallback retry;
  final String errorTitle;
  final String errorDescription;

  ErrorLayoutView(this.errorTitle, this.errorDescription, this.retry);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'res/drawables/ic_network_error.svg',
          width: 80,
          height: 80,
        ),
        SizedBox(height: 4,),
        Text(
          errorTitle.toUpperCase(),
          style: TextStyle(
              color: Colors.textColorMainBlack, fontWeight: FontWeight.w600, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          child: Text(errorDescription, style: TextStyle(color: Colors.deepGrey, fontSize: 14), textAlign: TextAlign.center,),
        ),
        SizedBox(
          height: 32,
        ),
        TextButton(
            onPressed: retry,
            child: Text('Retry'),
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(color: Colors.primaryColor, width: 2)
                )),
                padding: MaterialStateProperty.all(EdgeInsets.only(left: 16, right: 16, top: 7, bottom: 7)),
                textStyle: MaterialStateProperty.all(TextStyle(
                    fontSize: 16,
                    color: Colors.colorAccent,
                    fontWeight: FontWeight.w500,
                    fontFamily: Styles.defaultFont)),
                foregroundColor: MaterialStateProperty.all(Colors.colorAccent),
                backgroundColor:
                MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.disabled))
                    return Colors.deepGrey.withOpacity(0.5);
                  else if (states.contains(MaterialState.pressed))
                    return Colors.primaryColor.withOpacity(0.1);
                  else
                    return Colors.white;
                }))
        )
      ],
    );
  }
}
