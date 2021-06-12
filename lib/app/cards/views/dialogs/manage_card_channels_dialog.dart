
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/single_card_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ManageCardChannelDialog extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _ManageCardChannelDialog();

}

class _ManageCardChannelDialog extends State<ManageCardChannelDialog> {
  List<_ChannelItem> transactionChannels = List.unmodifiable([
    _ChannelItem("Enable Web", TransactionChannel.WEB, 'ic_channel_web.svg'),
    _ChannelItem("Enable POS", TransactionChannel.POS, 'ic_channel_pos.svg'),
    _ChannelItem("Enable ATM", TransactionChannel.ATM, 'ic_channel_atm.svg'),
  ]);

  void _onItemSelected(bool enabled, _ChannelItem item) {
    final viewModel = Provider.of<SingleCardViewModel>(context, listen: false);
    item.isEnabled = enabled;
    setState(() {});
    if(item.channel == TransactionChannel.WEB) viewModel.selectedCard?.channelBlockStatus?.web = !enabled;
    if(item.channel == TransactionChannel.POS) viewModel.selectedCard?.channelBlockStatus?.pos = !enabled;
    if(item.channel == TransactionChannel.ATM) viewModel.selectedCard?.channelBlockStatus?.atm = !enabled;
    Future.delayed(Duration(milliseconds: 400), (){
      Navigator.of(context).pop(Tuple(item.channel, enabled));
    });
  }

  bool isCardChannelEnabledForChannel(SingleCardViewModel viewModel, TransactionChannel channel) {
    if(channel == TransactionChannel.WEB) {
      return viewModel.selectedCard?.channelBlockStatus?.web == false;
    }
    if(channel == TransactionChannel.POS) {
      return viewModel.selectedCard?.channelBlockStatus?.pos == false;
    }
    if(channel == TransactionChannel.ATM) {
      return viewModel.selectedCard?.channelBlockStatus?.atm == false;
    }
    return false;
  }

  initState() {
    final viewModel = Provider.of<SingleCardViewModel>(context, listen: false);
    transactionChannels.forEach((element) {
      element.isEnabled = isCardChannelEnabledForChannel(viewModel, element.channel);
    });
    super.initState();
  }

  List<Widget> generateTiles() {
    return transactionChannels.map((e) {
      return SwitchListTile(
          title: Text(e.title, style: TextStyle(color: Color(0XFF4F4F4F), fontSize: 17),),
          activeColor: Colors.solidOrange,
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
          activeTrackColor: Colors.solidOrange.withOpacity(0.5),
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

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet(
      curveBackgroundColor: Colors.white,
      centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
      contentBackgroundColor: Colors.white,
      centerImageRes: 'res/drawables/ic_card_channels.svg',
      centerImageHeight: 18,
      centerImageWidth: 18,
      centerBackgroundHeight: 74,
      centerBackgroundWidth: 74,
      centerBackgroundPadding: 14,
      height: 500,
      content: Container(
        child: Column(
          children: [
            SizedBox(height: 22),
            Center(
              child: Text('Managed Channels',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.solidDarkBlue)),
            ),
            SizedBox(height: 30,),
            ...generateTiles()
          ],
        ),
      )
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