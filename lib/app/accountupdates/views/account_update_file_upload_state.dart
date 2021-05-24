import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';

enum UploadState {
  NONE, LOADING, SUCCESS, ERROR
}

class AccountUpdateFileUploadState extends StatelessWidget {

  final UploadState _state;

  AccountUpdateFileUploadState(this._state);

  @override
  Widget build(BuildContext context) {
    final Color color;
    final Widget drawableLeft;
    final String info;

    if (_state == UploadState.LOADING) {
      info = "Uploading file...";
      color = Colors.deepGrey;
      drawableLeft = SizedBox(
        width: 10, height: 10,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: Colors.deepGrey.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation(Colors.darkBlue),
        ),
      );
    } else if (_state == UploadState.SUCCESS) {
      info = "File uploaded successfully.";
      drawableLeft = SvgPicture.asset('res/drawables/ic_circular_check_mark.svg');
      color = Colors.solidGreen;
    } else if (_state == UploadState.ERROR) {
      info = "File failed to upload.";
      color = Colors.red;
      drawableLeft = SvgPicture.asset('res/drawables/ic_cancel.svg', width: 20, height: 20);
    } else {
      info = "";
      color = Colors.transparent;
      drawableLeft = SizedBox();
    }

    return Row(
      children: [
        drawableLeft,
        SizedBox(width: 8),
        Text(
            info,
            textAlign: TextAlign.end,
            style: TextStyle(color: color, fontSize: 14)
        )
      ],
    );
  }

}