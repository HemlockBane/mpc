import 'package:collection/src/list_extensions.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/loans/models/available_short_term_loan_offer.dart';
import 'package:moniepoint_flutter/app/loans/models/future_short_term_loan_offer.dart';
import 'package:moniepoint_flutter/app/loans/viewmodels/loan_request_viewmodel.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/info_banner_content.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/empty_list_layout_view.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:provider/provider.dart';

import 'loans_apply_for_loan_form.dart';


TextStyle getBoldStyle({
  double fontSize = 24.5,
  Color color = Colors.textColorBlack,
  FontWeight fontWeight = FontWeight.w700,
}) =>
  TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

TextStyle getNormalStyle({
  double fontSize = 11.5,
  Color color = const Color(0xffA9A5AF),
  FontWeight fontWeight = FontWeight.w400,
}) =>
  TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);


class LoanOffersView extends PagedForm {
  @override
  _LoanOffersState createState() => _LoanOffersState();

  @override
  String getTitle() => "LoanOffers";
}

class _LoanOffersState extends State<LoanOffersView> with TickerProviderStateMixin{
  late final LoanRequestViewModel _viewModel;
  final List<dynamic> _currentItems = [];
  late final AnimationController _animationController;
  late Stream<Resource<List<List<Object>?>>> loanOffersStream;


  Widget makeListView(BuildContext context, AsyncSnapshot<Resource<List<List<Object>?>>>  snapshot){
    return ListViewUtil.makeListViewWithState(
      context: context,
      snapshot: snapshot,
      animationController: _animationController,
      currentList: _currentItems,
      emptyPlaceholder: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptyLayoutView(
            "There are currently no loan products."
          )
        ],
      ),
      listView: (List<dynamic>? items){
        final availableItems = items?.first as List<AvailableShortTermLoanOffer?>?;
        final futureItems = items?.last as List<FutureShortTermLoanOffer?>?;


        return ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            if (availableItems != null && availableItems.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "Available Offers for you",
                  style: getBoldStyle(fontSize: 15.5),
                ),
              ),
            if (availableItems != null && availableItems.isNotEmpty)
              SizedBox(height: 14),
            if (availableItems != null && availableItems.isNotEmpty)
              ...availableItems.mapIndexed((idx, e){
                if (e == null) return Container();
                return _AvailableShortTermLoanOfferCard(
                  viewModel: _viewModel,
                  currentPagePosition: widget.position,
                  loanOffer: e,
                  bottomMargin: idx < availableItems.length - 1 ? 9 : null,
                );
              }).toList(),
            if (futureItems != null && futureItems.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: _getDivider(topMargin: 31, bottomMargin: 25),
              ),
            if (futureItems != null && futureItems.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "Future offers",
                  style: getBoldStyle(fontSize: 15.5),
                ),
              ),
            if (futureItems != null && futureItems.isNotEmpty)
              SizedBox(height: 13),
            if (futureItems != null && futureItems.isNotEmpty)
              ...futureItems.mapIndexed((idx, e){
                if (e == null) return Container();
                return _FutureOfferLoanCard(
                  viewModel: _viewModel,
                  currentPagePosition: widget.position,
                  loanOffer: e,
                  bottomMargin: idx < futureItems.length - 1 ? 9 : null,
                );
              }).toList(),
            SizedBox(height: 100)
          ],
        );

      },
    );

  }

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<LoanRequestViewModel>(context, listen: false);
    _animationController = AnimationController(
      vsync: this, duration: Duration(milliseconds: 1000)
    );
    loanOffersStream = _viewModel.getShortTermLoanOffers();

  }


  @override
  void dispose() {
   _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: loanOffersStream,
      builder: (ctx, AsyncSnapshot<Resource<List<List<Object>?>>> snapshot){
        return Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Loan Offers",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 33),
                makeListView(context, snapshot),
              ],
            ),
          ),
        );

      });
  }
}

class _LoanOfferBottomDetails extends StatelessWidget {
  const _LoanOfferBottomDetails({
    Key? key,
    this.buttonText,
    this.onButtonTap,
    required this.interestRate,
    required this.tenor,
  }) : super(key: key);

