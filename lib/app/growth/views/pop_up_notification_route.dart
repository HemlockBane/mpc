import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/growth/model/data/pop_up_notification_data.dart';
import 'package:moniepoint_flutter/app/growth/model/data/growth_notification.dart';
import 'package:swipeable_card_stack/swipe_controller.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'package:webview_flutter/webview_flutter.dart';

///PopUpNotificationRoute
///
class PopUpNotificationRoute<T> extends PopupRoute<T> {

  PopUpNotificationRoute({
    required this.notificationData
  });

  final PopUpNotificationData notificationData;

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.7);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => "test";

  @override
  Widget buildPage(BuildContext context,
      Animation<double> animation, Animation<double> secondaryAnimation) {
    return _PopUpNotificationPage(notificationData: notificationData,);
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 400);
}

///_PopUpNotificationPage
///
class _PopUpNotificationPage extends StatelessWidget {

  _PopUpNotificationPage({required this.notificationData});
  
  final SwipeableCardSectionController _cardController = SwipeableCardSectionController();
  final PopUpNotificationData notificationData;

  
  @override
  Widget build(BuildContext context) {
    final popUpCards = this.notificationData.getData().map((e) => _PopUpCard(
        key: GlobalObjectKey(e),
        growthPopupNotification: e
    )).toList();

    return Stack(
      children: [
        Column(
          children: [
            SwipeableCardsSection(
              key: UniqueKey(),
              // cardHeightTopMul: 0.4,
              // cardHeightMiddleMul: 0.4,
              // cardHeightBottomMul: 0.4,
              cardController: _cardController,
              context: context,
              items: popUpCards,
              onCardSwiped: (dir, index, widget) {
                if(index == popUpCards.length - 1) {
                  Future.delayed(Duration(milliseconds: 1000), (){
                    Navigator.of(context).pop();
                  });
                }
              },
              enableSwipeUp: false,
              enableSwipeDown: true,
            )
          ],
        ),
        IgnorePointer(
          child: Lottie.asset("res/drawables/confetti.json", height: MediaQuery.of(context).size.height),
        ),
      ],
    );
  }

}

class _PopUpCard extends StatefulWidget {

  _PopUpCard({
    Key? key,
    required this.growthPopupNotification
  }):super(key: key);

  final GrowthPopupNotification growthPopupNotification;

  @override
  State<StatefulWidget> createState()  => _PopUpCardState(growthPopupNotification);
}

class _PopUpCardState extends State<_PopUpCard> {

  _PopUpCardState(this.growthPopupNotification);

  final GrowthPopupNotification growthPopupNotification;
  late final String? _htmlBase64;

  @override
  void initState() {
    _htmlBase64 = growthPopupNotification.htmlBase64;
    super.initState();
    if(Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16)
      ),
      child: WebView(
        initialUrl: _htmlBase64,
      ),
    );
  }

}