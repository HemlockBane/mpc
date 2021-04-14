
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' ;

import '../tuple.dart';



extension ColoredText on Text {
  RichText colorText(Map<String, Tuple<Color, VoidCallback?>> pair, {bool underline = true}) {
    //we need to get the text and for there decide how many spans we need to create
    var originalText = this.data;
    final List<TextSpan> children = [];
    var mStartIndex = -1;
    var mBoundary = 0;
    var originalTextLength = originalText?.length ?? 0;
    var counter = 0;

    for (MapEntry<String, Tuple<Color, VoidCallback?>> e in pair.entries) {
      counter += 1;
      mStartIndex = originalText?.indexOf(e.key, mStartIndex + 1) ?? -1;

      if(mStartIndex == -1) {
        children.add(
            TextSpan(
                text: originalText?.substring(mStartIndex + 1),
                style: this.style
            )
        );
        break;
      }
      if(mStartIndex > mBoundary) {
        children.add(
            TextSpan(
              text: originalText?.substring(mBoundary, mStartIndex),
              style: this.style,
            )
        );
      }

      mBoundary = mStartIndex + e.key.length;
      children.add(
          TextSpan(
              text: originalText?.substring(mStartIndex, mBoundary),
              style: this.style?.copyWith(
                  color: e.value.first,
                  fontWeight: FontWeight.bold,
                  decoration: (underline) ? TextDecoration.underline : TextDecoration.none,
              ),
            recognizer: TapGestureRecognizer()..onTap = e.value.second
          )
      );

      //check for the last words
      if(mBoundary < originalTextLength && counter == pair.length) {
        children.add(
          TextSpan(
              text: originalText?.substring(mBoundary),
              style: this.style,
          )
        );
      }
    }
    return RichText(text: TextSpan(
      children: children
    ));
  }
}