import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stall_noodle/base/base_provider.dart';
import 'package:stall_noodle/data/database_helper.dart';
import 'package:stall_noodle/model/ramen_model.dart';

class DetailProvider extends BaseProvider {
  LatLng _userPosition, _markerPosition;
  Set<Marker> _markers;
  RamenModel _ramenData;

  final dbHelper = DatabaseHelper.instance;

  performGetCurrentLocation(int id) async {
    try {
      _userPosition = await _getUserCurrentLocation();
      _ramenData = await _getRamenStallById(id);

      if (_ramenData.latitude != null && _ramenData.latitude != null) {
        _markerPosition = LatLng(
          double.parse(_ramenData.latitude),
          double.parse(_ramenData.longitude),
        );

        _markers = {};
        _markers.add(
          _addMarker(
            name: _ramenData.name,
            position: _markerPosition,
            address: _ramenData.address,
          ),
        );
      }

      notifyListeners();
    } catch (e) {
      listener.onFailure("failed to get data");
    }
  }

  Future<LatLng> _getUserCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return LatLng(position.latitude, position.longitude);
  }

  Future<RamenModel> _getRamenStallById(int id) async {
    return await dbHelper.getRamenStallById(id);
  }

  LatLng get getUserPosition => _userPosition;

  LatLng get getMarkerPosition => _markerPosition;

  changeLocation({int ramenId, LatLng position}) async {
    final coordinate = Coordinates(position.latitude, position.longitude);
    final address =
        await Geocoder.local.findAddressesFromCoordinates(coordinate);

    int result = await dbHelper.updateRamenById(
      ramenId: ramenId,
      lat: position.latitude,
      lon: position.longitude,
      newAddress: address.first.addressLine,
    );
    if (result > 0 || result != null) {
      _markers = {};
      if (_markers != null) {
        _markers.clear();
      }

      _markers.add(
        _addMarker(
          name: _ramenData.name,
          position: position,
          address: address.first.addressLine,
        ),
      );
    }
    notifyListeners();
  }

  Set<Marker> get getMarker => _markers;

  Marker _addMarker({String name, LatLng position, String address}) {
    return Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(
        snippet: address,
        title: name,
      ),
      visible: true,
    );
  }

  setDefault() {
    _userPosition = null;
    _markers = null;
    _markerPosition = null;
  }
}
