import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/customer_identification_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/customer_identification_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/account_update_file_upload_state.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:provider/provider.dart';

import 'account_update_form_view.dart';

/// @author Paul Okeke
class CustomerIdentificationScreen extends PagedForm {

  @override
  State<StatefulWidget> createState() {
    return _CustomerIdentificationScreen();
  }

  @override
  String getTitle() => "Customer ID";

}

class _CustomerIdentificationScreen extends State<CustomerIdentificationScreen> with AutomaticKeepAliveClientMixin{

  late CustomerIdentificationForm _identificationForm;
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _registrationNumberController = TextEditingController();

  DateTime? _expiryDate;
  DateTime? _issueDate;

  UploadState _fileUploadState = UploadState.NONE;
  String uploadedFileName = "Upload International Passport";

  //TODO don't repeat yourself - reuse in proof of address
  Map<String, Tuple<Color, VoidCallback?>> getColoredTier(List<String> requiredTiers) {
    final Map<String, Tuple<Color, VoidCallback?>> coloredTierMap = {};
    requiredTiers.forEach((element) {
      coloredTierMap[element] = Tuple(Colors.primaryColor, null);
    });
    return coloredTierMap;
  }

  List<String> getRequiredTier(List<Tier> tiers) {
    final requiredTiers = tiers.where((element) => element.alternateSchemeRequirement?.identificationProof == true);
    return requiredTiers.map((e) => e.name?.replaceAll("Moniepoint Customers ", "") ?? "").toList();
  }

  void _resetForm() {
    _registrationNumberController.text = "";
    _issueDateController.text = "";
    _expiryDateController.text = "";
    _identificationForm.onIdentificationTypeChange(null);
    _identificationForm.onIssueDateChange(null);
    _identificationForm.onExpiryDateChange(null);
    _identificationForm.onIdentificationNumberChange(null);
    _identificationForm.onImageReferenceChanged(null);
    setState(() {
      uploadedFileName = "Upload Valid ID";
    });
  }


  void saveForm() {
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    final info = viewModel.identificationForm.identificationInfo;
    PreferenceUtil.saveDataForLoggedInUser("account-update-identification-info", info);
    PreferenceUtil.saveValueForLoggedInUser("account-update-identification-info-filename", uploadedFileName);
  }

