import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_advert.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_eligibility_criteria.dart';
import 'package:moniepoint_flutter/app/loans/viewmodels/loan_advert_view_model.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_loan_application_view.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/info_banner_content.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/interest_rate_banner.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/padded_divider.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/views/error_layout_view.dart';
import 'package:provider/provider.dart';

const double toolBarMarginTop = 37;
const double maxDraggableTop = toolBarMarginTop * 5 + 26;
const String loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua";

class LoanAdvertDetailsView extends StatefulWidget {
  const LoanAdvertDetailsView({Key? key, required this.loanAdvert})
      : super(key: key);

  final ShortTermLoanAdvert? loanAdvert;

  @override
  State<LoanAdvertDetailsView> createState() => _LoanAdvertDetailsViewState();
}

class _LoanAdvertDetailsViewState extends State<LoanAdvertDetailsView> {
  Stream<Resource<ShortTermLoanEligibilityCriteria>> _eligibilityStream =
      Stream.empty();
  late final LoanAdvertViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<LoanAdvertViewModel>(context, listen: false);
    _eligibilityStream = viewModel.getEligibility();
  }

  TextStyle getBoldStyle(
          {double fontSize = 32.5,
          Color color = Colors.textColorBlack,
          FontWeight fontWeight = FontWeight.w700}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  TextStyle getNormalStyle(
          {double fontSize = 32.5,
          Color color = Colors.white,
          FontWeight fontWeight = FontWeight.w400}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  Widget getSuccessContent() {
    return Container(
      padding: EdgeInsets.only(top: 19, bottom: 22, left: 21, right: 21),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.19),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Your Flex Savings Acc. No.",
            style: getNormalStyle(fontSize: 14),
          ),
          SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "0011357716",
                style: getBoldStyle(fontSize: 24, color: Colors.white),
              ),
              Row(
                children: [
                  SvgPicture.asset("res/drawables/ic_copy_2.svg"),
                  SizedBox(width: 7),
                  Text(
                    "Copy",
                    style: getNormalStyle(fontSize: 15),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget checkIcon(bool isEligible, {Size? size}) {
    return SvgPicture.asset(
      "res/drawables/ic_check_mark_round_alt.svg",
      color: isEligible ? Colors.solidGreen : Colors.loanGrey,
      height: size?.height ?? 25.83,
      width: size?.width ?? 25.83,
    );
  }

  Widget eligibilityCard({required bool isEligible, required Widget child}) {
    return Container(
      padding: EdgeInsets.only(left: 18, top: 21, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Eligibility Check',
            style: getBoldStyle(fontSize: 17),
          ),
          SizedBox(height: isEligible ? 13 : 19),
          child
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Color(0xff1A1C9328), width: 0.7),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Colors.loanCardShadowColor.withOpacity(0.1),
          )
        ],
      ),
    );
  }

  Widget eligibleMessage(
      {required bool isEligible, required ShortTermLoanAdvert? loanAdvert}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        checkIcon(isEligible),
        SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'You’re eligible to take a loan of',
                    style: getNormalStyle(
                            fontSize: 15, color: Colors.textColorBlack)
                        .copyWith(height: 1.3),
                  ),
                  TextSpan(
                    text: '\n${loanAdvert?.maxAmount?.formatCurrency}',
                    style: getBoldStyle(
                        fontSize: 15, color: Colors.textColorBlack),
                  ),
                  TextSpan(
                    text: ' from us. Apply now',
                    style: getNormalStyle(
                        fontSize: 15, color: Colors.textColorBlack),
                  )
                ]),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
        SizedBox(width: 30),
      ],
    );
  }

  Widget messageTile({required bool isPassed, required bool isNotLast}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkIcon(isPassed, size: Size(20, 20)),
            SizedBox(width: 9),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Text(
                      loremIpsum,
                      style:
                          getNormalStyle(fontSize: 15, color: Colors.textColorBlack)
                              .copyWith(height: 1.1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Text(
                      loremIpsum,
                      style: getNormalStyle(
                              fontSize: 14,
                              color: Colors.textColorBlack.withOpacity(0.4))
                          .copyWith(height: 1.3),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        if (isNotLast)
          PaddedDivider(
            top: 10, bottom: 10,
            dividerColor: Color(0xffE5E5E5),
            dividerThickness: 0.6, right: 20.58,
          )
      ],
    );
  }

  Widget notEligibleMessage(
      {required ShortTermLoanEligibilityCriteria? criteria}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (criteria != null &&
            criteria.passedCriteria != null &&
            criteria.passedCriteria!.isNotEmpty)
          ...criteria.passedCriteria!.mapIndexed((idx, e) => messageTile(
                  isPassed: true,
                  isNotLast: idx < criteria.passedCriteria!.length - 1,
                ),
              ).toList(),
        if (criteria != null &&
            criteria.failedCriteria != null &&
            criteria.failedCriteria!.isNotEmpty)
          SizedBox(height: 41),
        if (criteria != null &&
          criteria.failedCriteria != null &&
          criteria.failedCriteria!.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text("Fix These", style: getBoldStyle(fontSize: 15)),
        ),
        if (criteria != null &&
            criteria.failedCriteria != null &&
            criteria.failedCriteria!.isNotEmpty)
          ...criteria.failedCriteria!.mapIndexed((idx, e) => messageTile(
                  isPassed: false,
                  isNotLast: idx < criteria.failedCriteria!.length - 1,
                ),
              ).toList(),
      ],
    );
  }

  Widget _content(context, ShortTermLoanAdvert? loanAdvert) {
    final screenSize = MediaQuery.of(context).size;
    final maxExtent = 0.81;
    final containerHeight = 1;
    final minExtent = 0.63;
    // TODO: Ask @Paul to explain this minExtent to me
    // final minExtent = 1 - (containerHeight / (screenSize.height - maxDraggableTop));

    return DraggableScrollableSheet(
        maxChildSize: maxExtent,
        minChildSize: minExtent,
        initialChildSize: minExtent,
        builder: (ctx, ScrollController draggableScrollController) {
          return Container(
            padding: EdgeInsets.only(top: 21, left: 23, right: 23),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              border: Border.all(
                width: 1.0,
                color: Color(0xff063A4F0D).withOpacity(0.05),
              ),
            ),
            child: ListView(
              controller: draggableScrollController,
              padding: EdgeInsets.zero,
              children: [
                Text(
                  "Short-term \nLoans",
                  style: getBoldStyle(),
                ),
                SizedBox(height: 16),
                if (loanAdvert != null && loanAdvert.description != null)
                  Text(loanAdvert.description ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.5,
                          height: 1.5,
                          color: Colors.textColorBlack)),
                if (loanAdvert != null && loanAdvert.description != null)
                  SizedBox(height: 24),
                if (loanAdvert != null && loanAdvert.minInterestRate != null)
                  InterestRateBanner(
                    title: "as low as",
                    interestRate: "${loanAdvert.minInterestRate!.toDouble()}",
                    subtitle: "interest rate",
                  ),
                if (loanAdvert != null && loanAdvert.minInterestRate != null)
                  SizedBox(height: 24),
                if (loanAdvert != null && loanAdvert.penaltyString != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 17),
                    child: InfoBannerContent(
                        title: "Penalty",
                        subtitle: loanAdvert.penaltyString,
                        svgPath: "res/drawables/ic_savings_warning.svg"),
                    decoration: BoxDecoration(
                        color: Color(0xff244528).withOpacity(0.05),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                if (loanAdvert != null && loanAdvert.penaltyString != null)
                  SizedBox(height: 38),
                StreamBuilder(
                    stream: _eligibilityStream,
                    builder: (ctx,
                        AsyncSnapshot<
                                Resource<ShortTermLoanEligibilityCriteria?>>
                            snapShot) {
                      // Handle loading
                      if (!snapShot.hasData || snapShot.data is Loading) {
                        return Center(
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                                color: Colors.solidOrange),
                          ),
                        );
                      }

                      // Handle error
                      if (snapShot.data is Error) {
                        final data = snapShot.data as Error;
                        return Center(
                          child: ErrorLayoutView(
                              "Error fetching loan offer eligibility",
                              data.message ?? "", () {
                            setState(() {
                              _eligibilityStream = viewModel.getEligibility();
                            });
                          }),
                        );
                      }

                      // Success
                      final isEligible =
                          snapShot.data?.data?.isEligible ?? false;
                      final child = isEligible
                          ? eligibleMessage(
                              isEligible: isEligible, loanAdvert: loanAdvert)
                          : notEligibleMessage(criteria: snapShot.data?.data);

                      return eligibilityCard(
                        isEligible: isEligible,
                        child: child,
                      );
                    }),
                SizedBox(height: 38),
                Styles.statefulButton(
                  stream: viewModel.isValid,
                  buttonStyle: Styles.primaryButtonStyle.copyWith(
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled))
                        return Colors.solidOrange.withOpacity(0.5);
                      else if (states.contains(MaterialState.pressed))
                        return Colors.solidOrange.withOpacity(0.5);
                      else
                        return Colors.solidOrange;
                    }),
                    textStyle: MaterialStateProperty.all(getBoldStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white)),
                  ),
                  onClick: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => LoanApplicationView()));
                  },
                  text: 'View Loan Offers',
                ),
                SizedBox(height: 38 + 31.5),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.peach,
      body: Stack(
        children: [
          Positioned(
            top: toolBarMarginTop + 10,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Styles.imageButton(
                    padding: EdgeInsets.all(9),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    onClick: () => Navigator.of(context).pop(),
                    image: SvgPicture.asset(
                      'res/drawables/ic_back_arrow.svg',
                      fit: BoxFit.contain,
                      width: 19.5,
                      height: 19.02,
                      color: Colors.textColorBlack,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Loans",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.textColorBlack),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 43,
            right: 0,
            child: Image.asset('res/drawables/savings_flex_bg.png'),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: _content(context, widget.loanAdvert),
          )
        ],
      ),
    );
  }
}
