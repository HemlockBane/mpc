import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';

class CardListOptionItem extends StatelessWidget {

  final VoidCallback? onClick;
  final String title;
  final String? subTitle;
  final bool? isEnabled;
  final SvgPicture leadingIcon;

  CardListOptionItem({
    required this.onClick,
    required this.title,
    required this.leadingIcon,
    this.subTitle,
    this.isEnabled
  });


  Widget _subTitleAlignment() {
    return Align(
      alignment: Alignment(-1, -1),
      child: Text(
        subTitle ?? "",
        style: TextStyle(color: Colors.deepGrey, fontSize: 12),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
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
              trailing: SvgPicture.asset(
                'res/drawables/ic_forward_anchor.svg',
                color: Colors.primaryColor,
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