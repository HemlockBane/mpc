import 'package:flutter/material.dart' hide Colors, Card;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_request_balance_response.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/single_card_view_model.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/insufficient_funds_dialog.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/select_account_dialog.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/unlink_card_warning_dialog.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/card_util.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/main.dart';

class CardViewUtil {
  static String getFirst6Digits(Card card) {
    String? maskedPan = card.maskedPan;
    if (maskedPan.length < 6) return "";
    final first6 = maskedPan.substring(0, 6);
    return "${first6.substring(0, 4)} ${first6.substring(4, 6)}";
  }

  static String getLast4Digits(Card card) {
    String? maskedPan = card.maskedPan;
    if (maskedPan.length < 16) return "";
    return maskedPan.substring(maskedPan.length - 4, maskedPan.length);
  }

  static String getCardExpiryDate(Card card) {
    String? expiryDate = card.expiryDate;
    if (expiryDate == null || expiryDate.length < 4) return "";
    return "${expiryDate.substring(expiryDate.length - 2)}/${expiryDate.substring(0, 2)}";
  }

  static Color getCardBackground(Card card) {
    if(card.blocked) return Color(0XFFE14E4F).withOpacity(0.88);
    if(!card.isActivated) return Colors.deepGrey;
    return Colors.primaryColor;
  }

  static Widget getCardBrandLogo(Card card, {String? resource}) {
    if (CardUtil.isMasterCard(card.maskedPan))
      return SvgPicture.asset(
        'res/drawables/ic_master_card.svg',
        height: 16,
      );
    if (CardUtil.isVerveCard(card.maskedPan))
      return SvgPicture.asset(resource ?? 'res/drawables/ic_verve_card.svg');
    if (CardUtil.isVisaCard(card.maskedPan))
      return SvgPicture.asset('res/drawables/ic_visa_card.svg',);
    else
      return Container();
  }

  static String getCardName(String maskedPan) {
    if (CardUtil.isMasterCard(maskedPan))
      return "Mastercard";
    if (CardUtil.isVerveCard(maskedPan))
      return "Verve";
    if (CardUtil.isVisaCard(maskedPan))
      return "Visa";
    else
      return "";
  }

  static Widget getBlockedCardBanner() {
    return SizedBox(
      width: 160,
      height: 40,
      child: Stack(
        children: [
          Positioned(
              right: 0,
              top: 7,
              bottom: 7,
              child: Container(
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.only(left: 8, right: 24, top: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: Color(0XFF381212).withOpacity(0.4),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomLeft: Radius.circular(6))),
                child: Text(
                  "BLOCKED",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              )),
          Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 38,
                height: 38,
                padding: EdgeInsets.only(left: 9, right: 9, bottom: 5, top: 5),
                decoration: new BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: SvgPicture.asset('res/drawables/ic_warning.svg',
                    color: Colors.red),
              )),
        ],
      ),
    );
  }

  static Widget getInactiveCardBanner() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(right: 25.5),
          padding: EdgeInsets.only(left: 8, right: 16, top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: Color(0XFF122138).withOpacity(0.4),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6))
          ),
          child: Text(
            "INACTIVE",
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
          ),),
        Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SvgPicture.asset('res/drawables/ic_moniepoint_cube_2.svg')
        ),
      ],
    );
  }


  static Widget getCardStateBanner(Card card) {
    if(card.blocked) return getBlockedCardBanner();
    if(!card.isActivated) return getInactiveCardBanner();
    return Row(
      children: [
        SvgPicture.asset('res/drawables/ic_moniepoint_cube.svg'),
      ],
    );
  }


  ///TODO refactor so it's easier to understand what happens here
  ///
  ///
  ///
  ///Starts the get card process
  ///checks that all the necessary conditions are in place
  static void processGetCardNow(
      BuildContext context,
      SingleCardViewModel viewModel,
      Tuple<Resource<dynamic>, dynamic>? callbackData) async {

    ///Checks if the account currently has a card
    void checkAccountAndProceed(String accountNumber, num customerAccountId) async {
      Card? card = await viewModel.getCardByAccountNumber(accountNumber);
      //If card is not null it means this account already have a card
      if(card != null) {
        final shouldUnlink = await showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: navigatorKey.currentContext ?? context,
            builder: (ctx) {
              return UnlinkCardWarningDialog(
                  cardPan: card.maskedPan,
                  accountNumber: card.customerAccountCard?.customerAccountNumber ?? ""
              );
            }
        );
        if(shouldUnlink is bool && shouldUnlink) {
          await Future.delayed(Duration(milliseconds: 400), () => true);
          await navigatorKey.currentState?.pushNamed(
              Routes.CARD_QR_SCANNER, arguments: {"customerAccountId": customerAccountId});
        }
      } else {
        await Future.delayed(Duration(milliseconds: 400), () => true);
        await navigatorKey.currentState?.pushNamed(
            Routes.CARD_QR_SCANNER, arguments: {"customerAccountId": customerAccountId});
      }
    }

    void checkResponse(Resource<dynamic>? response , String accountNumber, num customerAccountId) {
      if(response is Success<CardRequestBalanceResponse>) {
        final balanceResponse = response.data;
        if(balanceResponse?.sufficient == true) {
          //check if the user has a card already
          checkAccountAndProceed(accountNumber, customerAccountId);
        } else {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              context: navigatorKey.currentContext ?? context,
              builder: (ctx) {
                return InsufficientFundsDialog(
                    accountBalance: balanceResponse?.availableBalance ?? "0.0",
                    cardCost: balanceResponse?.cardAmount ?? "");
              });
        }
      }
      else if(response is Error<CardRequestBalanceResponse>){
        showError(
            navigatorKey.currentContext ?? context,
            title: "Failed to retrieve card cost!",
            message: response.message
        );
      }
    }

    final hasMultipleAccounts = viewModel.userAccounts.length > 1;

    if(callbackData == null && hasMultipleAccounts) {
      final value = await showCustomerAccounts(
          context: context,
          userAccounts: viewModel.userAccounts,
          onItemClick: (account)  {
            return viewModel.isAccountBalanceSufficient(
                account.customerAccount?.accountNumber
            );
          }
      );

      if(value is Tuple) {
        final userAccount = value.second as UserAccount;
        checkResponse(
            value.first,
            userAccount.customerAccount!.accountNumber!,
            userAccount.customerAccount!.id!
        );
      }
      return;
    }

    //This is for single accounts
    checkResponse(callbackData?.first, viewModel.accountNumber, viewModel.customerAccountId);
  }
}
