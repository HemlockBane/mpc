import 'package:flutter/gestures.dart';
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
    return Listener(
      onPointerMove: (pos) {
        print("Moving Pointer ===> ${pos.position.dy}");
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 46),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: Color(0XFFF5F9FF),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, 13),
                blurRadius: 21
              )
            ]
        ),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: widget.notificationBanners.length,
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(left: 7, right: 7),
              child: Divider(color: Colors.dividerColor2.withOpacity(0.1), height: 0.8,),
            );
          },
          itemBuilder: (ctx, index) {
            final banner = widget.notificationBanners[index];
            final totalItems = widget.notificationBanners.length;
            return Dismissible(
                key: banner.key ?? Key("$index"),
                onDismissed: (direction) {
                  setState(() {
                    widget.notificationBanners.removeAt(index);
                  });
                },
                child: banner.copyWithPaddingByIndex(index: index, total: totalItems)
            );
          },
        ),
      ),
    );
  }

}

class NotificationBanner extends StatelessWidget {
  NotificationBanner({
    Key? key,
    required this.content,
    required this.onClick
  }) : super(key: key);

  final Widget content;
  final VoidCallback? onClick;

  NotificationBanner copyWithPaddingByIndex({required int index, required int total}) {
    return NotificationBanner(
        content: Container(
          padding: EdgeInsets.only(top: index == 0 ? 22 : 16, bottom: index == total - 1 ? 22 : 16),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            child: InkWell(
              onTap: this.onClick,
              borderRadius: BorderRadius.circular(10),
              child: this.content,
            ),
          ),
        ),
      onClick: this.onClick,
    );
  }

  @override
  Widget build(BuildContext context) {
    return content;
  }
}