import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';

///NotificationWrapper
///
///
class NotificationWrapper extends StatefulWidget {

  NotificationWrapper({required this.notificationBanners});

  final List<NotificationBanner> notificationBanners;

  @override
  State<StatefulWidget> createState() => _NotificationWrapperState();

}

class _NotificationWrapperState extends State<NotificationWrapper> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 46),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Color(0XFFF5F9FF),
        borderRadius: BorderRadius.circular(10)
      ),
      child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: widget.notificationBanners.length,
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.only(left: 7, right: 7),
                child: Divider(color: Colors.dividerColor.withOpacity(0.3), height: 1,),
            );
          },
          itemBuilder: (ctx, index) {
            return Dismissible(
                key: Key("$index"),
                onDismissed: (direction) {
                  setState(() {
                    widget.notificationBanners.removeAt(index);
                  });
                },
                child: widget.notificationBanners[index]
            );
          },
      ),
    );
  }

}

class NotificationBanner extends StatelessWidget {
  NotificationBanner({Key? key, required this.content}) : super(key: key);

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return content;
  }
}