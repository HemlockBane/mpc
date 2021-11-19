import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/airtime/views/selection_combo.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/flex_setup_viewmodel.dart';
import 'package:moniepoint_flutter/app/savings/savings_success_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:provider/provider.dart';


const savingsGreen = Color(0xffA5C097);

class SecondFlexSetupForm extends PagedForm {
  @override
  _SecondFlexSetupFormState createState() => _SecondFlexSetupFormState();

  @override
  String getTitle() => "SecondFlexSetupForm";
}

class _SecondFlexSetupFormState extends State<SecondFlexSetupForm> with AutomaticKeepAliveClientMixin {

  late final FlexSetupViewModel _viewModel;
  var startDate = "Start date";
  var endDate = "End date";

  TextStyle getBoldStyle({double fontSize = 32.5,
        Color color = Colors.textColorBlack,
        FontWeight fontWeight = FontWeight.w700}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  TextStyle getNormalStyle({double fontSize = 32.5,
        Color color = Colors.textColorBlack,
        FontWeight fontWeight = FontWeight.w500}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  final savingsTypes = List.of([
    ComboItem("Automatic", "Automatic", isSelected: true),
    ComboItem("Manual",  "Manual",),
  ]);

  @override
  void initState() {
    _viewModel = Provider.of<FlexSetupViewModel>(context, listen: false);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  String getFormattedDateString(int date){
    final dateInMillis = DateTime.fromMillisecondsSinceEpoch(date);
    final formattedDate = "";//Jiffy(dateInMillis).format("do [of] MMM");
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final dialogContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Monthly Savings Account", style: getNormalStyle(fontSize: 15),),
        SizedBox(height: 8),
        Text("N7,000.00", style: getBoldStyle(fontSize: 20),),
        SizedBox(height: 26),
        Text("Interest rate", style: getNormalStyle(fontSize: 15)),
        SizedBox(height: 8),
        Row(
          children: [
            Text("10.25%", style: getBoldStyle(fontSize: 20),),
            SizedBox(width: 4),
            Text("p.a", style: getNormalStyle(fontSize: 18, color: Color(0xffA8ABB5)),)
          ],
        )
      ],
    );

    return Container(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    child: Text(
                      "How will the contribution be made?",
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 12),
                  SelectionCombo<String>(
                    savingsTypes.toList(), (item, index) {
                      _viewModel.setSavingMode(item);
                    },
                    checkBoxPosition: CheckBoxPosition.leading,
                    shouldUseAlternateDecoration: true,
                    primaryColor: Colors.solidGreen,
                    backgroundColor: savingsGreen.withOpacity(0.15),
                    horizontalPadding: 11 ,
                  ),
                  SizedBox(height: 34),
                  StreamBuilder(
                      stream: _viewModel.savingModeStream,
                      builder: (ctx, AsyncSnapshot<String?> a) {
                        final title = (a.data == "Manual")
                            ? "What day of the month do you want to contribute?"
                            : "What day of the week do you want to contribute?";
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  title,
                                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(height: 12),
                              StreamBuilder(
                                stream: _viewModel.contributionWeekDayStream,
                                builder: (ctx, AsyncSnapshot<StringDropDownItem?> a) {
                                  return Styles.buildDropDown<StringDropDownItem>(
                                      _viewModel.monthDays, a, (item, index) {
                                        _viewModel.setContributionWeekDay(item);
                                      }
                                  );
                                },
                              )
                            ]
                        );
                      }
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Styles.statefulButton(
                      buttonStyle: Styles.primaryButtonStyle.copyWith(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.deepGrey.withOpacity(0.3)),
                          textStyle: MaterialStateProperty.all(getBoldStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.deepGrey))),
                      stream: Stream.value(true),
                      onClick: () {
                        _viewModel.moveToPrev();
                      },
                      text: 'Back'),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 5,
                  child: Styles.statefulButton(
                      buttonStyle: Styles.primaryButtonStyle.copyWith(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.solidGreen),
                          textStyle: MaterialStateProperty.all(getBoldStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.white))),
                      stream: Stream.value(true),
                      onClick: () {
                        showConfirmation(context,
                            primaryButtonText: "Complete Setup",
                            primaryButtonColor: Colors.solidGreen,
                            title: "Setup Confirmation",
                            content: dialogContent,
                            onPrimaryClick: (){
                              Navigator.pop(context);
                              Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) => SavingsSucessView(
                                  primaryText: "Setup Complete!",
                                  secondaryText: "loremIpsum",
                                  primaryButtonText: "Continue",
                                  primaryButtonAction: (){
                                    Navigator.pushNamed(context, Routes.SAVINGS_FLEX_HOME);
                                  },


                                ),),
                              );
                            }
                        );
                      },
                      text: 'Complete Setup'
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        )
    );
  }
}
