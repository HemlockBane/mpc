import 'dart:math';

import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';

/// @author Paul Okeke
class PieProgressBar extends AnimatedWidget {
  final PageController viewPager;
  final int totalItemCount;
  final List<String>? pageTitles;

  PieProgressBar({
    required this.viewPager, 
    required this.totalItemCount,
    this.pageTitles = const []}
    ) : super(listenable: viewPager);

  double _previous = 0;

  Widget _circularBox(double value, double destinationValue) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CircularProgressIndicator(
            strokeWidth: 6,
            value: value,
            backgroundColor: Colors.grey.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.primaryColor),
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${(viewPager.page?.round() ?? 0.0) + 1}',
                  style: TextStyle(
                      color: Colors.primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              Text('/$totalItemCount',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 19,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
  }

  String getCurrentPageTitleOrEmpty(int destinationPage) {
    if (pageTitles!.length >= destinationPage) {
      return pageTitles![destinationPage];
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    int destinationPage = viewPager.page?.round() ?? 0;
    double scaleFactor = (totalItemCount > 0) ? 1 / totalItemCount : 1;
    double endValue = scaleFactor + (scaleFactor * destinationPage).toDouble();

    return TweenAnimationBuilder(
        tween: Tween<double>(begin: _previous, end: endValue),
        duration: Duration(milliseconds: 500),
        builder: (BuildContext mContext, double value, _) {
          _previous = value;
          return Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 58,
                  height: 58,
                  // color: Colors.white,
                  child: _circularBox(value, destinationPage.toDouble()),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: Text(getCurrentPageTitleOrEmpty(destinationPage),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.textColorBlack,
                          fontSize: 22)),
                )
              ],
            ),
          );
        });
  }
}
