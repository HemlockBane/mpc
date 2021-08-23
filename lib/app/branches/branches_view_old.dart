import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' hide Colors;
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
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class BranchScreenOld extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _BranchScreen();

}

class _BranchScreen extends State<BranchScreenOld> {

  GoogleMapController? _mapController;
  Position? _lastLocation;
  Set<Marker> _displayAbleMarkers = {};
  double currentZoom = 10.4;

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.5244, 3.3792),
    zoom: 10.4,
  );

  @override
  void initState() {
    super.initState();
  }

  void _fetchLastLocation() async {
    final viewModel = Provider.of<BranchViewModel>(context, listen: false);
    _lastLocation = await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);

    if (_lastLocation != null) {
      _lastLocation = await Geolocator.getCurrentPosition();
    }

    viewModel.getAllBranches(
        _lastLocation?.latitude ?? 0,
        _lastLocation?.longitude ?? 0,
        _radiusInMeters(_lastLocation?.longitude ?? 0).toInt()
    ).listen((event) {
      if(event is Success && event.data!.length > 0) {
        _addBranchesAsMarkerToMap(event.data!);
      }
    });
  }

  double _radiusInMeters(double longitude) {
    return 156543.03392 * cos(longitude * pi / 180) / pow(2.0, currentZoom);//2.0.pow((currentZoom).toDouble());
  }

  void _addBranchesAsMarkerToMap(List<BranchInfo> branches) {
    if(branches.isNotEmpty) _displayAbleMarkers.clear();
    List<LatLng?> latLngs =  branches.map((e) {
      if(e.location == null || e.location?.longitude == null || e.location?.latitude == null) return null;
      //let's also add the marker
      _addBranchAsMarker(e);
      return LatLng(double.parse(e.location!.latitude!), double.parse(e.location!.longitude!));
    }).where((element) => element != null).toList();

    if(latLngs.isNotEmpty) {
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
    if(location != null && location.latitude != null && location.longitude != null) {
      final branchPosition = LatLng(
          double.parse(location.latitude ?? "0"),
          double.parse(location.longitude ?? "0")
      );
      _displayAbleMarkers.add(
          Marker(
            markerId: MarkerId(info.id.toString()),
            position: branchPosition,
            infoWindow: InfoWindow(title: info.name),
          )
      );
      return true;
    }
    return false;
  }

  void _checkLocationPermission() async {
    final isPermissionGranted = await Permission.location.request().isGranted;
    if(isPermissionGranted) {
      _fetchLastLocation();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    final movingZoom = cameraPosition.zoom;
    if(currentZoom.floorToDouble() != movingZoom.floorToDouble()) {
      //We are zooming
      currentZoom = movingZoom;
      _fetchLastLocation();
    }
    currentZoom = movingZoom;
  }

  void _onSearch() async {
    final branchInfo = await Navigator.of(context).pushNamed(Routes.BRANCHES_SEARCH);
      if(branchInfo != null && branchInfo is BranchInfo) {
        _displayAbleMarkers.clear();
        if(_addBranchAsMarker(branchInfo)) {
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              _addBranchAsMarker(branchInfo);
            });
          });

          Future.delayed(Duration(milliseconds: 1500), (){
            final branchPosition = LatLng(
                double.parse(branchInfo.location!.latitude ?? "0"),
                double.parse(branchInfo.location!.longitude ?? "0")
            );
            CameraUpdate cUpdate = CameraUpdate.newLatLngZoom(branchPosition, 16);
            _mapController?.animateCamera(cUpdate).then((value) {
              check(cUpdate, _mapController!);
            });
          });
        }
      }
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    _mapController?.animateCamera(u);
    LatLngBounds l1=await c.getVisibleRegion();
    LatLngBounds l2=await c.getVisibleRegion();
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
        if (x1== null || latLng!.latitude > x1) x1 = latLng!.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (y1 == null || latLng.longitude > y1) y1 = latLng.longitude;
        if (y0 == null || latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  void _zoomOut() {
    Future.delayed(Duration(milliseconds: 185), (){
      CameraUpdate mUpdate = CameraUpdate.zoomOut();
      _mapController?.animateCamera(mUpdate);
    });
  }

  void _zoomIn() {
    Future.delayed(Duration(milliseconds: 185), (){
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
              borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
              onTap: () => _zoomIn(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                    '+',
                    style:  TextStyle(color: Colors.primaryColor, fontSize: 20, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          ),
          SizedBox(
            width: 36,
            child: Divider(height: 1, color: Colors.colorFaded.withOpacity(0.5), thickness: 1,)
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
              onTap: () => _zoomOut(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                    '-',
                    style:  TextStyle(color: Colors.primaryColor, fontSize: 22, fontWeight: FontWeight.bold)
                ),
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
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller)  {
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
              left: 16,
              top: 24,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.primaryColor.withOpacity(0.05),
                              offset: Offset(0, 0),
                              blurRadius: 2
                          )
                        ]
                    ),
                    child: SvgPicture.asset('res/drawables/ic_back_arrow.svg', color: Colors.primaryColor,),
                  ),
                ),
              )
          ),
          Positioned(
              top: 88,
              right: 16,
              left: 16,
              child: Styles.appEditText(
                  readOnly: true,
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  drawablePadding: EdgeInsets.only(left: 24, right: 16),
                  value: 'Search by location',
                  hint: 'Search by location',
                  fontWeight: FontWeight.w600,
                  animateHint: false,
                  textColor: Colors.grey,
                  fontSize: 12,
                  startIcon: Icon(CustomFont.search, color: Colors.colorFaded, size: 20),
                  onClick: _onSearch
              )
          ),
          Positioned(
            right: 24,
            bottom: 42,
            child: zoomButtonContainer(),
          )
        ],
      ),
    );
  }

}