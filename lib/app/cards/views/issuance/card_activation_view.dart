import 'dart:math';

import 'package:flutter/material.dart' hide Colors, Card, ScrollView;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_activation_response.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/card_activation_view_model.dart';
import 'package:moniepoint_flutter/app/cards/views/card_detailed_item.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_verification_for.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/pin_entry.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

class CardActivationView extends StatefulWidget {

  final num cardId;

  CardActivationView(this.cardId);

  @override
  State<StatefulWidget> createState() => _CardActivationViewState();

}

class _CardActivationViewState extends State<CardActivationView> with CompositeDisposableWidget{

  Card? _card;

  PageController? _pageViewController;
  final List<PagedForm> _pages = [];

  late CardActivationViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<CardActivationViewModel>(context, listen: false);
    _pageViewController = PageController();
    super.initState();
    _listenForPageChange();
  }

  void _subscribeUiToLiveliness() async {
    final response = await Navigator.of(context).pushNamed(Routes.LIVELINESS_DETECTION, arguments: {
      "verificationFor": LivelinessVerificationFor.CARD_ACTIVATION,
      "cardId": _card?.id,
      "cvv2": _viewModel.cvv,
      "newPin": _viewModel.newPin
    });

    if(response != null && response is CardActivationResponse) {
      await showSuccess(
          context,
          title: "Card Activated!",
          message: "Your Card has been activated successfully!",
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.CARDS, ModalRoute.withName(Routes.DASHBOARD)
      );
    }
  }

  void _listenForPageChange() {
    _viewModel.pageFormStream.listen((event) {
      if(event.second) {
        _pageViewController?.animateToPage(
            min(_pages.length - 1, event.first + 1),
            duration: Duration(milliseconds: 400),
            curve: Curves.decelerate
        );
        if(event.first == _pages.length - 1){
          _subscribeUiToLiveliness();
        }
      } else {
        _pageViewController?.animateToPage(
            max(0, event.first - 1),
            duration: Duration(milliseconds: 400),
            curve: Curves.decelerate
        );
      }
    }).disposedBy(this);
  }

  PageView _getCardActivationPages() {
    _pages.add(_CardActivationInfoPage());
    _pages.add(_CardCVVPage());
    _pages.add(_CardNewPinPage());

    return PageView.builder(
        controller: _pageViewController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (mContext, index) {
          return _pages[index]..bind(3, index);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CardActivationViewModel>(context, listen: false);

    return SessionedWidget(
        context: context,
        child: Scaffold(
          backgroundColor: Color(0XFFEAF4FF),
          appBar: AppBar(
              centerTitle: false,
              titleSpacing: -12,
              iconTheme: IconThemeData(color: Colors.primaryColor),
              title: Text('Card Activation',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.darkBlue,
                      fontFamily: Styles.defaultFont,
                      fontSize: 17
                  )
              ),
              backgroundColor: Color(0XFFEAF4FF),
              elevation: 0
          ),
          body: FutureBuilder(
            future: viewModel.getSingleCard(widget.cardId),
            builder: (mContext, AsyncSnapshot<Card?> snapshot) {
              if(!snapshot.hasData || snapshot.data == null) return Container();
              _card = snapshot.data;
              return Stack(
                children: [
                  Positioned(
                      top: 36,
                      left: 16,
                      right: 16,
                      child: CardDetailedItem(_card!)
                  ),
                  Positioned(
                      top: 182,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30)
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, -10),
                                  blurRadius: 6,
                                  spreadRadius: 0
                              )
                            ]
                        ),
                        child: Column(
                          children: [
                            Expanded(child: _getCardActivationPages())
                          ],
                        ),
                      )
                  )
                ],
              );
            },
          ),
        ),
    );
  }

}

class _CardActivationInfoPage extends PagedForm {

  @override
  State<StatefulWidget> createState() => _CardActivationInfoPageState();

}

class _CardActivationInfoPageState extends State<_CardActivationInfoPage> {

  late CardActivationViewModel _viewModel;

  initState(){
    _viewModel = Provider.of<CardActivationViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4),
        Center(
            child: Text("Card Activation",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.textColorBlack
            )
        )),
        SizedBox(height: 21),
        AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              height: 230,
              padding: EdgeInsets.only(left: 70, right: 70, top: 10, bottom: 10),
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.primaryColor.withOpacity(0.1)
              ),
              child: Image.asset("res/drawables/ic_card_in_envelop.png", width: 117, height: 117,),
            ),
        ),
        SizedBox(height: 32),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Take out the card from the Package',
            style: TextStyle(color: Colors.textColorBlack),
          ),
        ),
        Spacer(),
        Row(
          children: [
            Flexible(child: Container()),
            Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: Styles.appButton(
                          elevation: 0.2,
                          onClick: () {
                            _viewModel.movePage(widget.position);
                          },
                          text: "Next"
                      ),
                    ),
                  ),
                )
            )
          ],
        ),
        SizedBox(height: 45)
      ],
    );
  }

}

