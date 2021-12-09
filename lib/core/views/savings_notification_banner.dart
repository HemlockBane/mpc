import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';

enum NotificationType {
  info, warning, danger
}

class SavingsNotificationBanner extends StatelessWidget {
  const SavingsNotificationBanner({Key? key, this.notificationType = NotificationType.warning, required this.notificationString, this.notificationWidget}) : super(key: key);

  final NotificationType notificationType;
  final String notificationString;
  final Widget? notificationWidget;


  TextStyle getBoldStyle({double fontSize = 12,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w700}) =>
    TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  TextStyle getNormalStyle({double fontSize = 12,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w400}) =>
    TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  @override
  Widget build(BuildContext context) {
    Color color = notificationType == NotificationType.warning
        ? Colors.red
        : Colors.solidYellow;

    if(notificationType == NotificationType.info) {
      color = Color(0XFF244528);
    }

    final icon = notificationType == NotificationType.warning
        ? SvgPicture.asset('res/drawables/ic_info.svg',
            width: 27, height: 27, color: Colors.grey)
        : SvgPicture.asset('res/drawables/ic_info_italic.svg',
            width: 24, height: 24, color: Colors.grey);


    Widget text = Text(notificationString,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 12.6, color: Colors.textColorBlack, fontWeight: FontWeight.w500)
    );

    if(notificationWidget != null){
      text = notificationWidget!;
    }

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.all(Radius.circular(9)),
      ),
      margin: EdgeInsets.only(top: 20, bottom: 2),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          highlightColor: Colors.primaryColor.withOpacity(0.02),
          overlayColor:
              MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.05)),
          borderRadius: BorderRadius.all(Radius.circular(13)),
          onTap: null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 9),
            child: Row(
              crossAxisAlignment: notificationType == NotificationType.warning
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 19,
                  height: 19,
                  padding: EdgeInsets.all(0),
                  child: Center(child: icon),
                ),
                SizedBox(width: 8),
                Expanded(child: text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
