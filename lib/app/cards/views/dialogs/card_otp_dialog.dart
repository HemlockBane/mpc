import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_otp_linking_response.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_otp_validation_response.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/card_issuance_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/views/otp_ussd_info_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

///@Author Paul Okeke
class CardOtpDialog extends StatefulWidget {

  final bool requestOtp;

  CardOtpDialog(this.requestOtp);

  @override
  State<StatefulWidget> createState() => _CardOtpDialog();

}

class _CardOtpDialog extends State<CardOtpDialog> with CompositeDisposableWidget {

  late final CardIssuanceViewModel _viewModel;
  final ValueNotifier<dynamic> _stateNotifier = ValueNotifier(null);
  bool _isLoading = false;

  TextEditingController? _otpController;

  @override
  void initState() {
    _viewModel = Provider.of<CardIssuanceViewModel>(context, listen: false);
    _otpController = TextEditingController();
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if(widget.requestOtp) _subscribeUiToRequestOtp();
    });
  }

  void _subscribeUiToRequestOtp() {
    final streamFn = () => _viewModel.sendCardLinkingOtp(_viewModel.cardCustomerAccountId!).asBroadcastStream();
    streamWithExponentialBackoff(stream: streamFn).listen((event) {
      if(event is Loading) _isLoading = true;
      else if(event is Success) {
        _isLoading = false;
        _viewModel.setUserCode(event.data?.userCode ?? "");
      }
      else if(event is Error<CardOtpLinkingResponse>) {
        _isLoading = false;
        return Navigator.of(context).pop(event);
      }
      _stateNotifier.value = _isLoading;
    }).disposedBy(this);
  }

  void _subscribeUiToValidateOtp() {
    _viewModel.validateCardLinkingOtp(_viewModel.cardCustomerAccountId!, _otpController!.text).listen((event) {
      if(event is Loading) _isLoading = true;
      else if(event is Success<CardOtpValidationResponse>) {
        _isLoading = false;
        return Navigator.of(context).pop(event.data?.otpValidationKey);
      }
      else if(event is Error<CardOtpValidationResponse>) {
        _isLoading = false;
        return Navigator.of(context).pop(event);
      }
      _stateNotifier.value = _isLoading;
    }).disposedBy(this);
  }

  @override
  Widget build(BuildContext context) {
    return SessionedWidget(
        context: context,
        sessionTime: 120 * 2,
        child: BottomSheets.makeAppBottomSheet2(
            curveBackgroundColor: Colors.white,
            centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
            contentBackgroundColor: Colors.white,
            centerBackgroundPadding: 12,
            dialogIcon: SvgPicture.asset(
              'res/drawables/ic_info.svg',
              color: Colors.primaryColor,
              width: 48,
              height: 48,
            ),
            content: Wrap(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 27, vertical: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 22),
                      Center(
                        child: Text('Verify Phone Number',
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.textColorBlack)),
                      ),
                      SizedBox(height: 14),
                      Text(
                        'We’ve just sent you a 6-digit code to your registered phone number. Enter it below',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.textColorBlack,
                            fontSize: 14
                        ),
                      ),
                      SizedBox(height: 37),
                      Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.5),
                          child: Styles.appEditText(
                              controller: _otpController,
                              hint: 'Enter OTP',
                              maxLength: 6,
                              inputType: TextInputType.number,
                              onChanged: (v) {
                                _stateNotifier.value = v;
                                if(v.length >= 6) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                              },
                              inputFormats: [FilteringTextInputFormatter.digitsOnly],
                              startIcon: Icon(CustomFont.numberInput, color: Colors.textFieldIcon.withOpacity(0.2))
                          ),
                      ),
                      SizedBox(height: 23),
                      OtpUssdInfoView(
                        "Card Linking OTP Mobile",
                        defaultCode: "*5573*77#",
                        message: "Didn't get the code? Dial {}",
                      ),
                      SizedBox(height: 27),
                      SizedBox(
                        width: double.infinity,
                        child: ValueListenableBuilder(
                          valueListenable: _stateNotifier,
                          builder: (ctx, data, __) {
                            return Styles.statefulButton2(
                                isValid: _otpController!.text.length >= 6,
                                isLoading: _isLoading,
                                onClick: _subscribeUiToValidateOtp,
                                text: "Submit"
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 46),
                    ],
                  ),
                )
              ],
            )
        ),
    );
  }

  @override
  void dispose() {
    disposeAll();
    super.dispose();
  }

}

Future<dynamic> showLinkCardOtpDialog(
    BuildContext context, CardIssuanceViewModel viewModel, bool requestOtp) {
  return showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return ChangeNotifierProvider.value(
            value: viewModel,
            child: CardOtpDialog(requestOtp),
        );
      }
  );
}
