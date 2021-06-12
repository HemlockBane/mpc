import 'package:flutter/material.dart';

class ScrollView extends StatelessWidget {

  final Widget? child;
  final double? maxHeight;

  ScrollView({this.child, this.maxHeight});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context,  BoxConstraints constraints) {
      return SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: (maxHeight == null) ? constraints.maxHeight : maxHeight!),
          child: IntrinsicHeight(
            child: this.child,
          ),
        ),
      );
    });
  }

}

