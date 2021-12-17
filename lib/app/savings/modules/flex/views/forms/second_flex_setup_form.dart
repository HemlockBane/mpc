import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/airtime/views/selection_combo.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving_config.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/flex_setup_viewmodel.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/views/forms/flex_setup_confirmation.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
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

  TextStyle getBoldStyle({double fontSize = 32.5,
        Color color = Colors.textColorBlack,
        FontWeight fontWeight = FontWeight.w700}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  TextStyle getNormalStyle({double fontSize = 32.5,
        Color color = Colors.textColorBlack,
        FontWeight fontWeight = FontWeight.w500}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  @override
  void initState() {
    _viewModel = Provider.of<FlexSetupViewModel>(context, listen: false);
    _viewModel.setContributionWeekDay(null);
    _viewModel.setContributionMonthDay(null);
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 100), (){
        _viewModel.resetFormToDefault();
      });
    });
  }

  List<ComboItem<FlexSaveType>> _getSavingsTypes() {

    return FlexSaveType.values.map((e) {
      final title = describeEnum(e);
      final isSelected = (_viewModel.flexSaving?.configCreated == true)
          ? e == _viewModel.savingType
          : e == FlexSaveType.AUTOMATIC;
      return ComboItem(e, title.toLowerCase().capitalizeFirstOfEach,
          isSelected: isSelected
      );
    }).toList();
  }

  void _navigateToConfirmation() {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (ctx) => ChangeNotifierProvider.value(
              value: _viewModel,
              child: FlexSetUpConfirmationView(),
            )
        )
    );
  }

  Widget _getDropDown() {
    if(_viewModel.savingMode == FlexSaveMode.MONTHLY) {
      return StreamBuilder(
        key: ValueKey("monthDayStream"),
        stream: _viewModel.contributionMonthDayStream,
        builder: (ctx, AsyncSnapshot<StringDropDownItem?> snapshot) {
          return Styles.buildDropDown<StringDropDownItem>(
              _viewModel.monthDays, snapshot, (item, index) {
            if(_viewModel.savingMode == FlexSaveMode.MONTHLY) {
              _viewModel.setContributionMonthDay(item);
            } else {
              _viewModel.setContributionWeekDay(item);
            }
          },
              fillColor: Color(0XFFA5C097).withOpacity(0.15),
              iconColor: Colors.solidGreen
          );
        },
      );
    } else {
      return StreamBuilder(
        key: ValueKey("weekDayStream"),
        initialData: null,
        stream: _viewModel.contributionWeekDayStream,
        builder: (ctx, AsyncSnapshot<StringDropDownItem?> a) {
          return Styles.buildDropDown<StringDropDownItem>(_viewModel.weekDays, a, (item, index) {
            if(_viewModel.savingMode == FlexSaveMode.MONTHLY) {
              _viewModel.setContributionMonthDay(item);
            } else {
              _viewModel.setContributionWeekDay(item);
            }
          },
              fillColor: Color(0XFFA5C097).withOpacity(0.15),
              iconColor: Colors.solidGreen
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bottom = MediaQuery.of(context).viewPadding.bottom;
    return ScrollView(
      maxHeight: MediaQuery.of(context).size.height - (250 + bottom),//subtract the vertical padding
      child: Container(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "How will the contribution be made?",
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 12),
                    StreamBuilder(
                      stream: _viewModel.savingTypeStream,
                        builder: (ctx, snapShot) {
                          return SelectionCombo<FlexSaveType>(
                            _getSavingsTypes(), (item, index) {
                            _viewModel.setFlexSaveType(item);
                          },
                            checkBoxPosition: CheckBoxPosition.leading,
                            shouldUseAlternateDecoration: true,
                            primaryColor: Colors.solidGreen,
                            backgroundColor: savingsGreen.withOpacity(0.15),
                            horizontalPadding: 11,
                          );
                        }
                    ),
                    SizedBox(height: 34),
                    StreamBuilder(
                        stream: _viewModel.savingModeStream,
                        builder: (ctx, AsyncSnapshot<FlexSaveMode> a) {
                          return StreamBuilder(
                            stream: _viewModel.savingTypeStream,
                            builder: (cc, AsyncSnapshot<FlexSaveType> a){

                              final autoTitle = (_viewModel.savingMode == FlexSaveMode.MONTHLY)
                                  ? "What day of the month do you want to contribute?"
                                  : "What day of the week do you want to contribute?";

                              final manualTitle = (_viewModel.savingMode == FlexSaveMode.MONTHLY)
                                  ? "Remind me to contribute on this day of the month"
                                  : "Remind me to contribute on this day of the week";

                              final isAuto = (_viewModel.savingType == FlexSaveType.AUTOMATIC);

                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        (isAuto) ? autoTitle : manualTitle,
                                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    _getDropDown()
                                  ]
                              );
                            },
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
                            backgroundColor: MaterialStateProperty.all(Colors.deepGrey.withOpacity(0.3)),
                            textStyle: MaterialStateProperty.all(getBoldStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.deepGrey
                            ))),
                        stream: Stream.value(true),
                        onClick: () => _viewModel.moveToPrev(),
                        text: 'Back'
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 5,
                    child: Styles.statefulButton(
                        buttonStyle: Styles.savingsFlexButtonStyle,
                        isLoading: _viewModel.isLoading,
                        stream: _viewModel.isValid,
                        loadingColor: Colors.savingsPrimary.withOpacity(0.5),
                        onClick: _navigateToConfirmation,
                        text: 'Complete Setup'
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
            ],
          )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
