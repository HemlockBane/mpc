import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';

class FullPageLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepGrey.withOpacity(0.2),
      height: double.infinity,
      width: double.infinity,
      child: SafeArea(child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 4,
          backgroundColor: Colors.deepGrey.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation(Colors.darkBlue),
        ),
      )),
    );
  }

}