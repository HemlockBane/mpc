import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/growth/model/data/notification_status_type.dart';
import 'package:moniepoint_flutter/app/growth/model/data/pop_up_notification_data.dart';
import 'package:moniepoint_flutter/app/growth/model/data/growth_notification.dart';
import 'package:moniepoint_flutter/app/growth/model/interpreter/navigation_interpreter.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/main.dart';
import 'package:swipeable_card_stack/swipe_controller.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'package:webview_flutter/webview_flutter.dart';

///PopUpNotificationRoute
///
///@author Paul Okeke
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
  String? get barrierLabel => "_PopUpNotificationRoute_";

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
  final ValueNotifier<GrowthPopupNotification?> _notificationDataNotifier = ValueNotifier(null);

  void _onCardSwipe(BuildContext context, List<_PopUpCard> popUpCards,  int index) {
    if(index == popUpCards.length - 1) {
      Future.delayed(Duration(milliseconds: 1000), (){
        Navigator.of(context).pop();
      });
    }
    final notification = popUpCards[index].growthPopupNotification;
    notificationData.update(NotificationStatusType.CLOSE, notification);
    if(index < popUpCards.length - 1) {
      final nextNotification = popUpCards[index + 1].growthPopupNotification;
      notificationData.update(NotificationStatusType.SEEN, nextNotification);
      _notificationDataNotifier.value = nextNotification;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final popUpCards = this.notificationData.getData().map((e) => _PopUpCard(
        key: GlobalObjectKey(e),
        growthPopupNotification: e
    )).toList();
    //TODO there's got to be a better way for this
    notificationData.update(NotificationStatusType.SEEN, notificationData.getData().first);
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
              onCardSwiped: (dir, index, widget) => _onCardSwipe(context, popUpCards, index),
              enableSwipeUp: false,
              enableSwipeDown: true,
            )
          ],
        ),
        IgnorePointer(
          child: ValueListenableBuilder(
              valueListenable: _notificationDataNotifier,
              child: Lottie.asset(
                  "res/drawables/confetti.json",
                  height: MediaQuery.of(context).size.height
              ),
              builder: (ctx, GrowthPopupNotification? value, child) {
                return (value?.celebration == true && child != null)
                    ? child
                    : SizedBox.shrink();
              }
          ),
        ),
      ],
    );
  }

}

///_PopUpCard
///
///
class _PopUpCard extends StatefulWidget {

  _PopUpCard({
    Key? key,
    required this.growthPopupNotification
  }):super(key: key);

  final GrowthPopupNotification growthPopupNotification;

  @override
  State<StatefulWidget> createState()  => _PopUpCardState(growthPopupNotification);
}

///_PopUpCardState
///
///
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
        navigationDelegate: (a) {
          // NavigationInterpreter.interpret(a.url);
          print("This is us trying to navigate");
          // navigatorKey.currentState?.pushNamed(Routes.ACCOUNT_STATUS);
          return NavigationDecision.prevent;
        },
      ),
    );
  }

}