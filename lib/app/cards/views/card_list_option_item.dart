import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';

class CardListOptionItem extends StatelessWidget {

  final OnItemClickListener<Tuple<Resource<dynamic>, dynamic>?, num>? onClick;
  final String title;
  final String? subTitle;
  final bool? isEnabled;
  final Widget leadingIcon;
  final Stream<Resource<dynamic>> Function()? processOnClick;//Stream<Resource<dynamic>>? processStream;

  CardListOptionItem({
    required this.onClick,
    required this.title,
    required this.leadingIcon,
    this.subTitle,
    this.isEnabled,
    this.processOnClick
  });

  final ValueNotifier<Resource<dynamic>?> _notifier = ValueNotifier(null);

  Widget _subTitleAlignment() {
    return Align(
      alignment: Alignment(-1, -1),
      child: Text(
        subTitle ?? "",
        style: TextStyle(color: Colors.deepGrey, fontSize: 12),),
    );
  }

  void _onItemClick() {
    //If we are not running though any process we immediately call click
    if(processOnClick == null) {
      return onClick?.call(null, 0);
    }

    processOnClick?.call().listen((event) {
      _notifier.value = event;
      if(event is Success || event is Error) {
        onClick?.call(Tuple(event, null), 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (onClick != null) ? _onItemClick : null,
        child: Opacity(
          opacity: onClick != null ? 1 : 0.3,
          child: ListTile(
              leading: Container(
                height: 49,
                width: 49,
                padding: EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: Colors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: leadingIcon,
              ),
              trailing: ValueListenableBuilder(
                valueListenable: _notifier,
                builder: (ctx, snapshot, _) {
                  if(snapshot != null && snapshot is Loading) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset('res/drawables/progress_bar_lottie.json', width: 20, height: 20),
                        SizedBox(width: 7,),
                        Text(
                            "Processing",
                            style: TextStyle(
                                color: Colors.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12
                            ),
                        ),
                        SizedBox(width: 7,),
                      ],
                    );
                  }
                  return SvgPicture.asset(
                    'res/drawables/ic_forward_anchor.svg',
                    color: Colors.primaryColor,
                  );
                },
              ),
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.only(
                  top: subTitle == null ? 8 : 7,
                  bottom:subTitle == null ? 8 : 7,
                  left: 16, right: 16
              ),
              title: Text(
                title,
                style: TextStyle(color: Colors.textColorMainBlack, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              subtitle: (subTitle != null)
                  ? _subTitleAlignment()
                  : null,
            ),
        ),
      ),
    );
  }
}