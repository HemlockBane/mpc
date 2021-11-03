import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_product_status.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_loan_details_view.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_advert_details_view.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/padded_divider.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/status_pill.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

enum LoanState { ready, pending, active, overdue }

Widget buildReadyShortTermLoanBottomView(
    {required String text,
    required VoidCallback onClick,
    required ShortTermLoanProductStatus product}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Get up to", style: getNormalStyle()),
                SizedBox(height: 5),
                Text("${getShortTermReadyLoanMaxAmount(product)}",
                    style: getBoldStyle(fontSize: 16.5))
              ],
            ),
            SizedBox(width: 48),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Min. Interest", style: getNormalStyle()),
                SizedBox(height: 5),
                Text("${getShortTermReadyLoanMinInterest(product)}%",
                    style: getBoldStyle(fontSize: 16.5))
              ],
            ),
          ],
        ),
      ),
      SizedBox(width: 31),
      _textButton(
          text: "Apply",
          onClick: () {
            onClick();
          })
    ],
  );
}

Widget buildReadyLoanBottomView(
    {required String text, required VoidCallback onClick}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Get up to", style: getNormalStyle()),
                SizedBox(height: 5),
                Text("N 150,000.00", style: getBoldStyle(fontSize: 16.5))
              ],
            ),
            SizedBox(width: 48),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Min. Interest", style: getNormalStyle()),
                SizedBox(height: 5),
                Text("5.25%", style: getBoldStyle(fontSize: 16.5))
              ],
            ),
          ],
        ),
      ),
      SizedBox(width: 31),
      _textButton(
          text: "Apply",
          onClick: () {
            onClick();
          })
    ],
  );
}

Widget _textButton({required String text, required VoidCallback onClick}) {
  return TextButton(
    child: Text(text, style: getBoldStyle(color: Colors.white, fontSize: 12)),
    style: TextButton.styleFrom(backgroundColor: Colors.solidOrange),
    onPressed: () {
      onClick();
    },
  );
}

Widget _labelAndText({required String label, required String text}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: getNormalStyle(fontSize: 12)),
      SizedBox(height: 5),
      Text(text, style: getBoldStyle(fontSize: 13.38)),
    ],
  );
}

Widget buildShortTermPendingOrRunningLoanBottomView(
    {required VoidCallback onClick,
    required ShortTermLoanProductStatus product, required LoanState state}) {


  final runningLoanView = Padding(
    padding: EdgeInsets.fromLTRB(16, 0, 17, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Outstanding", style: getNormalStyle(fontSize: 12)),
        SizedBox(height: 5),
        Text("${getRunningLoanOutstandingAmount(product)}",
          style: getBoldStyle(fontSize: 17)),
        SizedBox(height: 10),
        Row(
          children: [
            _labelAndText(
              label: "Loan Amount",
              text: "${getRunningLoanAmount(product)}"),
            SizedBox(width: 48),
            _labelAndText(
              label: "Due Date", text: getDueDate(product) ?? "")
          ],
        ),
        SizedBox(height: 14.2),
      ],
    ),
  );

  final pendingLoanView = Padding(
    padding: EdgeInsets.fromLTRB(16, 0, 17, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Request Amount", style: getNormalStyle(fontSize: 12)),
        SizedBox(height: 5),
        Text("${getPendingLoanRequestAmount(product)}",
          style: getBoldStyle(fontSize: 17)),
        SizedBox(height: 10),
        Row(
          children: [
            _labelAndText(
              label: "Interest Rate",
              text: "${getPendingLoanInterestRate(product)}%"),
            SizedBox(width: 48),
            _labelAndText(
              label: "Tenor", text: "${getPendingLoanTenor(product)} days")
          ],
        ),
        SizedBox(height: 14.2),
      ],
    ),
  );


  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (state == LoanState.pending)
        pendingLoanView,
      if (state == LoanState.active || state == LoanState.overdue)
        runningLoanView,
      if(state != LoanState.pending)
        Container(
          padding: EdgeInsets.fromLTRB(16, 4.5, 21, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Repayment Progress",
                      style: getNormalStyle(fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      percent: getRunningLoanRepaymentProgress(product) ?? 0.0,
                      lineHeight: 8,
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.solidOrange,
                      backgroundColor: Color(0xffEAE6E1),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 31),
              TextButton(
                child: Text(
                  "View Details",
                  style: getNormalStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                      color: Colors.solidOrange),
                ),
                style: TextButton.styleFrom(),
                onPressed: () {
                  onClick();
                },
              ),
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.solidOrange.withOpacity(0.08),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              border: Border.all(
                  color: Color(0xffB1881E).withOpacity(0.1), width: 0.7)),
        )
    ],
  );
}

