import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:shimmer/shimmer.dart';

class SupportShimmer extends StatelessWidget {

  Widget _shimmerItem() {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Color(0XFFE3E8EB).withOpacity(0.5),
              shape: BoxShape.circle
            ),
          ),
          SizedBox(width: 16),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 250,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Color(0XFFE3E8EB).withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      width: 100,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Color(0XFFE3E8EB).withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                    )
                  ]
              )),
          SizedBox(width: 2),
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