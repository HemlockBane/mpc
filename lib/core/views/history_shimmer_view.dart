import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:shimmer/shimmer.dart';

class BeneficiaryShimmer extends StatelessWidget {

  Widget _shimmerItem() {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 20),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
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
                      width: 60,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Color(0XFFE3E8EB).withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      width: 150,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Color(0XFFE3E8EB).withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                    )
                  ]
              )),
          Container(
            width: 60,
            height: 10,
            decoration: BoxDecoration(
                color: Color(0XFFE3E8EB).withOpacity(0.5),
                shape: BoxShape.circle
            ),
          ),
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