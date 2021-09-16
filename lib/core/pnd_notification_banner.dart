import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/routes.dart';

import 'colors.dart';

class PndNotificationBanner extends StatelessWidget {
  PndNotificationBanner({required this.onBannerTap});

  final VoidCallback onBannerTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.9),
        borderRadius: BorderRadius.all(Radius.circular(9)),
        border: Border.all(
          color: Colors.colorPrimaryDark.withOpacity(0.1),
          width: 0.5
        )),
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          highlightColor: Colors.primaryColor.withOpacity(0.02),
          overlayColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.05)),
          borderRadius: BorderRadius.all(Radius.circular(13)),
          onTap: () => onBannerTap(),
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 4, 10, 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  padding: EdgeInsets.all(0),
                  child: Center(
                    child:
                    SvgPicture.asset('res/drawables/ic_danger_alt.svg',
                      width: 20,
                      height: 20,
                    )
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Account Restricted! Tap to fix this.",
                    style: TextStyle(fontSize: 12.6, color: Colors.white, fontWeight: FontWeight.w400)
                  )
                ),
                SvgPicture.asset(
                  'res/drawables/ic_forward_anchor.svg',
                  width: 14,
                  height: 14,
                  color: Colors.white,
                ),
                SizedBox(width: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
