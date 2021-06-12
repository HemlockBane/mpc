import 'package:flutter/material.dart' hide Card, Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/card_util.dart';

class CardListItem extends Container {

  final Card card;
  final int position;
  final OnItemClickListener<Card, int> onItemClickListener;

  CardListItem(this.card, this.position, this.onItemClickListener);

  String getFirst6Digits() {
    String? maskedPan = card.maskedPan;
    if(maskedPan.length < 6) return "";
    final first6 = maskedPan.substring(0, 6);
    return "${first6.substring(0, 4)} ${first6.substring(4, 6)}";
  }

  String getLast4Digits() {
    String? maskedPan = card.maskedPan;
    if(maskedPan.length < 16) return "";
    return maskedPan.substring(maskedPan.length - 4, maskedPan.length);
  }

  String getCardExpiryDate() {
    String? expiryDate = card.expiryDate;
      if(expiryDate == null || expiryDate.length < 4) return "";
      return "${expiryDate.substring(expiryDate.length - 2)}/${expiryDate.substring(0, 2)}";
  }

  Widget getCardBrandLogo() {
    if(CardUtil.isMasterCard(card.maskedPan)) return SvgPicture.asset('res/drawables/ic_master_card.svg');
    if(CardUtil.isVerveCard(card.maskedPan)) return SvgPicture.asset('res/drawables/ic_verve_card.svg');
    if(CardUtil.isVisaCard(card.maskedPan)) return SvgPicture.asset('res/drawables/ic_visa_card.svg');
    else return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(
            image: ExactAssetImage("res/drawables/card_bg.png"),
            fit: BoxFit.cover
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            color: (!card.blocked) ? Colors.primaryColor.withOpacity(0.48) : Colors.red.withOpacity(0.5),
            spreadRadius: 0.1,
            blurRadius: 12
          )
        ]
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 28, left: 24, right: 24, bottom: 12),
            child: Column(
              children: [
                Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            card.nameOnCard ?? "",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset('res/drawables/ic_moniepoint_cube.svg'),
                            SizedBox(width: 4,),
                            SvgPicture.asset('res/drawables/ic_moniepoint_text.svg')
                          ],
                        )
                      ],
                    )
                ),
                SizedBox(height: 42,),
                Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(getFirst6Digits(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal, color: Colors.white),),
                        Text('** **** ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text(getLast4Digits(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal, color: Colors.white),),
                      ],
                    )
                ),
                SizedBox(height: 42,),
                Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('EXPIRES\nEND', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w600, color: Colors.white),),
                            SizedBox(width: 4),
                            SvgPicture.asset('res/drawables/ic_forward_polygon.svg', width: 3, height: 5,),
                            SizedBox(width: 4),
                            Text(getCardExpiryDate(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                        getCardBrandLogo()
                      ],
                    )
                ),
              ],
            ),
          ),
          Visibility(
              visible: card.blocked,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0XFFE8E94444),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SvgPicture.asset('res/drawables/ic_card_locked.svg'),
                    SizedBox(height: 4,),
                    Text('Blocked', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),)
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}