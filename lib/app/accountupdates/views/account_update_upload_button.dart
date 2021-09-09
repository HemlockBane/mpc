import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';

class AccountUpdateUploadButton extends StatelessWidget {

  final String title;
  final VoidCallback? onClick;
  final Color? backgroundColor;

  AccountUpdateUploadButton({
    required this.title,
    this.onClick,
    this.backgroundColor = const Color(0XFFF2F7FE)
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: this.backgroundColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.primaryColor.withOpacity(0.16), width: 0.75)
      ),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          overlayColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.15)),
          highlightColor: Colors.primaryColor.withOpacity(0.02),
          borderRadius: BorderRadius.circular(5),
          onTap: onClick,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 11, bottom: 11),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 9, right: 9, bottom: 11, top: 11),
                  decoration: BoxDecoration(
                    color: Color(0XFF2AAAE2).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset('res/drawables/ic_upload_photo.svg', ),
                ),
                SizedBox(width: 16),
                Flexible(flex: 1,child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                        this.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: Colors.primaryColor, fontSize: 15, fontWeight: FontWeight.w600)
                    ),
                    SizedBox(height: 5,),
                    Text(
                        'Tap to upload. PNG, JPG, GIF, PDF accepted',
                        style: TextStyle(
                            color: Colors.deepGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 12
                        )
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

}