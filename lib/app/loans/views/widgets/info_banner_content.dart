import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';



class InfoBannerContent extends StatelessWidget {
  const InfoBannerContent(
    {Key? key,
      required this.svgPath,
      this.title,
      this.subtitle,
      this.subtitleWidget,
      this.additionalInfo,
      this.rightSpace})
    : super(key: key);

  final String svgPath;
  final String? title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final String? additionalInfo;
  final double? rightSpace;

  TextStyle getBoldStyle(
    {double fontSize = 32.5,
      Color color = Colors.textColorBlack,
      FontWeight fontWeight = FontWeight.w700}) =>
    TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 5),
        SvgPicture.asset(
          svgPath,
          height: 22.5,
          width: 22.5,
        ),
        SizedBox(width: 16.6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(title!, style: getBoldStyle(fontSize: 14)),
              if (title != null) SizedBox(height: 5),
              if (subtitle != null || subtitleWidget != null)
                subtitleWidget ??
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12.9,
                      height: 1.48,
                      fontWeight: FontWeight.normal,
                      color: Colors.textColorBlack),
                  ),
              SizedBox(height: 5),
              if (additionalInfo != null)
                Text(
                  additionalInfo!,
                  style:
                  getBoldStyle(fontSize: 13).copyWith(letterSpacing: -0.3),
                )
            ],
          ),
        ),
        SizedBox(width: rightSpace ?? 46)
      ],
    );
  }
}
