import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/views/status_pill.dart';
import 'package:moniepoint_flutter/core/views/icon_curved_container.dart';

class ProductCard extends StatefulWidget{

  ProductCard({
    required this.headerTitle,
    required this.subTitle,
    required this.svgPath,
    required this.content,
  });

  final String headerTitle;
  final String subTitle;
  final String svgPath;
  final Widget content;

  @override
  State<StatefulWidget> createState() => _ProductCardState();

}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0XFF165B1D).withOpacity(0.14),
            offset: Offset(0, 1),
            blurRadius: 2
          )
        ]
      ),
      child: Column(
        children: [
          _HeaderView(
              headerTitle: widget.headerTitle,
              subTitle: widget.subTitle,
              svgPath: widget.svgPath
          ),
          Divider(
            height: 0.8, color: Color(0XFF752E96).withOpacity(0.12),
          ),
          SizedBox(height: 16,),
          widget.content
        ],
      ),
    );
  }

}

class _HeaderView extends StatelessWidget {

  _HeaderView({
    required this.headerTitle,
    required this.subTitle,
    required this.svgPath
  });

  final String headerTitle;
  final String subTitle;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 15, bottom: 9, right: 17),
      child: Row(
        children: [
          IconCurvedContainer(
              backgroundColor: Colors.savingsPrimary.withOpacity(0.08),
              child: SvgPicture.asset("res/drawables/ic_savings_flex.svg")
          ),
          SizedBox(height: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headerTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  subTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      color: Colors.dividerColor2
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          StatusPill(
              statusDescription: "Active",
              statusColor: Colors.savingsPrimary
          )
        ],
      ),
    );
  }
}