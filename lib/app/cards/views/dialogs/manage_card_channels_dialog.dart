import 'package:flutter/material.dart' hide Colors, Card;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_transaction_request.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/single_card_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import 'card_pin_dialog.dart';

class ManageCardChannelDialog extends StatefulWidget{

  final num cardId;

  ManageCardChannelDialog(this.cardId);

  @override
  State<StatefulWidget> createState() => _ManageCardChannelDialog();

}

class _ManageCardChannelDialog extends State<ManageCardChannelDialog> {

  Card? _card;

  List<_ChannelItem> transactionChannels = List.unmodifiable([
    _ChannelItem("Enable Web", TransactionChannel.WEB, 'ic_channel_web.svg'),
    _ChannelItem("Enable POS", TransactionChannel.POS, 'ic_channel_pos.svg'),
    _ChannelItem("Enable ATM", TransactionChannel.ATM, 'ic_channel_atm.svg'),
  ]);

  void _onItemSelected(bool enabled, _ChannelItem item) {
    final viewModel = Provider.of<SingleCardViewModel>(context, listen: false);
    item.isEnabled = enabled;
    setState(() {});

    _updateCardChannel(enabled, item);

    Future.delayed(Duration(milliseconds: 400), () async {
      final value  = await _openCardTransactionDialog(
          viewModel,
          (enabled) ? CardAction.UNBLOCK_CARD_CHANNEL : CardAction.BLOCK_CARD_CHANNEL,
          CardTransactionRequest()
            ..cardId = _card?.id
            ..transactionChannel = item.channel
      );
      if(!value){
        item.isEnabled = !item.isEnabled;
        _updateCardChannel(item.isEnabled, item);
        setState(() {});
      }
    });

  }

  void _updateCardChannel(bool enabled, _ChannelItem item) {
    if(item.channel == TransactionChannel.WEB) _card?.channelBlockStatus?.web = !enabled;
    if(item.channel == TransactionChannel.POS) _card?.channelBlockStatus?.pos = !enabled;
    if(item.channel == TransactionChannel.ATM) _card?.channelBlockStatus?.atm = !enabled;
  }

  bool isChannelEnabledForCard(SingleCardViewModel viewModel, TransactionChannel channel) {
    if(channel == TransactionChannel.WEB) {
      return _card?.channelBlockStatus?.web == false;
    }
    if(channel == TransactionChannel.POS) {
      return _card?.channelBlockStatus?.pos == false;
    }
    if(channel == TransactionChannel.ATM) {
      return _card?.channelBlockStatus?.atm == false;
    }
    return false;
  }

  Future<bool> _openCardTransactionDialog(SingleCardViewModel viewModel,
      CardAction action, CardTransactionRequest request) async {

    dynamic value = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: CardPinDialog(action, request),
        )
    );
    if(value != null && value is Tuple<String, String>) {
      await showSuccess(
          context,
          title: value.first,
          message: value.second,
          onPrimaryClick: () {
            Navigator.of(context).pop();
          }
      );
      return true;
    } else if(value is Error) {
      await showError(context, title: "Card Operation Failed!", message: value.message);
      return false;
    }
    return false;
  }

  initState() {
    super.initState();
  }

  List<Widget> generateTiles() {
    return transactionChannels.map((e) {
      return SwitchListTile(
          title: Text(e.title, style: TextStyle(
              color: Colors.textColorMainBlack, fontSize: 17, fontWeight: FontWeight.w600
          ),),
          secondary: Container(
            width: 60,
            height: 60,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle
            ),
            child: SvgPicture.asset('res/drawables/${e.icon}', color: Colors.primaryColor,),
          ),
          activeColor: Colors.primaryColor,
          activeTrackColor: Colors.deepGrey.withOpacity(0.5),
          inactiveTrackColor: Colors.grey.withOpacity(0.5),
          inactiveThumbColor: Colors.white.withOpacity(0.5),
          value: e.isEnabled,
          onChanged: (v) => _onItemSelected(v, e));
    }).foldIndexed(<Widget>[], (index, List<Widget> previous, element) {
      previous.add(element);
      if(index != (transactionChannels.length -1)) {
        previous.add(Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Divider(height: 1, color: Colors.grey.withOpacity(0.2),),
        ));
      }
      return previous;
    }).toList();
  }

  void _initTransactionChannels(SingleCardViewModel viewModel) {
    transactionChannels.forEach((element) {
      element.isEnabled = isChannelEnabledForCard(viewModel, element.channel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SingleCardViewModel>(context, listen: false);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: false,
            titleSpacing: -12,
            iconTheme: IconThemeData(color: Colors.primaryColor),
            title: Text('Manage Channels',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.darkBlue,
                    fontFamily: Styles.defaultFont,
                    fontSize: 17
                )
            ),
            backgroundColor: Colors.transparent,
            elevation: 0
        ),
      body: FutureBuilder(
          future: viewModel.getSingleCard(widget.cardId),
          builder: (mContext, AsyncSnapshot<Card?> snapShot) {
            if(!snapShot.hasData) return Container();
            _card = snapShot.data;
            _initTransactionChannels(viewModel);
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 36),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text('Managed Channels',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.textColorBlack
                        )
                    ),
                  ),
                  SizedBox(height: 30,),
                  ...generateTiles()
                ],
              ),
            );
          }
      ),
    );
  }
}

class _ChannelItem {
  final String title;
  final TransactionChannel channel;
  final String icon;
  bool isEnabled = false;

  _ChannelItem(this.title, this.channel, this.icon, {this.isEnabled = false});
}