import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stall_noodle/base/base_provider.dart';

class DetailProvider extends BaseProvider {

  LatLng _currentPosition;

  performGetCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      _currentPosition = LatLng(position.latitude, position.longitude);
    } catch (e) {
      print(e.toString());
    }
  }

  LatLng get getCurrentPosition => _currentPosition;
}