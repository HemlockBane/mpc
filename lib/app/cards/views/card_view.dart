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

  // Widget cardFunctionItem(
  //     String title,
  //     String trailingIconRes,
  //     VoidCallback onClick,
  //     { String? subtitle, Color? trailingBackground}) {
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: onClick,
  //       child: ListTile(
  //         leading: Container(
  //           height: 50,
  //           width: 50,
  //           padding: EdgeInsets.all(10),
  //           decoration: BoxDecoration(
  //             color: trailingBackground ?? Colors.primaryColor.withOpacity(0.1),
  //             shape: BoxShape.circle,
  //           ),
  //           child: SvgPicture.asset(trailingIconRes),
  //         ),
  //         trailing: SvgPicture.asset(
  //           'res/drawables/ic_forward_anchor.svg',
  //           color: Colors.primaryColor,
  //         ),
  //         minVerticalPadding: 0,
  //         contentPadding: EdgeInsets.only(
  //             top: subtitle == null ? 8 : 0,
  //             bottom:subtitle == null ? 8 : 0,
  //             left: 16, right: 16
  //         ),
  //         title: Text(
  //           title,
  //           style: TextStyle(color: Colors.textColorMainBlack, fontSize: 16),
  //         ),
  //         subtitle: (subtitle != null)
  //             ? Align(
  //                 alignment: Alignment(-1, -1),
  //                 child: Text(
  //                   subtitle,
  //                   style: TextStyle(color: Colors.deepGrey, fontSize: 12),
  //                 ),
  //               )
  //             : null,
  //       ),
  //     ),
  //   );
  // }

  // void _displayChannelsDialog(SingleCardViewModel viewModel) async {
  //   dynamic value = await showModalBottomSheet(
  //       backgroundColor: Colors.transparent,
  //       context: _scaffoldKey.currentContext ?? context,
  //       isScrollControlled: true,
  //       builder: (context) => ChangeNotifierProvider.value(
  //           value: viewModel,
  //           child: ManageCardChannelDialog(),
  //       )
  //   );
  //
  //   if (value != null && value is Tuple<TransactionChannel, bool>) {
  //     //open card pin dialog
  //     _openCardTransactionDialog(
  //         viewModel,
  //         value.second
  //             ? CardAction.UNBLOCK_CARD_CHANNEL
  //             : CardAction.BLOCK_CARD_CHANNEL,
  //         CardTransactionRequest()..transactionChannel = value.first
  //     );
  //   }
  // }

  void _displayChangePinDialog(SingleCardViewModel viewModel) async {
    dynamic value = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: _scaffoldKey.currentContext ?? context,
        isScrollControlled: true,
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: ChangeCardPinDialog(),
        )
    );

    if (value != null && value is CardTransactionRequest) {
      _openCardTransactionDialog(viewModel, CardAction.CHANGE_PIN, value);
    }
  }

  // void _displayForBlockOrUnblock(SingleCardViewModel viewModel) async {
  //   final card = viewModel.selectedCard;
  //   if(card == null) return;
  //
  //   //User wants to unblock
  //   if(!card.blocked) {
  //     dynamic value = await showModalBottomSheet(
  //         backgroundColor: Colors.transparent,
  //         context: _scaffoldKey.currentContext ?? context,
  //         isScrollControlled: true,
  //         builder: (context) => BottomSheets.displayWarningDialog("Warning!!!", "You will have to visit a branch to unblock your card if needed! Proceed to block?", () {
  //           Navigator.of(context).pop(true);
  //         })
  //     );
  //     if(value is bool && value) {
  //       _openCardTransactionDialog(viewModel, CardAction.BLOCK_CARD, CardTransactionRequest());
  //     }
  //   }else {
  //     Navigator.of(context).pushNamed(Routes.UNBLOCK_DEBIT_CARD);
  //   }
  // }

  void _openCardTransactionDialog(SingleCardViewModel viewModel, CardAction action, CardTransactionRequest request) async {
    dynamic value = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: _scaffoldKey.currentContext ?? context,
        isScrollControlled: true,
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: CardPinDialog(action, request),
        )
    );
    if(value != null && value is Tuple<String, String>) {
      showModalBottomSheet(
          context: _scaffoldKey.currentContext ?? context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (mContext) => BottomSheets.displaySuccessModal(
              _scaffoldKey.currentContext ?? mContext,
              title: value.first,
              message: value.second,
              onClick: () {
                Navigator.of(_scaffoldKey.currentContext!).pop();
              }
          )
      );
    } else if(value is Error) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: _scaffoldKey.currentContext ?? context,
          builder: (context) => BottomSheets.displayErrorModal(context, title: "Oops", message: value.message));
    }
  }

  // Widget _pagingView(SingleCardViewModel viewModel) {
  //   bool isSelectedCardBlocked = viewModel.selectedCard?.blocked == true;
  //   return Column(
  //     children: [
  //       SizedBox(height: 16,),
  //       cardFunctionItem(
  //           'Card Channels',
  //           'res/drawables/ic_card_channels.svg', () {
  //             _displayChannelsDialog(viewModel);
  //       }, subtitle: 'Manage ATM, POS & Web Channels'),
  //       Padding(
  //           padding: EdgeInsets.only(left: 16, right: 16),
  //         child: Divider(
  //           height: 1,
  //           color: Colors.grey.withOpacity(0.2),
  //         ),
  //       ),
  //       // cardFunctionItem(
  //       //     'Card Transaction Limits',
  //       //     'res/drawables/ic_card_channels.svg', () {
  //       // }),
  //       // Padding(
  //       //   padding: EdgeInsets.only(left: 16, right: 16),
  //       //   child: Divider(
  //       //     height: 1,
  //       //     color: Colors.grey.withOpacity(0.2),
  //       //   ),
  //       // ),
  //       cardFunctionItem(
  //           'Change Card PIN',
  //           'res/drawables/ic_dialog_three_dots.svg', () {
  //         _displayChangePinDialog(viewModel);
  //       }),
  //       Padding(
  //         padding: EdgeInsets.only(left: 16, right: 16),
  //         child: Divider(
  //           height: 1,
  //           color: Colors.grey.withOpacity(0.2),
  //         ),
  //       ),
  //       cardFunctionItem(
  //           isSelectedCardBlocked ? 'Unblock Card' : "Block Card",
  //           isSelectedCardBlocked ? 'res/drawables/ic_card_unlock.svg' : "res/drawables/ic_card_locked_red.svg", () {
  //               _displayForBlockOrUnblock(viewModel);
  //       }, trailingBackground: isSelectedCardBlocked ? Colors.solidGreen.withOpacity(0.1) : Colors.red.withOpacity(0.1))
  //     ],
  //   );
  // }

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

  // Widget _displayCardOptions(SingleCardViewModel viewModel, AsyncSnapshot<Resource<List<Card>>> snap) {
  //   final data = snap.data;
  //   if (data is Success && data?.data?.isEmpty == true) {
  //     _animationController.forward();
  //     return FadeTransition(
  //         opacity: Tween<double>(begin: 0, end: 1).animate(_animationController),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             SvgPicture.asset('res/drawables/ic_empty_record_state.svg'),
  //             SizedBox(height: 24,),
  //             Text('You have no Debit Cards yet.', style: TextStyle(color: Colors.colorPrimaryDark, fontSize: 16),),
  //             SizedBox(height: 200,)
  //           ],
  //         ),
  //     );
  //   }
  //   else if(data is Error<bool>) {
  //     Tuple<String, String> error = formatError((data as Error).message,  "Cards");
  //     return Column(
  //       children: [
  //         ErrorLayoutView(error.first, error.second, (){}),
  //         SizedBox(height: 200,)
  //       ],
  //     );
  //   }
  //   return _pagingView(viewModel);
  // }

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
                          TextButton.icon(
                              onPressed: () {},
                              icon: SvgPicture.asset('res/drawables/ic_add.svg'),
                              label: Text(
                                'Add Card',
                                style: TextStyle(color: Colors.primaryColor),
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