import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stall_noodle/base/base_provider.dart';

class DetailProvider extends BaseProvider {

  LatLng _currentPosition;
  Set<Marker> _markers = {};

  performGetCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      _currentPosition = LatLng(position.latitude, position.longitude);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  LatLng get getCurrentPosition => _currentPosition;

  changeLocation(LatLng position) async {
    if(_markers != null) {
      _markers.clear();
    }

    _markers.add(
      Marker(
        markerId: MarkerId("xxx"),
        position: position,
      )
    );
    notifyListeners();
  }

  Set<Marker> get getMarker => _markers;

  setDefault() {
    _currentPosition = null;
    _markers = null;
  }
}