import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/airtime/views/selection_combo.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving_config.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/flex_setup_viewmodel.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
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

  TextStyle getBoldStyle({double fontSize = 32.5,
        Color color = Colors.textColorBlack,
        FontWeight fontWeight = FontWeight.w700}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  TextStyle getNormalStyle({double fontSize = 32.5,
        Color color = Colors.textColorBlack,
        FontWeight fontWeight = FontWeight.w500}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  final savingsTypes = FlexSaveType.values.map((e) {
    final title = describeEnum(e);
    return ComboItem(e, title, isSelected: e == FlexSaveType.AUTOMATIC);
  });

  @override
  void initState() {
    _viewModel = Provider.of<FlexSetupViewModel>(context, listen: false);
    _viewModel.setContributionWeekDay(null);
    _viewModel.setContributionMonthDay(null);
    super.initState();
  }

  void _subscribeUiToCreateConfig() {
    setState(() => _viewModel.setIsLoading(true));
    _viewModel.createFlexConfig().listen((event) {
      if(event is Loading) {
        if(!_viewModel.isLoading) {
          setState(() => _viewModel.setIsLoading(true));
        }
      }
      else if(event is Success) {
        setState(() => _viewModel.setIsLoading(false));
      }
      else if(event is Error<FlexSavingConfig>) {
        setState(() {_viewModel.setIsLoading(false);});
        showError(
            context,
            title: "Failed setting up\nflex savings!",
            message: event.message
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  SelectionCombo<FlexSaveType>(
                    savingsTypes.toList(), (item, index) {
                      _viewModel.setFlexSaveType(item);
                    },
                    checkBoxPosition: CheckBoxPosition.leading,
                    shouldUseAlternateDecoration: true,
                    primaryColor: Colors.solidGreen,
                    backgroundColor: savingsGreen.withOpacity(0.15),
                    horizontalPadding: 11 ,
                  ),
                  SizedBox(height: 34),
                  StreamBuilder(
                      stream: _viewModel.savingTypeStream,
                      builder: (ctx, AsyncSnapshot<FlexSaveType?> a) {
                        final title = (_viewModel.savingMode == FlexSaveMode.MONTHLY)
                            ? "What day of the month do you want to contribute?"
                            : "What day of the week do you want to contribute?";
                        final dataItems = (_viewModel.savingMode == FlexSaveMode.MONTHLY)
                            ? _viewModel.monthDays
                            : _viewModel.weekDays;
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
                                  return Styles.buildDropDown<StringDropDownItem>(dataItems, a, (item, index) {
                                        if(_viewModel.savingMode == FlexSaveMode.MONTHLY) {
                                          _viewModel.setContributionMonthDay(item);
                                        } else {
                                          _viewModel.setContributionWeekDay(item);
                                        }
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
                      buttonStyle: Styles.primaryButtonStyle.copyWith(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.solidGreen),
                          textStyle: MaterialStateProperty.all(getBoldStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.white
                          ))
                      ),
                      isLoading: _viewModel.isLoading,
                      stream: _viewModel.isValid,
                      onClick: _subscribeUiToCreateConfig,
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

  @override
  bool get wantKeepAlive => true;

}
