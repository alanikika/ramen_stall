import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stall_noodle/base/base_provider.dart';

class DetailProvider extends BaseProvider {
  LatLng _currentPosition;
  Set<Marker> _markers;

  performGetCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      _currentPosition = LatLng(position.latitude, position.longitude);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  LatLng get getCurrentPosition => _currentPosition;

  changeLocation(LatLng position) async {
    _markers = {};
    if (_markers != null) {
      _markers.clear();
    }

    final coordinate = Coordinates(position.latitude, position.longitude);
    final address =
        await Geocoder.local.findAddressesFromCoordinates(coordinate);
    debugPrint("address: ${address.first.addressLine}");

    _markers.add(
      Marker(
        markerId: MarkerId("xxx"),
        position: position,
        infoWindow: InfoWindow(
          title: address.first.addressLine,
        ),
        visible: true,
      ),
    );

    notifyListeners();
  }

  Set<Marker> get getMarker => _markers;

  setDefault() {
    _currentPosition = null;
    _markers = null;
  }
}
