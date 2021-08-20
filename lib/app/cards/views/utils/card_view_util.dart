import 'package:flutter/material.dart' hide Colors, Card;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/utils/card_util.dart';

class CardViewUtil {
  static String getFirst6Digits(Card card) {
    String? maskedPan = card.maskedPan;
    if (maskedPan.length < 6) return "";
    final first6 = maskedPan.substring(0, 6);
    return "${first6.substring(0, 4)} ${first6.substring(4, 6)}";
  }

  static String getLast4Digits(Card card) {
    String? maskedPan = card.maskedPan;
    if (maskedPan.length < 16) return "";
    return maskedPan.substring(maskedPan.length - 4, maskedPan.length);
  }

  static String getCardExpiryDate(Card card) {
    String? expiryDate = card.expiryDate;
    if (expiryDate == null || expiryDate.length < 4) return "";
    return "${expiryDate.substring(expiryDate.length - 2)}/${expiryDate.substring(0, 2)}";
  }


  static Color getCardBackground(Card card) {
    if(card.blocked) return Color(0XFFE14E4F).withOpacity(0.88);
    if(card.status == CardStatus.IN_ACTIVE) return Colors.deepGrey;
    return Colors.primaryColor;
  }

  static Widget getCardBrandLogo(Card card) {
    if (CardUtil.isMasterCard(card.maskedPan))
      return SvgPicture.asset(
        'res/drawables/ic_master_card.svg',
        height: 16,
      );
    if (CardUtil.isVerveCard(card.maskedPan))
      return SvgPicture.asset('res/drawables/ic_verve_card.svg');
    if (CardUtil.isVisaCard(card.maskedPan))
      return SvgPicture.asset(
        'res/drawables/ic_visa_card.svg',
      );
    else
      return Container();
  }

  static Widget getBlockedCardBanner() {
    return SizedBox(
      width: 160,
      height: 40,
      child: Stack(
        children: [
          Positioned(
              right: 0,
              top: 7,
              bottom: 7,
              child: Container(
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.only(left: 8, right: 24, top: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: Color(0XFF381212).withOpacity(0.4),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomLeft: Radius.circular(6))),
                child: Text(
                  "BLOCKED",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              )),
          Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 38,
                height: 38,
                padding: EdgeInsets.only(left: 9, right: 9, bottom: 5, top: 5),
                decoration: new BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: SvgPicture.asset('res/drawables/ic_warning.svg',
                    color: Colors.red),
              )),
        ],
      ),
    );
  }

  static Widget getInactiveCardBanner() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(right: 20),
          padding: EdgeInsets.only(left: 8, right: 16, top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: Color(0XFF122138).withOpacity(0.4),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6))
          ),
          child: Text(
            "INACTIVE",
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
          ),),
        Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SvgPicture.asset('res/drawables/ic_moniepoint_cube.svg')
        ),
      ],
    );
  }


  static Widget getCardStateBanner(Card card) {
    if(card.blocked) return getBlockedCardBanner();
    if(card.status == CardStatus.IN_ACTIVE) return getInactiveCardBanner();
    return Row(
      children: [
        SvgPicture.asset('res/drawables/ic_moniepoint_cube.svg'),
      ],
    );
  }
}
