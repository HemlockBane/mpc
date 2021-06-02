import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:provider/provider.dart';

import 'account_update_file_upload_state.dart';
import 'account_update_form_view.dart';

class ProofOfAddressScreen extends PagedForm {

  @override
  State<StatefulWidget> createState() {
    return _ProofOfAddressScreen();
  }
}

class _ProofOfAddressScreen extends State<ProofOfAddressScreen> with AutomaticKeepAliveClientMixin {

  UploadState _fileUploadState = UploadState.NONE;
  String uploadedFileName = "Upload International Passport";

  void saveForm() {
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    final info = viewModel.addressForm.getAddressInfo.utilityBillUUID;
    PreferenceUtil.saveValueForLoggedInUser("account-update-address-proof-uuid", info);
    PreferenceUtil.saveValueForLoggedInUser("account-update-address-proof-filename", uploadedFileName);
  }

  void onRestoreForm() {
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    final addressProofUUID = PreferenceUtil.getValueForLoggedInUser<String>("account-update-address-proof-uuid");
    final fileName = PreferenceUtil.getValueForLoggedInUser<String>("account-update-address-proof-filename");

    if(addressProofUUID != null && addressProofUUID.isNotEmpty) {
      viewModel.addressForm.onUtilityBillChange(addressProofUUID);
      if(fileName!=null && fileName.isNotEmpty) {
        setState(() {
          uploadedFileName = fileName;
        });
      }
    }
  }

  Map<String, Tuple<Color, VoidCallback?>> getColoredTier() {
    return {
      "Tier 2": Tuple(Colors.primaryColor, null),
      "Tier 3": Tuple(Colors.primaryColor, null),
    };
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

    viewModel.uploadAddressProof(file.path ?? "").listen((event) {
      if(event is Loading) setState(() {
        uploadedFileName = file.name ?? uploadedFileName;
        _fileUploadState = UploadState.LOADING;
      });
      if(event is Success) {
        viewModel.addressForm.onUtilityBillChange(event.data?.UUID);
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
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 200),() {
        onRestoreForm();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);

    return ScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3.4),
                  border: Border.all(color: Colors.colorFaded, width: 0.5)
              ),
              child: Row(
                children: [
                  SvgPicture.asset('res/drawables/ic_file.svg', width: 26, height: 26),
                  SizedBox(width: 16),
                  Flexible(flex: 1,child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                          uploadedFileName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: Colors.textColorBlack, fontSize: 15, fontWeight: FontWeight.bold)
                      ),
                      SizedBox(height: 1),
                      Text('Required for Tier 2,  Tier 3', style: TextStyle(color: Colors.deepGrey, fontFamily: Styles.defaultFont, fontSize: 12),)
                          .colorText(getColoredTier()),
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
            Expanded(flex:0,child: Row(
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
                  SvgPicture.asset('res/drawables/ic_info.svg', width: 28, height: 28,),
                  SizedBox(width: 9),
                  Text(
                    'Acceptable documents include:\n\u2022\t\tUtility Bills (e.g. electricity bills)\n\u2022\t\tTenancy Agreements\n\u2022\t\tResident Permits',
                    style: TextStyle(color: Colors.darkBlue, fontSize: 15, fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
            Expanded(child: Row(
              children: [
                (widget.isLast()) ? SizedBox() : Flexible(child: Container()),
                Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Styles.statefulButton(
                          stream: viewModel.addressForm.utilityBillStream.map((event) => event.isNotEmpty),
                          onClick: () {
                            saveForm();
                            viewModel.moveToNext(widget.position);
                          },
                          text: widget.isLast() ? 'Proceed' : 'Next',
                          isLoading: false
                      ),
                    )),
              ],
            )),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}