  void onRestoreForm() {
    final savedInfo = PreferenceUtil.getDataForLoggedInUser("account-update-identification-info");
    final info = CustomerIdentificationInfo.fromJson(savedInfo);
    final fileName = PreferenceUtil.getValueForLoggedInUser<String>("account-update-identification-info-filename");

    if(info.identificationType != null && info.identificationType?.isNotEmpty == true) {
      _identificationForm.onIdentificationTypeChange(IdentificationType.fromString(info.identificationType));
    }

    if(info.registrationNumber != null && info.registrationNumber?.isNotEmpty == true) {
      _registrationNumberController.text = info.registrationNumber ?? "";
      _identificationForm.onIdentificationNumberChange(_registrationNumberController.text);
    }

    if(info.identityIssueDate != null && info.identityIssueDate?.isNotEmpty == true) {
      _issueDateController.text = info.identityIssueDate ?? "";
      _identificationForm.onIssueDateChange(_issueDateController.text);
    }

    if(info.identityExpiryDate != null && info.identityExpiryDate?.isNotEmpty == true) {
      _expiryDateController.text = info.identityExpiryDate ?? "";
      _identificationForm.onExpiryDateChange(_expiryDateController.text);
    }

    if(info.scannedImageRef != null && info.scannedImageRef?.isNotEmpty == true) {
      _identificationForm.onImageReferenceChanged(info.scannedImageRef);
    }

    if(fileName!=null && fileName.isNotEmpty) {
      setState(() {
        uploadedFileName = fileName;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 200),() {
        onRestoreForm();
      });
    });
  }

  /// dateType represents if it's expiry or issuance date
  void displayDatePicker(BuildContext context, {String dateType = "issue"}) async {
    final title = (dateType.toLowerCase() == "expiry") ? "Expiry Date": "Issue Date";

    final firstDate = (dateType.toLowerCase() == "expiry")
        ? _issueDate ?? DateTime(1980, 1, 1).add(Duration(days: 1))
        : _issueDate ?? DateTime(1980, 1, 1).add(Duration(days: 1));

    final lastDate = (dateType.toLowerCase() == "expiry")
        ? DateTime.now().add(Duration(days: 365 * 10))
        : _expiryDate ?? DateTime.now();

    final initialDate = (dateType.toLowerCase() == "expiry")
        ? _expiryDate ?? firstDate
        : _issueDate ?? firstDate;

    final selectedDate = await showDatePicker(
        helpText: title,
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate
    );

    if(selectedDate != null ) {
      if(dateType == "expiry") {
        _expiryDate = selectedDate;
        _expiryDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        _identificationForm.onExpiryDateChange(DateFormat('dd-MM-yyyy').format(selectedDate));
      }
      else  {
        _issueDate = selectedDate;
        _issueDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        _identificationForm.onIssueDateChange(DateFormat('dd-MM-yyyy').format(selectedDate));
      }
    }
  }

  void _chooseIdentificationImage() async  {
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["jpg", "png", "pdf"]
    );
    PlatformFile? file = result?.files.single;

    if(file == null) {
      //display error
      return;
    }

    int fileSize = file.size!;

    if (((fileSize / 1024) / 1024) > 2/*mb*/) {
      print("File Size $fileSize");
      return;
    }

    viewModel.uploadValidIdentity(file.path ?? "").listen((event) {
      if(event is Loading) setState(() {
        uploadedFileName = file.name ?? uploadedFileName;
        _fileUploadState = UploadState.LOADING;
      });
      if(event is Success) {
        _identificationForm.onImageReferenceChanged(event.data?.UUID);
        setState(() {
          _fileUploadState = UploadState.SUCCESS;
        });
      }
      if(event is Error) {
        setState(() {
          _fileUploadState = UploadState.ERROR;
        });
        Future.delayed(Duration(seconds: 10), () {
          setState(() {
            _fileUploadState = UploadState.NONE;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    this._identificationForm = viewModel.identificationForm;

    final requiredTiers = getRequiredTier(viewModel.tiers);
    final requiredTierText = "Required for ${requiredTiers.join(", ")}";

    return ScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder(
                stream: _identificationForm.idTypeStream,
                builder: (BuildContext context, AsyncSnapshot<IdentificationType?> snapshot) {
                  return Styles.buildDropDown(identificationTypes, snapshot, (value, i) {
                    _identificationForm.onIdentificationTypeChange(value as IdentificationType);
                  }, hint: 'Identification Type');
                }),
            SizedBox(height: 16),
            StreamBuilder(
                stream: _identificationForm.idNumberStream,
                builder: (context, snapshot) {
                  return Styles.appEditText(
                      controller: _registrationNumberController,
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _identificationForm.onIdentificationNumberChange,
                      hint: 'ID Number',
                      animateHint: false,
                      fontSize: 15
                  );
                }),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: StreamBuilder(
                    stream: _identificationForm.issueDateStream,
                    builder: (context, snapshot) {
                      return Styles.appEditText(
                          controller: _issueDateController,
                          onClick: () => displayDatePicker(context),
                          errorText: snapshot.hasError ? snapshot.error.toString() : null,
                          hint: 'Issue Date',
                          animateHint: false,
                          readOnly: true,
                          startIcon: Icon(CustomFont.calendar, color: Colors.colorFaded),
                          fontSize: 15
                      );
                    })
                ),
                SizedBox(width: 16),
                Expanded(child: StreamBuilder(
                    stream: _identificationForm.expiryDateStream,
                    builder: (context, snapshot) {
                      return Styles.appEditText(
                          controller: _expiryDateController,
                          onClick: () => displayDatePicker(context, dateType: "expiry"),
                          errorText: snapshot.hasError ? snapshot.error.toString() : null,
                          hint: 'Expiry Date',
                          animateHint: false,
                          readOnly: true,
                          startIcon: Icon(CustomFont.calendar, color: Colors.colorFaded),
                          fontSize: 15
                      );
                    })
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3.4),
                  border: Border.all(color: Colors.colorFaded, width: 0.5)
              ),
              child: Row(
                children: [
                  SvgPicture.asset('res/drawables/ic_file.svg', width: 26, height: 26,),
                  SizedBox(width: 16),
                  Flexible(flex: 1,child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      StreamBuilder(
                          stream: _identificationForm.idTypeStream,
                          builder: (context, AsyncSnapshot<IdentificationType?> snapshot) {
                            final idType = snapshot.hasData ? snapshot.data : null;
                            return Text(
                                (idType != null) ? "Upload ${idType.idType}" :uploadedFileName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(color: Colors.textColorBlack, fontSize: 15, fontWeight: FontWeight.bold)
                            );
                          }
                      ),
                      SizedBox(height: 1),
                      Text('$requiredTierText', style: TextStyle(color: Colors.deepGrey, fontFamily: Styles.defaultFont, fontSize: 12),)
                          .colorText(getColoredTier(requiredTiers)),
                    ],
                  )),
                  SizedBox(width: 8),
                  Flexible(flex:0,child: TextButton(
                      onPressed: _chooseIdentificationImage,
                      child: Text('UPLOAD',  style: TextStyle(color: Colors.primaryColor, fontWeight: FontWeight.bold))
                  )),
                ],
              ),
            ),
            SizedBox(height: 12),
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(flex:1, child: Text(
                  'File should not be larger than 2MB',
                  style: TextStyle(color: Colors.colorFaded, fontSize: 14),
                )),
                SizedBox(width: 8),
                Flexible(
                    flex: 0,
                    child: AccountUpdateFileUploadState(_fileUploadState)
                )
              ],
            )),
            SizedBox(height: 32),
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                    visible: !widget.isLast(),
                    child: Flexible(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                          width: double.infinity,
                          child: Styles.appButton(
                              elevation: 0,
                              buttonStyle: Styles.greyButtonStyle,
                              onClick: () {
                                _resetForm();
                                saveForm();
                                viewModel.moveToNext(widget.position);
                              },
                              text: 'Skip for Now'
                          ),
                        ),
                      ),
                    )
                ),
                SizedBox(width: (!widget.isLast()) ? 32 : 0,),
                Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Styles.statefulButton(
                          stream: _identificationForm.isValid,
                          onClick: () {
                            saveForm();
                            viewModel.moveToNext(widget.position);
                          },
                          text: widget.isLast() ? 'Proceed' : 'Next',
                          isLoading: false
                      ),
                    ))
              ],
            )),
            // SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}