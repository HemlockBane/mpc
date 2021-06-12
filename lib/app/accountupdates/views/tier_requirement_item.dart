import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

class TierRequirementItem extends StatelessWidget {

  final int position;
  final Tier tier;

  TierRequirementItem(this.tier, this.position);

  String _tierAmount(double? amount) {
    if(amount == 0.0) return "Unlimited";
    return amount?.formatCurrency.replaceAll(".00", "") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left:32, right:32, top: 16),
      child: Wrap(
        children: [
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                    visible: position == 2,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.primaryColor.withOpacity(0.1)
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset('res/drawables/ic_info.svg'),
                          SizedBox(width: 12,),
                          Flexible(
                              child: Text(
                                  'Qualification for this tier is subject to the verification of your supplied address.',
                                  style: TextStyle(color: Color(0XFF0B3275), height: 1.4, fontSize: 14)
                              )
                          ),
                        ],
                      ),
                    )
                ),
                SizedBox(height: (position == 2) ? 24 : 0,),
                Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        tier.name?.replaceAll("Customers ", "") ?? "",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.darkBlue),
                      )
                ),
                SizedBox(height: 16,),
                Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily Debit Limit',
                              style: TextStyle(color: Colors.darkBlue.withOpacity(0.5), fontSize: 13),
                            ),
                            SizedBox(height: 2),
                            Text(
                              _tierAmount( tier.maximumDailyDebit),
                              style: TextStyle(color: Colors.textColorBlack, fontSize: 16, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        SizedBox(width: 51),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Balance Limit',
                              style: TextStyle(color: Colors.darkBlue.withOpacity(0.5), fontSize: 13),
                            ),
                            SizedBox(height: 2),
                            Text(
                              _tierAmount( tier.maximumCumulativeBalance),
                              style: TextStyle(color: Colors.textColorBlack, fontSize: 16, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ],
                    )
                ),
                SizedBox(height: 26),
                Text(
                  'REQUIREMENT',
                  style: TextStyle(color: Colors.textColorDeem.withOpacity(0.3), fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Visibility(
                    visible: true,
                    child: Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          children: [
                            SvgPicture.asset('res/drawables/ic_circular_check_mark.svg'),
                            SizedBox(width: 8),
                            Text(
                              'BVN',
                              style: TextStyle(
                                  color: Colors.textColorDeem, fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                    )
                ),
                SizedBox(height: 8),
                Visibility(
                    visible: tier.schemeRequirement?.signature ?? false,
                    child: Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          children: [
                            SvgPicture.asset('res/drawables/ic_circular_check_mark.svg'),
                            SizedBox(width: 8),
                            Text(
                              'Signature',
                              style: TextStyle(
                                  color: Colors.textColorDeem, fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                    )
                ),
                SizedBox(height: (tier.schemeRequirement?.signature == true) ? 8 : 0),
                Visibility(
                    visible: tier.schemeRequirement?.identification ?? false,
                    child: Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          children: [
                            SvgPicture.asset('res/drawables/ic_circular_check_mark.svg'),
                            SizedBox(width: 8),
                            Text(
                              'Identification',
                              style: TextStyle(
                                  color: Colors.textColorDeem, fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                    )
                ),
                SizedBox(height: (tier.schemeRequirement?.identification == true) ? 8 : 0),
                Visibility(
                    visible: tier.schemeRequirement?.residentialAddress ?? false,
                    child: Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          children: [
                            SvgPicture.asset('res/drawables/ic_circular_check_mark.svg'),
                            SizedBox(width: 8),
                            Text(
                              'Residential Address',
                              style: TextStyle(
                                  color: Colors.textColorDeem, fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                    )
                ),
                SizedBox(height: (tier.schemeRequirement?.residentialAddress == true) ? 8 : 0),
                Visibility(
                    visible: tier.schemeRequirement?.nextOfKin ?? false,
                    child: Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          children: [
                            SvgPicture.asset('res/drawables/ic_circular_check_mark.svg'),
                            SizedBox(width: 8),
                            Text(
                              'Next Of Kin',
                              style: TextStyle(
                                  color: Colors.textColorDeem, fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                    )
                ),
                SizedBox(height: (tier.schemeRequirement?.nextOfKin == true) ? 8 : 0),
                Visibility(
                    visible: tier.schemeRequirement?.employment ?? false,
                    child: Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          children: [
                            SvgPicture.asset('res/drawables/ic_circular_check_mark.svg'),
                            SizedBox(width: 8),
                            Text(
                              'Employment',
                              style: TextStyle(
                                  color: Colors.textColorDeem, fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                    )
                ),
                SizedBox(height: (tier.schemeRequirement?.employment == true) ? 8 : 0),
                Visibility(
                    visible: tier.schemeRequirement?.verifiedEmployment ?? false,
                    child: Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          children: [
                            SvgPicture.asset('res/drawables/ic_circular_check_mark.svg'),
                            SizedBox(width: 8),
                            Text(
                              'Verified Employment',
                              style: TextStyle(
                                  color: Colors.textColorDeem, fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                    )
                ),
                SizedBox(height: (tier.schemeRequirement?.verifiedEmployment == true) ? 8 : 0),
                Visibility(
                    visible: tier.schemeRequirement?.verifiedResidentialAddress ?? false,
                    child: Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          children: [
                            SvgPicture.asset('res/drawables/ic_circular_check_mark.svg'),
                            SizedBox(width: 8),
                            Text(
                              'Verified Residential Address',
                              style: TextStyle(
                                  color: Colors.textColorDeem, fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                    )
                ),
                SizedBox(height: (tier.schemeRequirement?.verifiedResidentialAddress == true) ? 8 : 0),
                Visibility(
                    visible: tier.schemeRequirement?.verifiedIdentification ?? false,
                    child: Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          children: [
                            SvgPicture.asset('res/drawables/ic_circular_check_mark.svg'),
                            SizedBox(width: 8),
                            Text(
                              'Verified Identification',
                              style: TextStyle(
                                  color: Colors.textColorDeem, fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                    )
                ),
                SizedBox(height: 8),
              ],
            ),
          )
        ],
      ),
    );
  }

}