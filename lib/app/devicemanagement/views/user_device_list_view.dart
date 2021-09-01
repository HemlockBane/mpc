import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/views/error_layout_view.dart';
import 'package:moniepoint_flutter/app/devicemanagement/model/data/user_device.dart';
import 'package:moniepoint_flutter/app/devicemanagement/viewmodels/user_device_view_model.dart';
import 'package:moniepoint_flutter/app/devicemanagement/views/dialogs/remove_user_device_dialog.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_shimmer_view.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/timeout_reason.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/utils/time_ago.dart';
import 'package:moniepoint_flutter/core/views/generic_list_placeholder.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

class UserDeviceListView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _UserDeviceListView();

}

class _UserDeviceListView extends State<UserDeviceListView> with SingleTickerProviderStateMixin {

  late final AnimationController _animationController;
  final List<UserDevice> _currentItems = [];
  Stream<Resource<List<UserDevice>>>? _userDevicesStream;

  @override
  void initState() {

    this._animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000)
    );

    final viewModel = Provider.of<UserDeviceViewModel>(context, listen: false);
    _userDevicesStream = viewModel.getUserDevices(PreferenceUtil.getSavedUsername() ?? "");

    super.initState();
  }

  void _subscribeUiToDeleteDevice(UserDevice userDevice) async {
    final viewModel = Provider.of<UserDeviceViewModel>(context, listen: false);
    final result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (mContext) => ChangeNotifierProvider.value(
          value:  viewModel,
          child:  RemoveUserDeviceDialog(userDevice),
        ));
    if (result is bool && result) {
      final message = (viewModel.getCurrentDeviceId() == userDevice.deviceId)
          ? "Device has been removed successfully.\nPlease kindly login again to continue using Moniepoint."
          : "Device has been removed successfully.";

      await showSuccess(
          context,
          title: "Device Removed",
          message: message
      );
      if(viewModel.getCurrentDeviceId() == userDevice.deviceId) {
        //We need to clear out the finger print
        //if the device removed is the fingerprint enabled device
        if(PreferenceUtil.getFingerPrintEnabled()) {
          BiometricHelper.getInstance().deleteFingerPrintPassword();
          PreferenceUtil.clearOutFingerPrintSession();
        }
        UserInstance().forceLogout(context, SessionTimeoutReason.LOGIN_REQUESTED);
      } else {
        setState(() {
          _userDevicesStream = viewModel.getUserDevices(PreferenceUtil.getSavedUsername() ?? "");
        });
      }


    } else if(result is Error) {
      showError(context, title: "Failed Removing Device", message: result.message ?? "");
    }
  }

  Widget makeListView(BuildContext context, AsyncSnapshot<Resource<List<UserDevice>?>> a) {
    final resource = (a.hasData) ? a.data : null;
    final viewModel = Provider.of<UserDeviceViewModel>(context, listen: false);
    Tuple<String?, String?>? errorMessage;

    if(resource != null && resource is Error<dynamic>)
      errorMessage = formatError((resource as Error).message, "Devices");

    return ListViewUtil.makeListViewWithState(
        context: context,
        loadingView: BeneficiaryShimmer(),
        snapshot: a,
        animationController: _animationController,
        errorLayoutView: ErrorLayoutView(
            errorMessage?.first ?? "",
            errorMessage?.second ?? "",
            () => setState(() {
              final viewModel = Provider.of<UserDeviceViewModel>(context, listen: false);
              _userDevicesStream = viewModel.getUserDevices(PreferenceUtil.getSavedUsername() ?? "");
            })
        ),
        emptyPlaceholder: GenericListPlaceholder(
            SvgPicture.asset('res/drawables/ic_empty_record_state.svg'),
            'You have no saved devices yet.'
        ),
        currentList: _currentItems,
        listView: (List<UserDevice>? items) {
          return ListView.separated(
              shrinkWrap: true,
              itemCount: items?.length ?? 0,
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Divider(color: Color(0XFFE0E0E0), height: 1,),
              ),
              itemBuilder: (context, index) {
                final currentItem = items![index];
                return _UserDeviceListItem(currentItem, index, (item, position){
                  _subscribeUiToDeleteDevice(item);
                }, viewModel.getCurrentDeviceId() == currentItem.deviceId);
              });
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SessionedWidget(
        context: context,
        child: Scaffold(
          appBar: AppBar(
              leadingWidth: 69,
              centerTitle: false,
              titleSpacing: -12,
              iconTheme: IconThemeData(color: Colors.primaryColor),
              title: Text('Registered Devices',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.darkBlue,
                      fontFamily: Styles.defaultFont,
                      fontSize: 17
                  )
              ),
              backgroundColor: Colors.backgroundWhite,
              elevation: 0
          ),
          body: Column(
            children: [
              Expanded(child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.darkBlue.withOpacity(0.1),
                          offset: Offset(0, 4),
                          blurRadius: 12
                      )
                    ]
                ),
                child: StreamBuilder(
                    stream: _userDevicesStream ,
                    builder: (BuildContext context, AsyncSnapshot<Resource<List<UserDevice>?>> a) {
                      return makeListView(context, a);
                    }),
              ))
            ],
          ),
        ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

}

