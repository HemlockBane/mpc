import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/single_card_view_model.dart';
import 'package:moniepoint_flutter/app/cards/views/card_list_option_item.dart';
import 'package:moniepoint_flutter/app/cards/views/utils/card_view_util.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:provider/provider.dart';

///@author Paul Okeke
class CardListEmptyView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _CardListEmptyViewState();

}

class _CardListEmptyViewState extends State<CardListEmptyView> {

  late final SingleCardViewModel _viewModel;

  late final _emptyCardOptions = List<Widget>.of([
    CardListOptionItem(
        onClick: (callback, _) {
          CardViewUtil.processGetCardNow(context, _viewModel, callback);
        },
        title: "Get Card Now",
        subTitle: "From Agent Location",
        leadingIcon: SvgPicture.asset("res/drawables/ic_get_card.svg"),
        processOnClick: (!hasMultipleAccounts())
            ? () => _viewModel.isAccountBalanceSufficient(null)
            : null,
    ),
    CardListOptionItem(
        onClick: null,
        title: "Card Delivery",
        subTitle: "Coming Soon",
        leadingIcon: SvgPicture.asset("res/drawables/ic_card_delivery.svg")
    ),
    CardListOptionItem(
        onClick: null,
        title: "Virtual Card",
        subTitle: "Coming Soon",
        leadingIcon: SvgPicture.asset("res/drawables/ic_virtual_card_web.svg")
    ),
  ]);

  bool hasMultipleAccounts() {
    return _viewModel.userAccounts.length > 1;
  }

  @override
  void initState() {
    _viewModel = Provider.of<SingleCardViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            left: 16,
            right: 16,
            child: _EmptyCardBannerView()
        ),
        Positioned(
            top: 125,
            left: 0,
            right: 0,
            bottom: 0,
            child: _EmptyCardListOptionsView(options: _emptyCardOptions)
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}



///_EmptyCardBannerView
///
///
///
///
///
class _EmptyCardBannerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 160,
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.primaryColor.withOpacity(0.1)
      ),
      child: Column(
        children: [
          SvgPicture.asset('res/drawables/ic_add_card.svg'),
          SizedBox(height: 0,),
          Text(
            'Request for a new debit card\nor virtual card',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.solidDarkBlue,
                fontSize: 15
            ),
          )
        ],
      ),
    );
  }

}

///_EmptyCardListOptionsView
///
///
///
///
///
///
class _EmptyCardListOptionsView extends StatelessWidget {

  final List<Widget> options;

  _EmptyCardListOptionsView({required this.options});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                color: Colors.primaryColor.withOpacity(0.05),
                offset: Offset(0, -10),
                blurRadius: 6,
                spreadRadius: 0
            )
          ]
      ),
      child: ListView.separated(
        itemCount: options.length,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Divider(color: Color(0XFFE8F0F6), height: 1, thickness: 0.5,),
        ),
        itemBuilder: (mContext, index) {
          return options[index];
        },
      ),
    );
  }

}