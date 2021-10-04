import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/customer_address_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/core/views/upload_request_dialog.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

import '../account_update_file_upload_state.dart';
import 'account_update_form_view.dart';
import '../account_update_upload_button.dart';

class ProofOfAddressScreen extends PagedForm {

  @override
  State<StatefulWidget> createState() {
    return _ProofOfAddressScreen();
  }

  @override
  String getTitle() => "Proof Of Address";
}

class _ProofOfAddressScreen extends State<ProofOfAddressScreen> with AutomaticKeepAliveClientMixin {

  late final AccountUpdateViewModel _viewModel;
  late final CustomerAddressForm _addressForm;

  UploadState _fileUploadState = UploadState.NONE;
  String uploadedFileName = "Upload Proof of Address";

  void _chooseIdentificationImage() async  {

    final file = await requestUpload(context);

    if(file == null) return;

    if(file is PlatformFile) {
      _viewModel.uploadAddressProof(file.path ?? "").listen((event) {
        if (event is Loading) setState(() {
          uploadedFileName = file.name ?? uploadedFileName;
          _fileUploadState = UploadState.LOADING;
        });
        if (event is Success) {
          _viewModel.addressForm.onUtilityBillChange(event.data?.UUID, file.name);
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
  void initState() {
    _viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    _addressForm = _viewModel.addressForm;
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 200),() {
        _addressForm.restoreFormState();
      });
    });
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
                stream: _addressForm.utilityBillStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  final uploadTypeName = "Upload Proof of Address";
                  final previousFileName = _addressForm.getAddressInfo.uploadedFileName;
                  return AccountUpdateUploadButton(
                    title: previousFileName ?? uploadTypeName,
                    onClick: _chooseIdentificationImage,
                  );
                }
            ),
            SizedBox(height: 12),
            Expanded(flex:0,child: Row(
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
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.primaryColor.withOpacity(0.1)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('res/drawables/ic_info.svg', width: 28, height: 28),
                  SizedBox(width: 9),
                  Text(
                    'Acceptable documents include:\n\u2022\t\tUtility Bills (e.g. electricity bills)\n\u2022\t\tTenancy Agreements\n\u2022\t\tResident Permits',
                    style: TextStyle(color: Colors.solidDarkBlue, fontSize: 15, fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
            SizedBox(height: 32,),
            Spacer(),
            StreamBuilder(
                stream: _viewModel.loadingState,
                builder: (ctx, AsyncSnapshot<bool> isLoading) {
                  return Styles.statefulButton(
                      stream: _viewModel.addressForm.utilityBillStream.map((event) => event.isNotEmpty),
                      onClick: () {
                        _addressForm.skipProofOfAddress(false);
                        _viewModel.moveToNext(widget.position);
                        },
                      text: widget.isLast() ? 'Submit' : 'Next',
                      isLoading: isLoading.hasData && isLoading.data == true
                  );
                },
            ),
            SizedBox(height: !widget.isLast() ? 41 : 0),
            if (!widget.isLast())
              TextButton(
                  onPressed: () {
                    _addressForm.skipProofOfAddress(true);
                    _viewModel.moveToNext(widget.position);
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
            SizedBox(height: 32,),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}