  final double? interestRate;
  final int? tenor;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  Widget _textButton({required String text, required VoidCallback onClick}) {
    return TextButton(
      child:
      Text(text, style: getBoldStyle(color: Colors.white, fontSize: 12.5)),
      style: TextButton.styleFrom(
        backgroundColor: Colors.solidOrange,
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
      onPressed: () {
        onClick();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Interest", style: getNormalStyle(fontSize: 12.5)),
                  SizedBox(height: 5),
                  Text("$interestRate%", style: getBoldStyle(fontSize: 13.5))
                ],
              ),
              SizedBox(width: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tenor", style: getNormalStyle(fontSize: 12.5)),
                  SizedBox(height: 5),
                  Text("$tenor days", style: getBoldStyle(fontSize: 13.5))
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 31),
        if (buttonText != null && onButtonTap != null)
          _textButton(
            text: buttonText!,
            onClick: () {
              onButtonTap!();
            })
      ],
    );
  }
}


Container _buildCard({required Widget child}) {
  return Container(
    padding: EdgeInsets.fromLTRB(16, 13, 16, 15),
    margin: EdgeInsets.symmetric(horizontal: 18),
    child: child,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      border: Border.all(
        width: 0.7, color: Colors.loanCardShadowColor.withOpacity(0.15)),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 1,
          color: Colors.loanCardShadowColor.withOpacity(0.1))
      ]),
  );
}

Widget _getDivider({double? topMargin, double? bottomMargin}) => Padding(
  padding: EdgeInsets.only(top: topMargin ?? 3, bottom: bottomMargin ?? 11),
  child: Divider(
    thickness: 1,
    color: Color(0xffF2EDE6),
  ),
);

class _FutureOfferLoanCard extends StatelessWidget {
  const _FutureOfferLoanCard({
    Key? key,
    required this.viewModel,
    required this.currentPagePosition,
    required this.loanOffer,
    this.bottomMargin
  }) : super(key: key);

  final LoanRequestViewModel viewModel;
  final int currentPagePosition;
  final FutureShortTermLoanOffer loanOffer;
  final double? bottomMargin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomMargin ?? 0),
      child: _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  "res/drawables/ic_border_line.svg",
                  color: Color(0xff656CCF2),
                ),
                SizedBox(width: 14),
                Text(
                  loanOffer.offerName ?? "",
                  style: getBoldStyle(fontSize: 14.5),
                )
              ],
            ),
            _getDivider(),
            Text("Max Amount Eligible", style: getNormalStyle(fontSize: 12.5)),
            SizedBox(height: 4),
            Text("${loanOffer.maximumAmount?.formatCurrency}", style: getBoldStyle(fontSize: 17)),
            SizedBox(height: 17),
            _LoanOfferBottomDetails(
              tenor: loanOffer.maxPeriod,
              interestRate: loanOffer.minInterestRate,

            ),
            SizedBox(height: 17),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 17),
              child: InfoBannerContent(
                title: "Eligibility",
                subtitle:
                "Take more than two starter loans to be eligible for this loan",
                svgPath: "res/drawables/ic_savings_warning.svg"),
              decoration: BoxDecoration(
                color: Color(0xff244528).withOpacity(0.05),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailableShortTermLoanOfferCard extends StatelessWidget {
  const _AvailableShortTermLoanOfferCard({
    Key? key,
    required this.viewModel,
    required this.currentPagePosition,
    required this.loanOffer,
    this.bottomMargin
  }) : super(key: key);

  final LoanRequestViewModel viewModel;
  final int currentPagePosition;
  final AvailableShortTermLoanOffer loanOffer;
  final double? bottomMargin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomMargin ?? 0),
      child: _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset("res/drawables/ic_border_line.svg"),
                SizedBox(width: 14),
                Text(
                  loanOffer.offerName ?? "",
                  style: getBoldStyle(fontSize: 14.5),
                )
              ],
            ),
            _getDivider(),
            Text("Max Amount Eligible", style: getNormalStyle(fontSize: 12.5)),
            SizedBox(height: 4),
            Text("${loanOffer.maximumAmount?.formatCurrency}",
              style: getBoldStyle(fontSize: 17)),
            SizedBox(height: 17),
            _LoanOfferBottomDetails(
              buttonText: "Apply for offer",
              onButtonTap: () {
                viewModel.setSelectedLoanOffer(loanOffer);
                viewModel.moveToNext(currentPagePosition);
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (ctx) => ChangeNotifierProvider.value(
                //     value: viewModel,
                //   child: Scaffold(body: ApplyForLoanView()),)
                //   )
                // );
              },
              tenor: loanOffer.maxPeriod,
              interestRate: loanOffer.minInterestRate,
            )
          ],
        ),
      ),
    );
  }
}

