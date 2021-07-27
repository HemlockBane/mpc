import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moniepoint_flutter/app/branches/model/data/branch_info.dart';
import 'package:moniepoint_flutter/app/branches/viewmodels/branch_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class BranchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BranchScreen();
}

class _BranchScreen extends State<BranchScreen> {
  GoogleMapController? _mapController;
  Position? _lastLocation;
  Set<Marker> _displayAbleMarkers = {};
  double currentZoom = 10.4;
  BitmapDescriptor? pinLocationIcon;

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.5244, 3.3792),
    zoom: 10.4,
  );

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3),
        "res/drawables/ic_location_marker.png");
  }

  void _fetchLastLocation() async {
    final viewModel = Provider.of<BranchViewModel>(context, listen: false);
    _lastLocation = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true);

    if (_lastLocation != null) {
      _lastLocation = await Geolocator.getCurrentPosition();
    }

    viewModel
        .getAllBranches(
            _lastLocation?.latitude ?? 0,
            _lastLocation?.longitude ?? 0,
            _radiusInMeters(_lastLocation?.longitude ?? 0).toInt())
        .listen((event) {
      if (event is Success && event.data!.length > 0) {
        _addBranchesAsMarkerToMap(event.data!);
      }
    });
  }

  double _radiusInMeters(double longitude) {
    return 156543.03392 *
        cos(longitude * pi / 180) /
        pow(2.0, currentZoom); //2.0.pow((currentZoom).toDouble());
  }

  void _addBranchesAsMarkerToMap(List<BranchInfo> branches) {
    if (branches.isNotEmpty) _displayAbleMarkers.clear();
    List<LatLng?> latLngs = branches
        .map((e) {
          if (e.location == null ||
              e.location?.longitude == null ||
              e.location?.latitude == null) return null;
          //let's also add the marker
          _addBranchAsMarker(e);
          return LatLng(double.parse(e.location!.latitude!),
              double.parse(e.location!.longitude!));
        })
        .where((element) => element != null)
        .toList();

    if (latLngs.isNotEmpty) {
      setState(() {});
      LatLngBounds bounds = boundsFromLatLngList(latLngs);
      final mUpdate = CameraUpdate.newLatLngBounds(bounds, 0);
      _mapController?.animateCamera(mUpdate).then((value) {
        check(mUpdate, _mapController!);
      });
    }
  }

  bool _addBranchAsMarker(BranchInfo info) {
    Locations? location = info.location;
    if (location != null &&
        location.latitude != null &&
        location.longitude != null) {
      final branchPosition = LatLng(double.parse(location.latitude ?? "0"),
          double.parse(location.longitude ?? "0"));
      _displayAbleMarkers.add(
        Marker(
          markerId: MarkerId(info.id.toString()),
          position: branchPosition,
          infoWindow: InfoWindow(title: info.name),
          // icon: pinLocationIcon!,
        ),
      );
      return true;
    }
    return false;
  }

  void _checkLocationPermission() async {
    final isPermissionGranted = await Permission.location.request().isGranted;
    if (isPermissionGranted) {
      _fetchLastLocation();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    final movingZoom = cameraPosition.zoom;
    if (currentZoom.floorToDouble() != movingZoom.floorToDouble()) {
      //We are zooming
      currentZoom = movingZoom;
      _fetchLastLocation();
    }
    currentZoom = movingZoom;
  }

  void _onSearch() async {
    final branchInfo =
        await Navigator.of(context).pushNamed(Routes.BRANCHES_SEARCH);
    print("BRANCH INFO");
    print((branchInfo as BranchInfo).name);

    if (branchInfo != null && branchInfo is BranchInfo) {
      _displayAbleMarkers.clear();
      if (_addBranchAsMarker(branchInfo)) {
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            _addBranchAsMarker(branchInfo);
          });
        });

        await Future.delayed(Duration(milliseconds: 1500), () {
          final branchPosition = LatLng(
              double.parse(branchInfo.location!.latitude ?? "0"),
              double.parse(branchInfo.location!.longitude ?? "0"));
          CameraUpdate cUpdate = CameraUpdate.newLatLngZoom(branchPosition, 16);
          _mapController?.animateCamera(cUpdate).then((value) {
            check(cUpdate, _mapController!);
          });
        });
        showBottomSheet(branchInfo);
      }
    }
  }

  void showBottomSheet(BranchInfo branchInfo) {
    _scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 250,
        decoration: BoxDecoration(
          color: Colors.backgroundWhite,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 30,
              offset: Offset(0, -12),
              color: Color(0xFF063A4F).withOpacity(0.1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 7,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    child: SvgPicture.asset(
                        "res/drawables/ic_location_close_2.svg"),
                  ),
                )
              ],
            ),
            Text(branchInfo.name ?? "",
                style: _style(fontWeight: FontWeight.w600, fontSize: 17)),
            SizedBox(height: 11),
            Text(branchInfo.location?.address ?? "", style: _style()),
            SizedBox(height: 11),
            Text(branchInfo.phoneNumber ?? "", style: _style()),
            SizedBox(height: 11),
            Text(branchInfo.email ?? "", style: _style()),
            SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => openUrl("tel:${branchInfo.phoneNumber}"),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                          color: Color(0xFF0361F0).withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                              "res/drawables/ic_support_phone.svg"),
                          SizedBox(width: 14),
                          Text(
                            "Call Branch",
                            style: _style(
                                color: Color(0xFF0361F0),
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: () => openUrl(
                          "geo:${branchInfo.location?.latitude}, ${branchInfo.location?.longitude}"),
                      child: Text(
                        "Share Location",
                        style: _style(
                            color: Color(0xFF0361F0),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    });
  }

  TextStyle _style(
      {FontWeight fontWeight = FontWeight.normal,
      double fontSize = 13,
      Color color = const Color(0xFF1A0C2F)}) {
    return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    _mapController?.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    //if(l1.southwest.latitude==-90 ||l2.southwest.latitude==-90)
    //check(u, c);
  }

  LatLngBounds boundsFromLatLngList(List<LatLng?> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng? latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng!.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (x1 == null || latLng!.latitude > x1) x1 = latLng!.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (y1 == null || latLng.longitude > y1) y1 = latLng.longitude;
        if (y0 == null || latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  void _zoomOut() {
    Future.delayed(Duration(milliseconds: 185), () {
      CameraUpdate mUpdate = CameraUpdate.zoomOut();
      _mapController?.animateCamera(mUpdate);
    });
  }

  void _zoomIn() {
    Future.delayed(Duration(milliseconds: 185), () {
      CameraUpdate mUpdate = CameraUpdate.zoomIn();
      _mapController?.animateCamera(mUpdate);
    });
  }

  Widget zoomButtonContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 1),
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 6,
                spreadRadius: 2)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8), topLeft: Radius.circular(8)),
              onTap: () => _zoomIn(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text('+',
                    style: TextStyle(
                        color: Colors.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          SizedBox(
              width: 36,
              child: Divider(
                height: 1,
                color: Colors.colorFaded.withOpacity(0.5),
                thickness: 1,
              )),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              onTap: () => _zoomOut(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text('-',
                    style: TextStyle(
                        color: Colors.primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _checkLocationPermission();
            },
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            compassEnabled: true,
            zoomControlsEnabled: false,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            onCameraMove: _onCameraMove,
            markers: _displayAbleMarkers,
          ),

          Positioned(
            top: 30,
            right: 16,
            left: 16,
            child: Styles.appEditText(
              readOnly: true,
              // padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              drawablePadding: EdgeInsets.symmetric(horizontal: 15),
              borderColor: Colors.transparent,
              value: 'Search by branch name',
              hint: 'Search by branch name',
              fontWeight: FontWeight.normal,
              animateHint: false,
              textColor: Color(0xFF9DA1AB),
              fontSize: 15,
              startIcon:
                  Icon(CustomFont.search, color: Color(0xFF9DA1AB), size: 20),
              onClick: _onSearch,
            ),
          ),

          // DraggableScrollableSheet(
          //     initialChildSize: 0.35,
          //     minChildSize: 0.35,
          //     maxChildSize: 0.68,
          //     builder:
          //         (BuildContext context, ScrollController scrollController) {
          //       return Card(
          //         margin: EdgeInsets.zero,
          //         shape: RoundedRectangleBorder(
          //             borderRadius:
          //                 BorderRadius.vertical(top: Radius.circular(20))),
          //         elevation: 5,
          //         child: ListView(
          //           padding: EdgeInsets.symmetric(horizontal: 24),
          //           controller: scrollController,
          //           children: [
          //             SizedBox(
          //               height: 10,
          //             ),
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Container(
          //                   height: 7,
          //                   width: 45,
          //                   decoration: BoxDecoration(
          //                     color: Colors.grey.withOpacity(0.2),
          //                     borderRadius: BorderRadius.circular(16),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             SizedBox(
          //               height: 20,
          //             ),
          //             Container(
          //                 child: Text(
          //               "BRANCHES CLOSE TO YOU",
          //               style: TextStyle(
          //                   fontSize: 14,
          //                   color: Colors.textColorBlack,
          //                   fontWeight: FontWeight.w600),
          //             ))
          //           ],
          //         ),
          //       );
          //     })
          // Positioned(
          //   right: 24,
          //   bottom: 42,
          //   child: zoomButtonContainer(),
          // )
        ],
      ),
    );
  }
}
