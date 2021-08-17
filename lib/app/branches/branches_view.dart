import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:moniepoint_flutter/app/branches/branch_search_view.dart';
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

import 'dart:ui' as ui;

class BranchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BranchScreen();
}

class _BranchScreen extends State<BranchScreen> {
  GoogleMapController? _mapController;
  LocationData? _lastLocation;
  Set<Marker> _displayAbleMarkers = {};
  double currentZoom = 10.4;
  BitmapDescriptor? locationMarkerIcon;
  BitmapDescriptor? fadedMarkerIcon;

  List<BranchInfo> displayableBranches = [];
  Location location = Location();

  List<BranchInfo> closeBranches = [];
  bool shouldShowCloseBranches = false;
  Timer? debouncer;

  late SelectedLocation selectedLocation;

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.5244, 3.3792),
    zoom: 10.4,
  );

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _buildCustomMapMarkers();
  }

  Future<Uint8List> getMarkerBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _buildCustomMapMarkers() async {
    final Uint8List markerIconBytes = await getMarkerBytesFromAsset(
        'res/drawables/ic_location_marker.png', 100);
    locationMarkerIcon = BitmapDescriptor.fromBytes(markerIconBytes);

    final Uint8List fadedMarkerIconBytes = await getMarkerBytesFromAsset(
        'res/drawables/ic_location_marker_faded.png', 100);
    fadedMarkerIcon = BitmapDescriptor.fromBytes(fadedMarkerIconBytes);
  }

  Future<LocationData?> _fetchLastLocation() async {
    // _lastLocation = await Geolocator.getLastKnownPosition(
    //     forceAndroidLocationManager: true);
    //
    // if (_lastLocation != null) {
    //   _lastLocation = await Geolocator.getCurrentPosition();
    //
    // }

   _lastLocation =  await location.getLocation();
    return _lastLocation;
  }

  void getBranchesAroundSelectedLocation({bool shouldForceCenter = false, bool isZoomingIn = false}) {
    final viewModel = Provider.of<BranchViewModel>(context, listen: false);
    final latitude = selectedLocation.location.latitude;
    final longitude = selectedLocation.location.longitude;
    final branchInfo = selectedLocation.branchInfo;

    final location = LatLng(_lastLocation?.latitude ?? 0, _lastLocation?.longitude ?? 0);


    viewModel
        .getAllBranches(latitude, longitude, _radiusInMeters(longitude).toInt())
        .listen((event) async {
      if (event is Success && event.data!.length > 0) {
        final branches = event.data!;

        displayableBranches
          ..clear()
          ..addAll(branches);

        if (branchInfo != null) {
          branches.add(branchInfo);
        }
        _updateBranchMarkersOnMap(branches,
            shouldForceCenter: shouldForceCenter);

        if (selectedLocation.isCurrentLocation(location) && !isZoomingIn) {
          moveCameraToCurrentPosition();
          setState(() {
            closeBranches = branches;
            shouldShowCloseBranches = true;
          });
        }
      }
    });
  }

  double _radiusInMeters(double longitude) {
    return 156543.03392 *
        cos(longitude * pi / 180) /
        pow(2.0, currentZoom); //2.0.pow((currentZoom).toDouble());
  }

  void _updateBranchMarkersOnMap(List<BranchInfo> branches,
      {bool shouldForceCenter = false}) {
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
    }).where((element) => element != null).toList();

    if (latLngs.isNotEmpty) {
      setState(() {});
      if (shouldForceCenter) {
        // LatLngBounds bounds = boundsFromLatLngList(latLngs);
        // final mUpdate = CameraUpdate.newLatLngBounds(bounds, 0);
        // _mapController?.animateCamera(mUpdate).then((value) {
        //   check(mUpdate, _mapController!);
        // });
      }
    }
  }

  bool _addBranchAsMarker(BranchInfo branchInfo) {
    Locations? location = branchInfo.location;
    if (location != null &&
        location.latitude != null &&
        location.longitude != null) {
      final branchLocation = LatLng(double.parse(location.latitude ?? "0"),
          double.parse(location.longitude ?? "0"));

      final markerIcon = selectedLocation.isCurrentLocation(LatLng(
          _lastLocation?.latitude ?? 0, _lastLocation?.longitude ?? 0))
          ? locationMarkerIcon!
          : selectedLocation.equalsBranchPosition(branchLocation)
          ? locationMarkerIcon!
          : fadedMarkerIcon!;

      final marker = Marker(

        markerId: MarkerId(branchInfo.id.toString()),
        position: branchLocation,
        infoWindow: InfoWindow(title: branchInfo.name),
        icon: markerIcon,
        onTap: () {
          final sLocation = SelectedLocation(
            location: LatLng(branchLocation.latitude, branchLocation.longitude),
            branchInfo: branchInfo,
          );

          final isSelectedMarker =
          selectedLocation.equalsBranchPosition(branchLocation);
          if (!isSelectedMarker) {
            selectedLocation = sLocation;
            shouldShowCloseBranches = false;
            _updateBranchMarkersOnMap(displayableBranches);
            showBranchInfoBottomSheet(branchInfo);
          }
        },
      );

      _displayAbleMarkers.add(marker);
      return true;
    }
    return false;
  }

  void updateSelectedLocation(SelectedLocation sLocation) {
    selectedLocation = sLocation;
  }

  Future<bool> _checkLocationPermission() async {
    return await Permission.location.request().isGranted;
  }

  void _onCameraMove(CameraPosition cameraPosition) async {
    final movingZoom = cameraPosition.zoom;
    if (currentZoom.floorToDouble() != movingZoom.floorToDouble()) {
      //We are zooming
      currentZoom = movingZoom;
    }


    if(currentZoom > 11){
      debouncer?.cancel();
      debouncer = Timer(Duration(milliseconds: 700), () {
        getBranchesAroundSelectedLocation(
            shouldForceCenter: false,
            isZoomingIn: true
        );
      });
    }
  }

  void _onSearch() async {
    final branchInfo = await Navigator.of(context).pushNamed(Routes.BRANCHES_SEARCH);


    if (branchInfo != null && branchInfo is BranchInfo) {
      setState(() {
        if (shouldShowCloseBranches) shouldShowCloseBranches = false;
      });
      _displayAbleMarkers.clear();

      final location = branchInfo.location;
      final latitude = double.parse(location?.latitude ?? "0");
      final longitude = double.parse(location?.longitude ?? "0");

      final sLocation = SelectedLocation(
        location: LatLng(latitude, longitude),
        branchInfo: branchInfo,
      );

      updateSelectedLocation(sLocation);
      getBranchesAroundSelectedLocation();
      await moveCameraToBranchPosition(branchInfo);
      showBranchInfoBottomSheet(branchInfo);
    }
  }

  Future<void> moveCameraToBranchPosition(BranchInfo branchInfo) async {
    await Future.delayed(Duration(milliseconds: 1500), () {
      final branchPosition = LatLng(
          double.parse(branchInfo.location!.latitude ?? "0"),
          double.parse(branchInfo.location!.longitude ?? "0"));

      CameraUpdate cUpdate = CameraUpdate.newLatLngZoom(branchPosition, 11);
      _mapController?.animateCamera(cUpdate).then((value) {
        check(cUpdate, _mapController!);
      });
    });
  }

  Future<void> moveCameraToCurrentPosition() async {
    await Future.delayed(Duration(milliseconds: 1500), () {
      final currentPosition =
      LatLng(_lastLocation?.latitude ?? 0, _lastLocation?.longitude ?? 0);

      CameraUpdate cUpdate = CameraUpdate.newLatLngZoom(currentPosition, 11);
      _mapController?.animateCamera(cUpdate).then((value) {
        check(cUpdate, _mapController!);
      });
    });
  }

  void closeVisibleModals() {
    var hasModalRoute = ModalRoute.of(context)?.willHandlePopInternally ?? false;
    if (hasModalRoute) {
      Navigator.pop(context);
    }
  }

  void showBranchInfoBottomSheet(BranchInfo branchInfo) {
    closeVisibleModals();
    _scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          border: Border.all(
              width: 1.0, color: Color(0xff063A4F0D).withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              blurRadius: 30,
              offset: Offset(0, -12),
              color: Color(0xFF063A4F).withOpacity(0.2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    final sLocation = SelectedLocation(
                        location: LatLng(_lastLocation?.latitude ?? 0,
                            _lastLocation?.longitude ?? 0));

                    updateSelectedLocation(sLocation);
                    shouldShowCloseBranches = true;
                    getBranchesAroundSelectedLocation(
                        shouldForceCenter: true);
                  },
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
            InkWell(
                child: Text(branchInfo.phoneNumber ?? "", style: _style()),
                onTap: () => openUrl("tel:${branchInfo.phoneNumber}")),
            SizedBox(height: 11),
            InkWell(
              child: Text(branchInfo.email ?? "", style: _style()),
              onTap: () =>
                  openUrl("mailto:${branchInfo.email}?subject=Moniepoint"),
            ),
            SizedBox(height: 19),
            Divider(
              color: Color(0xff0748AB).withOpacity(0.1),
            ),
            SizedBox(height: 19),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => openUrl("tel:${branchInfo.phoneNumber}"),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
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
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () =>
                        openUrl(
                            "geo:${branchInfo.location
                                ?.latitude}, ${branchInfo.location
                                ?.longitude}"),
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Center(
                        child: Text(
                          "Share Location",
                          style: _style(
                              color: Color(0xFF0361F0),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    },
      backgroundColor: Colors.transparent,
    );
  }

  TextStyle _style({FontWeight fontWeight = FontWeight.normal,
    double fontSize = 13,
    Color color = const Color(0xFF1A0C2F)}) {
    return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    _mapController?.animateCamera(u);
    // LatLngBounds l1 = await c.getVisibleRegion();
    // LatLngBounds l2 = await c.getVisibleRegion();
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
            onMapCreated: (GoogleMapController controller) async {
              _mapController = controller;
              var _isServiceEnabled = await location.serviceEnabled();

              if (!_isServiceEnabled) {
                _isServiceEnabled = await location.requestService();
                if (!_isServiceEnabled) {
                  Navigator.pop(context);
                }
              }


              final isGranted = await _checkLocationPermission();
              if (isGranted) {
                _lastLocation = await _fetchLastLocation();

                final sLocation = SelectedLocation(
                    location: LatLng(_lastLocation?.latitude ?? 0,
                        _lastLocation?.longitude ?? 0));
                updateSelectedLocation(sLocation);

                getBranchesAroundSelectedLocation(shouldForceCenter: true);
              } else {
                Navigator.pop(context);
              }
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
              child: IgnorePointer(
                ignoring: true,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff0020500).withOpacity(0.4),
                            Color(0xff00003D9).withOpacity(0.0)
                          ],
                          stops: [0.0, 1.0],
                          begin: Alignment.topCenter, end: Alignment.bottomCenter
                      )
                  ),
                ),
              )
          ),
          Positioned(
            top: 40,
            left: 20,
            child: InkWell(
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, Routes.LOGIN, (Route<dynamic> route) => false),
              child: Container(
                height: 38,
                width: 38,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xff21FFFFFF).withOpacity(0.13),
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                    child: SvgPicture.asset(
                      "res/drawables/ic_back.svg", height: 18,
                      width: 18,
                      color: Colors.white,
                    )
                ),
              ),
            ),
          ),
          Positioned(
            top: 86,
            right: 20,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 2,
                    )
                  ]),
              child: Styles.appEditText(
                readOnly: true,
                // padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                drawablePadding: EdgeInsets.symmetric(horizontal: 15),
                borderColor: Colors.transparent,
                focusedBorderColor: Colors.transparent,

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
          ),
          if (shouldShowCloseBranches)
            DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.35,
                maxChildSize: 0.68,
                builder: (ctx, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      border: Border.all(
                          width: 1.0,
                          color: Color(0xff063A4F0D).withOpacity(0.05)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 30,
                          offset: Offset(0, -12),
                          color: Color(0xFF17063A4F).withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ListView(
                          controller: scrollController,
                          padding: EdgeInsets.only(top: 74),
                          shrinkWrap: true,
                          children: [
                            Column(
                              children: closeBranches
                                  .asMap()
                                  .map((idx, val) {
                                final divider = Container(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      // SizedBox(height: 15),
                                      Divider(height: 1),
                                    ],
                                  ),
                                );

                                final branchListitem = BranchListItem(
                                    closeBranches[idx],
                                    idx,
                                        (item, itemIndex) async {
                                      final branchInfo = closeBranches[idx];
                                      final location = branchInfo.location;

                                      if (location != null &&
                                          location.latitude != null &&
                                          location.longitude != null) {
                                        final branchLocation = LatLng(
                                            double.parse(
                                                location.latitude ?? "0"),
                                            double.parse(
                                                location.longitude ?? "0"));

                                        final sLocation = SelectedLocation(
                                          location: LatLng(
                                              branchLocation.latitude,
                                              branchLocation.longitude),
                                          branchInfo: branchInfo,
                                        );

                                        updateSelectedLocation(sLocation);
                                        shouldShowCloseBranches = false;
                                        getBranchesAroundSelectedLocation();
                                        await moveCameraToBranchPosition(
                                            branchInfo);
                                        showBranchInfoBottomSheet(
                                            closeBranches[idx]);
                                      }
                                    });

                                Widget item = branchListitem;

                                if (idx > 0 && idx < closeBranches.length - 1) {
                                  item = Column(children: [item, divider],);
                                }
                                return MapEntry(idx, item);
                              }).values.toList(),
                            ),
                          ],
                        ),
                        IgnorePointer(
                          ignoring: true,
                          child: Container(
                            width: double.infinity,
                            height: 82,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        IgnorePointer(
                          ignoring: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 23,),
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
                              SizedBox(height: 24),
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  "BRANCHES CLOSE TO YOU",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.textColorBlack,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],),
                        ),
                      ],
                    ),
                  );
                })
        ],
      ),
    );
  }
}