class _CardCVVPage extends PagedForm {

  @override
  State<StatefulWidget> createState() => _CardCVVPagePageState();

}

class _CardCVVPagePageState extends State<_CardCVVPage> with AutomaticKeepAliveClientMixin {

  late CardActivationViewModel _viewModel;
  bool _isCVVValid = false;

  @override
  void initState() {
    _viewModel = Provider.of<CardActivationViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Center(child: Text("Card Activation",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.textColorBlack
              )
          )),
          SizedBox(height: 21),
          Container(
            height: 230,
            width: double.infinity,
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: EdgeInsets.only(left: 70, right: 70, top: 60, bottom: 60),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.primaryColor.withOpacity(0.1)
            ),
            child: Image.asset("res/drawables/ic_card_activation_cvv.png"),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Enter CVV at the back of Card',
              style: TextStyle(color: Colors.textColorBlack),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom * 0.7),
            child: Styles.appEditText(
                hint: 'Enter CVV',
                inputType: TextInputType.number,
                inputFormats: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  _viewModel.setCVV(value);
                  if(value.length >= 3){
                    _isCVVValid = true;
                    FocusManager.instance.primaryFocus?.unfocus();
                  } else {
                    _isCVVValid = false;
                  }
                  setState(() {});
                },
                startIcon: Icon(CustomFont.numberInput, color: Colors.textFieldIcon.withOpacity(0.2), size: 22),
                animateHint: true,
                maxLength: 3
            ),
          ),
          SizedBox(height: 16),
          Spacer(),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: Styles.appButton(
                            buttonStyle: Styles.greyButtonStyle.copyWith(
                              backgroundColor: MaterialStateProperty.all(Color(0XFFE0E0E0)),
                              overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.5))
                            ),
                            elevation: 0.2,
                            onClick: () {
                              _viewModel.movePage(widget.position, next: false);
                            },
                            text: "Prev."
                        ),
                      ),
                    ),
                  )
              ),
              Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: Styles.statefulButton2(
                            isValid: _isCVVValid,
                            elevation: 0.2,
                            onClick: () {
                              _viewModel.movePage(widget.position);
                            },
                            text: "Next"
                        ),
                      ),
                    ),
                  )
              )
            ],
          ),
          SizedBox(height: 45)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}

///
class _CardNewPinPage extends PagedForm {

  @override
  State<StatefulWidget> createState() => _CardNewPinPagePageState();

}

class _CardNewPinPagePageState extends State<_CardNewPinPage> with AutomaticKeepAliveClientMixin {

  late CardActivationViewModel _viewModel;
  bool _isNewPinValid = false;

  @override
  void initState() {
    _viewModel = Provider.of<CardActivationViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Center(child: Text("Card Activation",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.textColorBlack
              )
          )),
          SizedBox(height: 21),
          Container(
            height: 230,
            width: double.infinity,
            padding: EdgeInsets.only(left: 70, right: 70, top: 60, bottom: 60),
            margin: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.primaryColor.withOpacity(0.1)
            ),
            child: Image.asset("res/drawables/ic_card_activation_pin.png"),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Setup your Card Transaction PIN',
              style: TextStyle(color: Colors.textColorBlack),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom * 0.7),
            child: PinEntry(onChange: (v) {
              _viewModel.setNewPin(v);
              if(v.length >= 4) {
                _isNewPinValid = true;
                FocusManager.instance.primaryFocus?.unfocus();
              } else {
                _isNewPinValid = false;
              }
              setState(() {});
            }),
          ),
          SizedBox(height: 16),
          Spacer(),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: Styles.appButton(
                            buttonStyle: Styles.greyButtonStyle.copyWith(
                                backgroundColor: MaterialStateProperty.all(Color(0XFFE0E0E0)),
                                overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.5))
                            ),
                            elevation: 0.2,
                            onClick: () {
                              _viewModel.movePage(widget.position, next: false);
                            },
                            text: "Prev."
                        ),
                      ),
                    ),
                  )
              ),
              Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: Styles.statefulButton2(
                            isValid: _isNewPinValid,
                            elevation: 0.2,
                            onClick: () {
                              _viewModel.movePage(widget.position);
                            },
                            text: "Next"
                        ),
                      ),
                    ),
                  )
              )
            ],
          ),
          SizedBox(height: 45)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}