class SalaryAdvanceLoanCard extends StatelessWidget {
  const SalaryAdvanceLoanCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoanState state = LoanState.ready;
    bool isReadyState = state == LoanState.ready;


    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset("res/drawables/hd_image.jpg",
                    height: 110, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                left: 8,
                top: 80,
                child: Image.asset("res/drawables/ic_m_salary_loan.png"),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 17, top: 14),
            child: Row(
              children: [
                SizedBox(width: 74),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Salary Advance",
                                style: getBoldStyle(fontSize: 14)),
                            SizedBox(height: 1),
                            Text("Lorem ipsum shalaye",
                                style: getNormalStyle(fontSize: 11))
                          ],
                        ),
                      ),
                      StatusPill(
                          statusColor: getLoanStateColor(state),
                          statusDescription: getLoanStateDescription(state))
                    ],
                  ),
                )
              ],
            ),
          ),
          _getDivider(),
          Padding(
              padding: EdgeInsets.only(left: 18, right: 15),
              child: buildReadyLoanBottomView(
                  text: "Apply",
                  onClick: () {

                  }))
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border:
            Border.all(color: Color(0xffB1881E).withOpacity(0.1), width: 0.7),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 2,
              color: Color(0xff165B1D).withOpacity(0.1))
        ],
      ),
    );
  }
}

class ShortTermLoanCard extends StatelessWidget {
  const ShortTermLoanCard({Key? key, required this.product}) : super(key: key);

  final ShortTermLoanProductStatus product;

  @override
  Widget build(BuildContext context) {
    final isNotActive =
        product.isProductActive != null && !product.isProductActive!;
    if (product.isProductActive == null || isNotActive) return Container();

    LoanState? state = getShortTermLoanProductState(product);
    if(state == null) return Container();
    bool isReadyState = state == LoanState.ready;

    final onClickApply = () {
      final args = {"loan_advert" : product.shortTermLoanAdvert};
      Navigator.of(context).pushNamed(Routes.LOAN_ADVERT_DETAILS, arguments: args);
    };

    final onClickView = () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => LoanDetailsView()));
    };

    final padding = EdgeInsets.fromLTRB(16, 15, 17, 15);
    final runningOrPendingLoanPadding = EdgeInsets.fromLTRB(16, 0, 17, 0);

    Widget _buildShortTermLoanTopView({required LoanState? state}) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Align(
                child: SvgPicture.asset("res/drawables/ic_squircle_bg.svg",
                    color: Colors.solidOrange),
              ),
              Positioned.fill(
                child: Align(
                  child: Container(
                    child:
                        SvgPicture.asset("res/drawables/ic_loan_product.svg"),
                  ),
                ),
              )
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  getShortTermLoanTitle(product) ?? "",
                  style: getBoldStyle(fontSize: 14.5),
                ),
                SizedBox(height: 4),
                Text(getShortTermLoanDesc(product) ?? "",
                    style: getNormalStyle())
              ],
            ),
          ),
          SizedBox(width: 15),
          if (state != null)
            StatusPill(
              statusColor: getLoanStateColor(state),
              statusDescription: getLoanStateDescription(state),
            )
        ],
      );
    }

    return Container(
      padding: isReadyState ? padding : EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Padding(
            padding:
                isReadyState ? EdgeInsets.zero : runningOrPendingLoanPadding,
            child: _buildShortTermLoanTopView(state: state),
          ),
          _getDivider(),
          isReadyState
              ? buildReadyShortTermLoanBottomView(
                  product: product,
                  text: "Apply",
                  onClick: onClickApply,
                )
              : buildShortTermPendingOrRunningLoanBottomView(
                  onClick: onClickView, product: product, state: state)
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border:
              Border.all(color: Color(0xffB1881E).withOpacity(0.1), width: 0.7),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Color(0xff165B1D).withOpacity(0.1))
          ]),
    );
  }
}

