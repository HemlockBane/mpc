import 'package:flutter/material.dart' hide Colors, Card;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/single_card_view_model.dart';
import 'package:moniepoint_flutter/app/cards/views/utils/card_view_util.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';

import '../card_list_option_item.dart';

class AddCardDialog extends StatelessWidget {

  final BuildContext context;
  final SingleCardViewModel viewModel;

  AddCardDialog({
    required this.context,
    required this.viewModel
  });

  late final _addCardOptions = List<Widget>.of([
    CardListOptionItem(
        onClick: (item, num) {
          Navigator.of(context).pop();
          CardViewUtil.processGetCardNow(context, viewModel, item);
        },
        title: "Get Card Now",
        subTitle: "From Agent Location",
        leadingIcon: SvgPicture.asset("res/drawables/ic_get_card.svg"),
        processOnClick: (viewModel.userAccounts.length <= 1)
          ? () => viewModel.isAccountBalanceSufficient(null)
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

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet2(
      curveBackgroundColor: Colors.white,
      centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
      contentBackgroundColor: Colors.white,
      centerBackgroundPadding: 4,
      dialogIcon: Column(
        children: [
          SizedBox(height: 10),
          SvgPicture.asset(
            'res/drawables/ic_add_card_single.svg',
            width: 46,
            height: 46,
          )
        ],
      ),
      content: Wrap(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
            child: Column(
              children: [
                Text("Add Card",
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    )
                ),
                SizedBox(height: 16),
                Container(
                  height: 300,
                  child: ListView.separated(
                    itemCount: _addCardOptions.length,
                    separatorBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Divider(color: Color(0XFFE8F0F6), height: 1, thickness: 0.5,),
                    ),
                    itemBuilder: (mContext, index) {
                      return _addCardOptions[index];
                    },
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }

}



///Helper to show add card dialog
///
///
///
Future<dynamic> showAddCard({
  required BuildContext context, required SingleCardViewModel viewModel
})  {
  return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) => AddCardDialog(context: ctx, viewModel: viewModel,)
  );
}