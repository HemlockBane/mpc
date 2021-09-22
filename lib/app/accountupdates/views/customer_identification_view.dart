import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/customer_identification_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/account_update_file_upload_state.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/account_update_upload_button.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

import 'account_update_form_view.dart';
import '../../../core/views/upload_request_dialog.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';

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

  late final AccountUpdateViewModel _viewModel;
  late final CustomerIdentificationForm _identificationForm;

  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _registrationNumberController = TextEditingController();

  DateTime? _expiryDate;
  DateTime? _issueDate;

  UploadState _fileUploadState = UploadState.NONE;

  @override
  void initState() {
    this._viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    this._identificationForm = _viewModel.identificationForm;

    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration.zero,() {
        _identificationForm.restoreFormState();
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
    final file = await requestUpload(context);

    if(file == null) return;

    if(file is PlatformFile) {
      _viewModel.uploadValidIdentity(file.path ?? "").listen((event) {
        if (event is Loading) setState(() {
          _fileUploadState = UploadState.LOADING;
        });
        if (event is Success) {
          _identificationForm.onImageReferenceChanged(event.data?.UUID, file.name);
          setState(() {
            _fileUploadState = UploadState.SUCCESS;
          });
        }
        if (event is Error) {
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.getTitle(),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.textColorBlack,
                    fontSize: 21
                )
            ),
            SizedBox(height: 22,),
            StreamBuilder(
                stream: _identificationForm.idTypeStream,
                builder: (BuildContext context, AsyncSnapshot<IdentificationType?> snapshot) {
                  return Styles.buildDropDown(identificationTypes, snapshot, (value, i) {
                    _identificationForm.onIdentificationTypeChange(value as IdentificationType);
                  }, hint: 'Identification Type');
                }),
            SizedBox(height: 20),
            StreamBuilder(
                stream: _identificationForm.idNumberStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _registrationNumberController.withDefaultValueFromStream(
                          snapshot, _identificationForm.identificationInfo.registrationNumber
                      ),
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _identificationForm.onIdentificationNumberChange,
                      hint: 'ID Number',
                      animateHint: false,
                      fontSize: 15
                  );
                }),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: StreamBuilder(
                    stream: _identificationForm.issueDateStream,
                    builder: (context, AsyncSnapshot<String?> snapshot) {
                      return Styles.appEditText(
                          controller: _issueDateController.withDefaultValueFromStream(
                              snapshot, _identificationForm.identificationInfo.identityIssueDate
                          ),
                          onClick: () => displayDatePicker(context),
                          errorText: snapshot.hasError ? snapshot.error.toString() : null,
                          hint: 'Issue Date',
                          animateHint: false,
                          readOnly: true,
                          startIcon: Icon(CustomFont.calendar, color: Colors.textFieldIcon.withOpacity(0.4)),
                          fontSize: 15
                      );
                    })
                ),
                SizedBox(width: 16),
                Expanded(child: StreamBuilder(
                    stream: _identificationForm.expiryDateStream,
                    builder: (context, AsyncSnapshot<String?> snapshot) {
                      return Styles.appEditText(
                          controller: _expiryDateController.withDefaultValueFromStream(
                              snapshot, _identificationForm.identificationInfo.identityExpiryDate
                          ),
                          onClick: () => displayDatePicker(context, dateType: "expiry"),
                          errorText: snapshot.hasError ? snapshot.error.toString() : null,
                          hint: 'Expiry Date',
                          animateHint: false,
                          readOnly: true,
                          startIcon: Icon(CustomFont.calendar, color: Colors.textFieldIcon.withOpacity(0.4)),
                          fontSize: 15
                      );
                    })
                ),
              ],
            ),
            SizedBox(height: 40),
            StreamBuilder(
                stream: _identificationForm.idTypeStream,
                builder: (context, AsyncSnapshot<IdentificationType?> snapshot) {
                  final idType = snapshot.hasData ? snapshot.data : null;
                  final idTypeName = (idType != null) ? "Upload ${idType.idType}" : "Upload Identification Document";
                  final previousFileName = _identificationForm.identificationInfo.uploadedFileName;
                  return AccountUpdateUploadButton(
                    title: previousFileName ?? idTypeName,
                    onClick: _chooseIdentificationImage,
                  );
                }
            ),
            SizedBox(height: 12),
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 0,
                    child: AccountUpdateFileUploadState(_fileUploadState)
                ),
                SizedBox(width: 8),
                Flexible(flex:1, child: Text(
                  'File should not be larger than 5mb',
                  style: TextStyle(color: Colors.colorFaded, fontSize: 14),
                )),
              ],
            )),
            SizedBox(height: 32),
            Styles.statefulButton(
                stream: _identificationForm.isValid,
                onClick: () {
                  _viewModel.moveToNext(widget.position);
                  _identificationForm.skipForm(false);
                },
                text: widget.isLast() ? 'Submit' : 'Next',
                isLoading: false
            ),
            SizedBox(height: !widget.isLast() ? 41 : 0),
            if (!widget.isLast())
              TextButton(
                  onPressed: () {
                    _viewModel.moveToNext(widget.position);
                    _identificationForm.skipForm(true);
                  },
                  child: Text(
                    "Skip for now",
                    style: TextStyle(
                        color: Colors.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                    ),
                  )
              ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}