import 'package:flutter/material.dart';

class ScrollView extends StatelessWidget {

  final Widget? child;

  ScrollView({this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context,  BoxConstraints constraints){
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: this.child,
          ),
        ),
      );
    });
  }

}