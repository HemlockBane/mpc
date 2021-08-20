import 'package:flutter/material.dart' hide Colors, Card;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_transaction_request.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/single_card_view_model.dart';
import 'package:moniepoint_flutter/app/cards/views/card_list_empty_view.dart';
import 'package:moniepoint_flutter/app/cards/views/card_list_item.dart';
import 'package:moniepoint_flutter/app/cards/views/card_view_shimmer.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/card_pin_dialog.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/change_card_pin_dialog.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/manage_card_channels_dialog.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

class CardScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _CardScreen();

}

class _CardScreen extends State<CardScreen> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
  );

  final List<Card> _currentItems = [];
  final PageController _scrollController = PageController();

  Widget _cardList(BuildContext context, AsyncSnapshot<Resource<List<Card>>> a) {
    return Expanded(
        child: ListViewUtil.makeListViewWithState(
            context: context,
            snapshot: a,
            animationController: _animationController,
            currentList: _currentItems,
            emptyPlaceholder: CardListEmptyView(),
            listView: (List<Card>? items) {
              return ListView.separated(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  controller: _scrollController,
                  itemCount: items?.length ?? 0,
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: SizedBox(height: 0,),
                  ),
                  itemBuilder: (context, index) {
                    return CardListItem(items![index], index, (card, i) {

                    });
                  });
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SingleCardViewModel>(context, listen: false);

    return SessionedWidget(
        context: context,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(0XFFEAF4FF),
          appBar: AppBar(
              centerTitle: false,
              titleSpacing: -12,
              iconTheme: IconThemeData(color: Colors.primaryColor),
              title: Text('Card Management',
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
          body: StreamBuilder(
              stream: viewModel.getCards(),
              builder: (BuildContext context, AsyncSnapshot<Resource<List<Card>>> snap) {
                if(!snap.hasData || snap.data is Loading) {
                  return CardViewShimmer();
                }
                return Column(
                  children: [
                    SizedBox(height: 36,),
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Cards',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Visibility(
                              visible: snap.data?.data?.isEmpty == false,
                              child: TextButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(Routes.ADD_CARD);
                                  },
                                  icon: SvgPicture.asset('res/  drawables/ic_add.svg'),
                                  label: Text(
                                    'Add Card',
                                    style: TextStyle(color: Colors.primaryColor),
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 24,),
                    _cardList(context, snap)
                  ],
                );
              }
          ),
        ),
    );
  }

}