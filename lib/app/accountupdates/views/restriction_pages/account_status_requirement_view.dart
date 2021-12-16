import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_update_flag.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/tuple.dart';

import '../document_verification_view.dart';


///@author Paul Okeke

class AccountStatusRequirementView extends StatefulWidget {

  AccountStatusRequirementView({
    required this.userAccount,
    this.requirementMode = AccountRequirementMode.UPGRADE_INFO,
  });

  final AccountRequirementMode requirementMode;
  final UserAccount? userAccount;

  @override
  State<StatefulWidget> createState() => AccountStatusRequirementState();

}

class AccountStatusRequirementState extends State<AccountStatusRequirementView> {

  final _AccountRequirementItem _additionalInfoItem = _AccountRequirementItem(
    title: "Additional Info",
    subTitle: "Your Residential Address, Next of Kin Details, etc.",
    imageRes: "res/drawables/ic_add.svg"
  );

  final _AccountRequirementItem _identificationItem = _AccountRequirementItem(
      title: "Identification",
      imageRes: "res/drawables/ic_bank_number_input.svg",
      subTitle: "e.g National ID / NIN, Driver’s License, International Passport, Voter’s Card"
  );

  final _AccountRequirementItem _proofOfAddressItem = _AccountRequirementItem(
      title: "Proof of Address",
      imageRes: "res/drawables/ic_location.svg",
      subTitle: "e.g Utility Bills (e.g. electricity bills), Tenency Agreements, Resident Permits"
  );


  List<Widget> _buildItemViews(UserAccount userAccount) {
    final List<_AccountRequirementItem> _items = [];

    if(widget.requirementMode == AccountRequirementMode.UPGRADE_INFO
        || widget.requirementMode == AccountRequirementMode.POST_NO_DEBIT) {
      //We are only going to add what has not been supplied

      final additionalInfoFlag = userAccount.accountStatus?.additionalInfoFlag
          ?? userAccount.parentCustomer?.additionalInfoFlag;

      final idFlag = userAccount.accountStatus?.identificationProofFlag
          ?? userAccount.parentCustomer?.identificationProofFlag;

      final addressFlag = userAccount.accountStatus?.addressProofFlag
          ?? userAccount.parentCustomer?.addressProofFlag;

      if(additionalInfoFlag?.status == false) _items.add(_additionalInfoItem);
      if(idFlag?.status == false) _items.add(_identificationItem);
      if(addressFlag?.status == false) _items.add(_proofOfAddressItem);
    }

    if(widget.requirementMode == AccountRequirementMode.REGULARIZE_DOCUMENT) {
      final shouldReUploadId = userAccount.shouldReUploadIdentification();
      final shouldReUploadProof = userAccount.shouldReUploadProofOfAddress();

      if(shouldReUploadId == true) _items.add(_identificationItem);
      if(shouldReUploadProof == true) _items.add(_proofOfAddressItem);
    }

    if(widget.requirementMode == AccountRequirementMode.IN_PROGRESS) {
      //We need to check document upload that's currently in progress
      final idFlag = userAccount.accountStatus?.identificationVerificationFlag
          ?? userAccount.parentCustomer?.identificationVerificationFlag;

      final addressFlag = userAccount.accountStatus?.addressVerificationFlag
          ?? userAccount.parentCustomer?.addressVerificationFlag;

      final verificationTime = DocumentVerificationScreen.getMaxDocumentVerificationTime(idFlag, addressFlag);

      final isIdVerified = idFlag?.verificationStates == VerificationState.PASSED;
      final isAddressVerified = addressFlag?.verificationStates == VerificationState.PASSED;

      _items.add(
          _identificationItem
            ..isVerified = isIdVerified
            ..subTitle = isIdVerified == true ? "Document Verified" : "Document Verification in progress"
            ..subTitleTwo = isIdVerified == false ? "Expect Verification on or before {$verificationTime}" : null
      );
      _items.add(
          _proofOfAddressItem
            ..isVerified = isAddressVerified
            ..subTitle = isAddressVerified == true ? "Document Verified" : "Document Verification in progress"
            ..subTitleTwo = isAddressVerified == false ? "Expect Verification on or before\n{$verificationTime}" : null
      );
    }

    final views = _items.map((e) => _AccountRequirementItemView(item: e));
    return views.foldIndexed(<Widget>[], (index, List<Widget> previous, element) {
      previous.add(element);
      if (index < _items.length - 1) {
        previous.add(Divider(height: 1, color: Colors.primaryColor.withOpacity(0.22)));
      }
      return previous;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.userAccount == null) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.only(left: 18, right: 18, bottom: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.7, color: Color(0XFF0357EE).withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
                color: Color(0XFF0E4FB1).withOpacity(0.12),
                offset: Offset(0,1),
                blurRadius: 2
            )
          ]
      ),
      child: Column(children: _buildItemViews(widget.userAccount!)),
    );
  }

}

class _AccountRequirementItem {

  _AccountRequirementItem({
    required this.title,
    this.subTitle = "",
    this.subTitleTwo,
    required this.imageRes,
    this.isVerified
  });

  final String title;
  final String imageRes;
  String subTitle;
  String? subTitleTwo;
  bool? isVerified;
}

///_AccountRequirementItemView
///
///
///
class _AccountRequirementItemView extends StatelessWidget {

  _AccountRequirementItemView({
    required this.item
  });

  final _AccountRequirementItem item;

  Widget displayVerifiedState() {
    if(item.isVerified == null) return SizedBox.shrink();

    if(item.isVerified == true) {
      return SvgPicture.asset("res/drawables/ic_circular_check_mark.svg", width: 26, height: 26,);
    }

    return Lottie.asset('res/drawables/progress_bar_lottie.json', width: 26, height: 26);
  }

  Widget _displaySubTitleTwo() {
    if (item.subTitleTwo == null) return SizedBox.shrink();
    //Text within curl braces are used to determine text that should be bold
    //We only accept only one of this pattern as required.
    final openBracketIndex = item.subTitleTwo!.indexOf("{");
    final closeBracketIndex = item.subTitleTwo!.indexOf("}", openBracketIndex != -1 ? openBracketIndex : 0);

    final boldText = (closeBracketIndex > openBracketIndex)
        ? item.subTitleTwo!.substring(openBracketIndex + 1, closeBracketIndex)
        : "";

    return Text(
      item.subTitleTwo!.replaceAll("{", "").replaceAll("}", ""),
      style: TextStyle(
          color: Colors.textColorBlack.withOpacity(0.5),
          fontSize: 12,
          fontWeight: FontWeight.normal,
          height: 1.5
      ),
    ).colorText({boldText : Tuple(Colors.textColorBlack.withOpacity(0.5), null)}, underline: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20, top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 26,
            height: 21,
            child: SvgPicture.asset(item.imageRes, color: Colors.primaryColor, width: 26, height: 21,),
          ),
          SizedBox(width: 15),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(color: Colors.textColorBlack, fontSize: 15, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 3),
              Text(
                item.subTitle,
                style: TextStyle(
                    color: Colors.textColorBlack,
                    fontSize: 13,
                    fontWeight: FontWeight.normal
                ),
              ),
              if(item.subTitleTwo != null) SizedBox(height: 3),
              _displaySubTitleTwo()
            ],
          )),
          Align(
            heightFactor: item.isVerified == true ? 1.5 : 2,
            child: displayVerifiedState(),
          ),
        ],
      ),
    );
  }
}

enum AccountRequirementMode {
  POST_NO_DEBIT, REGULARIZE_DOCUMENT, IN_PROGRESS, UPGRADE_INFO
}