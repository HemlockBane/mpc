import 'package:flutter/material.dart' hide Colors;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../colors.dart';

class TransactionLocationView extends Container {

  final LatLng? transactionLocation;
  final String? locationKey;

  TransactionLocationView(this.transactionLocation, this.locationKey);

  @override
  Widget build(BuildContext context) {
    /// Reason why we are using a future builder is to avoid the transition
    /// to the screen looking flaky because of the map initialization
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 130), () => true),
        builder: (m, n) {
          return Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.colorFaded.withOpacity(0.5))
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (n.hasData)
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: transactionLocation != null ? transactionLocation! : LatLng(0, 0),
                      zoom: 10.4,
                    ),
                    zoomControlsEnabled: false,
                    tiltGesturesEnabled: false,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    scrollGesturesEnabled: true,
                    markers: {
                      Marker(
                        markerId: MarkerId(locationKey ?? ""),
                        position: transactionLocation != null ? transactionLocation! : LatLng(0, 0),
                        infoWindow: InfoWindow(title: locationKey),
                      )
                  },
                ): null,
            ),
          );
        }
    );
  }
}