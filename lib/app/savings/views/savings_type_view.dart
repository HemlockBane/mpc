import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/views/icon_curved_container.dart';

class SavingsTypeView extends StatefulWidget{

  SavingsTypeView({
    required this.content
  });

  final Widget content;

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }

}

class _SavingTypeView extends State<SavingsTypeView> {

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
    return Row(
      children: [
        IconCurvedContainer(
            backgroundColor: Colors.savingsPrimary.withOpacity(0.08),
            image: SvgPicture.asset("res/drawables/ic_savings_flex.svg")
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

      ],
    );
  }
}