class SalaryLoanCard extends StatelessWidget {
  const SalaryLoanCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

int? getPendingLoanTenor(ShortTermLoanProductStatus product){
  return product.shortTermPendingLoanRequest?.tenor;
}

double? getPendingLoanInterestRate(ShortTermLoanProductStatus product){
  return product.shortTermPendingLoanRequest?.interestRate?.toDouble();
}

String? getPendingLoanRequestAmount(ShortTermLoanProductStatus product){
  return product.shortTermPendingLoanRequest?.loanAmount?.formatCurrency;
}

double? getRunningLoanRepaymentProgress(ShortTermLoanProductStatus product) {
  if (product.shortTermLoanDetails == null ||
      product.shortTermLoanDetails?.totalRepayment == null ||
      product.shortTermLoanDetails?.outstandingAmount == null) return null;

  final outstanding = product.shortTermLoanDetails!.outstandingAmount!;
  final total = product.shortTermLoanDetails!.totalRepayment!;

  return (total - outstanding) / total;
}

String? getDueDate(ShortTermLoanProductStatus product) {
  if (product.shortTermLoanDetails == null ||
      product.shortTermLoanDetails?.dueDate == null) return null;

  final day = product.shortTermLoanDetails!.dueDate!.day;
  final daySuffix = getDayOfMonthSuffix(day);
  final formattedString =
      DateFormat("MMM. yyyy").format(product.shortTermLoanDetails!.dueDate!);
  return "$day$daySuffix $formattedString";
}

String? getRunningLoanAmount(ShortTermLoanProductStatus product) {
  return product.shortTermLoanDetails?.loanAmount?.formatCurrency;
}

String? getRunningLoanOutstandingAmount(ShortTermLoanProductStatus product) {
  return product.shortTermLoanDetails?.outstandingAmount?.formatCurrency;
}

double? getShortTermReadyLoanMinInterest(ShortTermLoanProductStatus product) {
  return product.shortTermLoanAdvert?.minInterestRate?.toDouble();
}

String? getShortTermReadyLoanMaxAmount(ShortTermLoanProductStatus product) {
  return product.shortTermLoanAdvert?.maxAmount?.formatCurrency;
}

String? getShortTermLoanTitle(ShortTermLoanProductStatus product) {
  final state = getShortTermLoanProductState(product);
  if (state == null) return null;

  if (state == LoanState.ready) return product.shortTermLoanAdvert?.name;
  if (state == LoanState.pending)
    return product.shortTermPendingLoanRequest?.name;

  return product.shortTermLoanDetails?.name;
}

String? getShortTermLoanDesc(ShortTermLoanProductStatus product) {
  final state = getShortTermLoanProductState(product);
  if (state == null) return null;

  if (state == LoanState.ready) return product.shortTermLoanAdvert?.description;
  if (state == LoanState.pending)
    return product.shortTermPendingLoanRequest?.description;

  return product.shortTermLoanDetails?.description;
}

LoanState? getShortTermLoanProductState(ShortTermLoanProductStatus product) {
  if (product.status == null) return null;
  final loanStatus = product.status;

  if (loanStatus == "READY") {
    if (product.shortTermLoanAdvert == null) return null;
    return LoanState.ready;
  }

  if (loanStatus == "AWAITING_APPROVAL") {
    if (product.shortTermPendingLoanRequest == null) return null;
    return LoanState.pending;
  }

  if (product.shortTermLoanDetails == null ||
      product.shortTermLoanDetails?.isOverdue == null) return null;
  final isOverdue = product.shortTermLoanDetails!.isOverdue!;
  if (!isOverdue) return LoanState.active;

  return LoanState.overdue;
}

String getLoanStateDescription(LoanState state) {
  switch (state) {
    case LoanState.ready:
      return "Ready";
    case LoanState.pending:
      return "Pending";
    case LoanState.active:
      return "Active";
    case LoanState.overdue:
      return "Overdue";
  }
}

Color getLoanStateColor(LoanState state) {
  switch (state) {
    case LoanState.ready:
      return Colors.deepGrey;
    case LoanState.pending:
      return Colors.solidOrange;
    case LoanState.active:
      return Colors.solidGreen;
    case LoanState.overdue:
      return Colors.red;
  }
}

Widget _getDivider() => PaddedDivider(
      top: 9,
      bottom: 10,
      dividerColor: Color(0xff966C2E).withOpacity(0.12),
    );

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

String getDayOfMonthSuffix(int dayNum) {
  assert((dayNum >= 1 && dayNum <= 31));

  if (dayNum >= 11 && dayNum <= 13) {
    return 'th';
  }

  switch (dayNum % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
