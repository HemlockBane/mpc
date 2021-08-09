import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:moniepoint_flutter/app/login/viewmodels/recovery_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/data/security_question.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/full_page_loader.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

class SecurityQuestionScreen {
//   late final GlobalKey<ScaffoldState> _scaffoldKey;
//   late final RecoveryMode mode;
//
//   SecurityQuestionScreen(this._scaffoldKey, this.mode);
//
//   @override
//   State<StatefulWidget> createState() {
//     return _SecurityQuestionScreen();
//   }
//
// }
//
// class _SecurityQuestionScreen extends State<SecurityQuestionScreen> {
//
//   TextEditingController _answerController = TextEditingController();
//   bool _hasAnswer = false;
//   bool _isLoading = false;
//   bool _isReloading = false;
//
//   void subscribeUiToAnswerSecurityQuestion() {
//     // final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
//     //
//     // if(viewModel.recoveryMode == RecoveryMode.USERNAME_RECOVERY) {
//     //   viewModel.setSecurityQuestionAnswer(_answerController.text);
//     //   Navigator.of(context).pushNamed("recovery_otp");
//     //   return;
//     // }
//     //
//     // ///For Add or Change Device
//     // if(viewModel.recoveryMode == RecoveryMode.DEVICE) {
//     //   viewModel.validateSecurityQuestionAnswer(_answerController.text)
//     //       .listen(_handleSecurityAnswerValidationForDevice);
//     //   return;
//     // }
//     //
//     // viewModel.setSecurityQuestionAnswer(_answerController.text);
//     // viewModel.validateSecurityAnswer().listen((event) {
//     //   if(event is Loading) setState(() => _isLoading = true);
//     //   if (event is Error<RecoveryResponse>) {
//     //     setState(() => _isLoading = false);
//     //     showModalBottomSheet(
//     //         context: widget._scaffoldKey.currentContext ?? context,
//     //         isScrollControlled: true,
//     //         backgroundColor: Colors.transparent,
//     //         builder: (context) {
//     //           return BottomSheets.displayErrorModal(context, message: event.message);
//     //         });
//     //   }
//     //   if(event is Success<RecoveryResponse>) {
//     //     setState(() => _isLoading = false);
//     //     Navigator.of(context).pushNamed("recovery_otp");
//     //   }
//     // });
//   }
//
//   void _handleSecurityAnswerValidationForDevice<T>(Resource<T> event) {
//     if(event is Loading) setState(() => _isLoading = true);
//     if (event is Error<T>) {
//       setState(() => _isLoading = false);
//       showModalBottomSheet(
//           context: widget._scaffoldKey.currentContext ?? context,
//           isScrollControlled: true,
//           backgroundColor: Colors.transparent,
//           builder: (context) {
//             return BottomSheets.displayErrorModal(context, message: event.message);
//           });
//     }
//     if(event is Success<T>) {
//       setState(() => _isLoading = false);
//       Navigator.of(context).pushNamed("recovery_otp");
//     }
//   }
//
//   void loadQuestion() {
//     final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
//     viewModel.loadSecurityQuestion().listen((event) {
//       if(event is Loading) setState(() => _isReloading = true);
//       if (event is Error<SecurityQuestion>) {
//         setState(() => _isReloading = false);
//         showModalBottomSheet(
//             context: widget._scaffoldKey.currentContext ?? context,
//             isScrollControlled: true,
//             backgroundColor: Colors.transparent,
//             builder: (context) {
//               return BottomSheets.displayErrorModal(context, message: event.message);
//             });
//       }
//       if(event is Success<SecurityQuestion>) {
//         setState(() => _isReloading = false);
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     _answerController.addListener(() {
//       String textAnswer = _answerController.text;
//       setState(() {
//         _hasAnswer = textAnswer.isNotEmpty;
//       });
//     });
//     /// Consider loading the question immediately
//     WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
//       if (widget.mode == RecoveryMode.DEVICE) loadQuestion();
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
//     if(viewModel.recoveryMode == null) viewModel.setRecoveryMode(widget.mode);
//
//     return ScrollView(
//       maxHeight: MediaQuery.of(context).size.height,
//       child: Stack(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
//             child: Column(
//               children: [
//                 Expanded(
//                     child: Center(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             'Security Question',
//                             textAlign: TextAlign.start,
//                             style: TextStyle(
//                                 color: Colors.colorPrimaryDark,
//                                 fontSize: 25,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           SizedBox(height: 24),
//                           Text(
//                             'QUESTION',
//                             textAlign: TextAlign.start,
//                             style: TextStyle(
//                                 color: Colors.textColorDeem.withOpacity(0.3),
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           SizedBox(height: 8),
//                           Flexible(child: Text(
//                             viewModel.securityQuestion?.question ?? "",
//                             textAlign: TextAlign.start,
//                             style: TextStyle(
//                                 color: Colors.textColorBlack,
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.normal
//                             ),
//                           )),
//                           SizedBox(height: 16),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: TextButton.icon(
//                                 onPressed:() => loadQuestion(),
//                                 icon: Icon(CustomFont.refresh_question, color: Colors.primaryColor, size: 16),
//                                 label: Text(' Ask me another question',
//                                     style: TextStyle(
//                                         color: Colors.colorPrimaryDark,
//                                         fontSize: 14, fontWeight: FontWeight.normal,
//                                         fontFamily: Styles.defaultFont
//                                     ))
//                             ),
//                           ),
//                           SizedBox(height: 24),
//                           Text(
//                             'ANSWER',
//                             textAlign: TextAlign.start,
//                             style: TextStyle(
//                                 color: Colors.textColorDeem.withOpacity(0.3),
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           SizedBox(height: 8),
//                           Styles.appEditText(
//                               hint: 'Enter Answer',
//                               controller: _answerController,
//                               animateHint: false,
//                               startIcon: Icon(CustomFont.question_mark, color: Colors.colorFaded)
//                           )
//                         ],
//                       ),
//                     )
//                 ),
//                 Styles.statefulButton2(
//                     elevation: 0,
//                     isValid: !_isLoading && _hasAnswer,
//                     onClick: subscribeUiToAnswerSecurityQuestion,
//                     text: 'Continue',
//                     isLoading: _isLoading
//                 ),
//                 SizedBox(height: 16),
//               ],
//             ),
//           ),
//           if(_isReloading) FullPageLoader()
//         ],
//       ),
//     );
//   }

}