class _UserDeviceListItem extends StatelessWidget{

  final UserDevice _userDevice;
  final int position;
  final OnItemClickListener<UserDevice, int>? _onItemClickListener;
  final bool isLoggedInDevice;

  _UserDeviceListItem(this._userDevice, this.position, this._onItemClickListener, this.isLoggedInDevice);

  Widget initialView() {
    return Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _userDevice.os != null
              ? Colors.primaryColor.withOpacity(0.1)
              : Colors.darkBlue.withOpacity(0.1)
      ),
      child: Center(
        child: _getDeviceIcon(),
      ),
    );
  }

  Widget _getDeviceIcon() {
    if (_userDevice.os != null && _userDevice.os?.toLowerCase() == "android") {
      return SvgPicture.asset("res/drawables/ic_android.svg", color: Colors.primaryColor);
    } else if (_userDevice.os != null && _userDevice.os?.toLowerCase() == "ios") {
      return SvgPicture.asset("res/drawables/ic_ios.svg", color: Colors.primaryColor);
    }
    return SvgPicture.asset(
      'res/drawables/ic_edit_device.svg',
      width: 20,
      height: 20,
      color: Colors.deepGrey.withOpacity(1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = _userDevice.os ?? "Unknown";
    return Material(
      color: Colors.transparent,
      child: InkWell(
        // onTap: () => _onItemClickListener?.call(_userDevice, position),
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
          child: Row(
            children: [
              initialView(),
              SizedBox(width: 16),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(child: Text(
                                _userDevice.name ?? "--",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 16, color: Colors.darkBlue, fontWeight: FontWeight.bold)
                            )),
                            SizedBox(width: 8,),
                            Visibility(
                              visible: isLoggedInDevice,
                              child: TextButton(
                                onPressed: () => null,
                                child: Text('Logged In',
                                  style: TextStyle(color: Colors.solidOrange, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size(40, 0)),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    overlayColor: MaterialStateProperty.all(Colors.solidOrange.withOpacity(0.2)),
                                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 8, vertical: 5)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                    backgroundColor: MaterialStateProperty.all(Colors.solidOrange.withOpacity(0.2))
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                            "$deviceType - Added ${TimeAgo.formatDuration(_userDevice.dateAdded?.millisecondsSinceEpoch ?? 0)}",
                            style: TextStyle(fontSize: 12, color: Colors.deepGrey, fontWeight: FontWeight.normal, fontFamily: Styles.defaultFont)
                        ).colorText({"$deviceType": Tuple(Colors.deepGrey, null)}, underline: false)
                      ]
                  )),
              Styles.imageButton(
                  image: SvgPicture.asset('res/drawables/ic_trash.svg', width: 24.5, height: 24.5, color: Colors.darkBlue.withOpacity(0.3),),
                  borderRadius: BorderRadius.circular(30),
                  padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                  color: Colors.transparent,
                  onClick: () => _onItemClickListener?.call(_userDevice, position)
              ),
              SizedBox(width: 2),
            ],
          ),
        ),
      ),
    );
  }


}