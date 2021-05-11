import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';

/// @author Paul Okeke
class PieProgressBar extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _PieProgressBar();
  }

}

class _PieProgressBar extends State<PieProgressBar> {

  int _stepPerProgress = 0;
  int _totalPage = 0;
  PageController? _viewPager;
  double _progress = 40;

  void setupWithViewPager(PageController controller, int numOfPages) {
    this._viewPager = controller;
    _stepPerProgress = ((numOfPages > 0) ? 100 / numOfPages : 0).floor();
    _totalPage = numOfPages;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 58,
            height: 58,
            // color: Colors.white,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    value: 0.5,
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.primaryColor),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('1', style: TextStyle(color: Colors.primaryColor, fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('/3', style: TextStyle(color: Colors.grey, fontSize: 19, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 16),
          Flexible(
            child: Text(
                'Page Title',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.textColorBlack, fontSize: 20)
            ),
          )
        ],
      ),
    );
  }

}