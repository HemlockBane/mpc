import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:shimmer/shimmer.dart';

class FlexDashboardBalanceLoadingShimmer extends StatelessWidget {

  final bool isLoading;

  FlexDashboardBalanceLoadingShimmer({
    required this.isLoading
  });

  @override
  Widget build(BuildContext context) {
    if(!isLoading) return SizedBox();
    return Column(
        children: [
          Shimmer.fromColors(
              period: Duration(milliseconds: 1000),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 90,
                    height: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.rectangle),
                  )),
              baseColor: Colors.white.withOpacity(0.6),
              highlightColor: Colors.deepGrey.withOpacity(0.6)
          ),
          SizedBox(height: 4),
          Shimmer.fromColors(
              period: Duration(milliseconds: 1000),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 90,
                    height: 32,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.rectangle),
                  )),
              baseColor: Colors.white.withOpacity(0.6),
              highlightColor: Colors.deepGrey.withOpacity(0.6)
          )
        ]);
  }
}
