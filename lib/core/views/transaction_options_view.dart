import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/styles.dart';

import '../colors.dart';

class TransactionOptionsView extends StatelessWidget {

  final bool displayShareReceipt;
  final bool displayDownloadReceipt;
  final bool displayReplayTransaction;
  final bool displayInitiateDispute;
  final double padding;
  final OnItemClickListener<String, int>? onItemClickListener;

  TransactionOptionsView({
    this.displayShareReceipt = true,
    this.displayDownloadReceipt = true,
    this.displayReplayTransaction = true,
    this.displayInitiateDispute = true,
    this.onItemClickListener,
    this.padding = 24
  });

  Widget initialView({Color? backgroundColor, required Widget image}) {
    return Container(
      width: 38,
      height: 38,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.primaryColor.withOpacity(0.1)
      ),
      child: Center(
        child: image,
      ),
    );
  }

  Widget makeItem(String title, String res) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onItemClickListener?.call(title, 0),
        child: Container(
          padding: EdgeInsets.only(left: padding, right: padding, top: 10, bottom: 10),
          child: Row(
            children: [
              initialView(
                  image: SvgPicture.asset(res, color: Colors.primaryColor,)
              ),
              SizedBox(width: 16,),
              Text(title, style: TextStyle(color: Colors.colorPrimaryDark, fontSize: 16),)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: padding, right: padding),
            child: Text('Options', style: TextStyle(fontSize: 14, color: Colors.colorPrimaryDark, fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 7,),
        Visibility(
            visible: this.displayShareReceipt,
            child: Expanded(
                child: makeItem('Share Receipt', 'res/drawables/ic_share_receipt.svg')
            )),
        Visibility(
            visible: this.displayDownloadReceipt,
            child: Padding(
              padding: EdgeInsets.only(left: padding, right: padding),
              child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.15),),
            )
        ),
        Visibility(
            visible: this.displayDownloadReceipt,
            child: Expanded(
                child: makeItem('Download Receipt', 'res/drawables/ic_download_receipt.svg')
            )),
        Visibility(
            visible: this.displayReplayTransaction,
            child: Padding(
              padding: EdgeInsets.only(left: padding, right: padding),
              child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.15),),
            )
        ),
        Visibility(
            visible: this.displayReplayTransaction,
            child: Expanded(
                child: makeItem('Replay this Transaction', 'res/drawables/ic_replay_transaction.svg')
            )),
      ],
    );
  }
}