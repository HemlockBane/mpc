import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';

///NotificationWrapper
///
///
class NotificationWrapper extends StatefulWidget {

  NotificationWrapper({
    required this.notificationBanners,
    this.onDismiss,
    this.onRemove,
    this.display = false
  });

  final List<NotificationBanner> notificationBanners;
  final VoidCallback? onDismiss;
  final ValueChanged<NotificationBanner>? onRemove;
  final bool display;

  @override
  State<StatefulWidget> createState() => _NotificationWrapperState();

}

class _NotificationWrapperState extends State<NotificationWrapper> {

  @override
  void initState() {
    super.initState();
  }

  bool hasInteraction = false;

  void _closeOnElapsedTime() {
    if(widget.display) {
      Future.delayed(Duration(seconds: 7), (){
        if(hasInteraction) {
          hasInteraction = false;
          return _closeOnElapsedTime();
        }
        widget.onDismiss?.call();
      });
    }
  }

  void _onItemClick(NotificationBanner banner, int index) {
    setState(() {
      banner.onClick?.call();
      widget.notificationBanners.removeAt(index);
      widget.onRemove?.call(banner);
      widget.onDismiss?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    _closeOnElapsedTime();
    return Listener(
      onPointerMove: (pos) {
        hasInteraction = true;
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
              child: Divider(color: Colors.dividerColor2.withOpacity(0.5), height: 0.8,),
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
                  widget.onRemove?.call(banner);
                },
                child: Material(
                  borderRadius: BorderRadius.circular(0),
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (banner.onClick != null)
                        ? () => _onItemClick(banner, index)
                        : null,
                    borderRadius: BorderRadius.circular(0),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: index == 0 ? 22 : 16,
                          bottom: index == totalItems - 1 ? 22 : 16
                      ),
                      child: banner,
                    ),
                  ),
                )
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

  @override
  Widget build(BuildContext context) {
    return content;
  }
}