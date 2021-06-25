import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:shimmer/shimmer.dart';

class SecurityQuestionShimmer extends StatelessWidget {

  Widget _shimmerItem() {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(
                color: Color(0XFFE3E8EB).withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
                shape: BoxShape.rectangle
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
                color: Color(0XFFE3E8EB).withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
                shape: BoxShape.rectangle
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
                color: Color(0XFFE3E8EB).withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
                shape: BoxShape.rectangle
            ),
          ),
          SizedBox(height: 2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
    child:  Column(
      children: [
        Shimmer.fromColors(
            child: _shimmerItem(),
            baseColor: Color(0XFFE3E8EB).withOpacity(0.5),
            highlightColor: Colors.grey.withOpacity(0.3)
        ),
        Shimmer.fromColors(
            child: _shimmerItem(),
            baseColor: Color(0XFFE3E8EB).withOpacity(0.5),
            highlightColor: Colors.grey.withOpacity(0.3)
        ),
        Shimmer.fromColors(
            child: _shimmerItem(),
            baseColor: Color(0XFFE3E8EB).withOpacity(0.5),
            highlightColor: Colors.grey.withOpacity(0.3)
        )
      ],
    ),
  );

}