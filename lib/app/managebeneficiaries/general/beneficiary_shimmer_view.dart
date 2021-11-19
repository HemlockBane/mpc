import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:shimmer/shimmer.dart';

class BeneficiaryShimmer extends StatelessWidget {

  BeneficiaryShimmer({this.wrapInList = true});

  final bool wrapInList;

  Widget _shimmerItem() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
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
          Container(
            width: 10,
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
  Widget build(BuildContext context) {
    final children = [
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
    ];
    return Container(
      child: (wrapInList)
          ? ListView(physics: NeverScrollableScrollPhysics(), children: children,)
          : Column(children: children,),
    );
  }

}