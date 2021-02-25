import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:stall_noodle/base/base_provider.dart';
import 'package:stall_noodle/common/strings.dart';
import 'package:stall_noodle/data/database_helper.dart';
import 'package:stall_noodle/model/ramen_model.dart';

class DetailProvider extends BaseProvider {
  LatLng _userPosition, _cameraOrMarkerPosition;
  Set<Marker> _markers;
  RamenModel _ramenData;
  String _locationName;
  bool init = true;

  static const String _mapsKey = "AIzaSyD0c4OSqLwY6yy7IIWPYx-MKq4YFhfFRu0";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: _mapsKey);

  final dbHelper = DatabaseHelper.instance;

  performGetCurrentLocation(int id) async {
    try {
      _userPosition = await _getUserCurrentLocation();
      _ramenData = await _getRamenStallById(id);

      if (_ramenData.latitude != null && _ramenData.latitude != null) {
        _cameraOrMarkerPosition = LatLng(
          double.parse(_ramenData.latitude),
          double.parse(_ramenData.longitude),
        );

        _markers = {};
        _markers.add(
          _addMarker(
            name: _ramenData.name,
            position: _cameraOrMarkerPosition,
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

  LatLng get getMarkerPosition => _cameraOrMarkerPosition;

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
      _cameraOrMarkerPosition = LatLng(position.latitude, position.longitude);
      init = false;
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

  searchLocation(BuildContext context) async {
    Prediction prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: _mapsKey,
      mode: Mode.overlay, // Mode.overlay
      language: "id",
      onError: onError,
      components: [Component(Component.country, "id")],
    );

    if (prediction != null) {
      PlacesDetailsResponse placeResponse =
          await _places.getDetailsByPlaceId(prediction.placeId);
      final location = placeResponse.result.geometry.location;

      _locationName = placeResponse.result.name;
      _cameraOrMarkerPosition = LatLng(location.lat, location.lng);

      init = false;
      notifyListeners();
    } else {
      listener.onFailure(Strings.failedSearchLocation);
    }
  }

  String get getSearch => _locationName;

  void onError(PlacesAutocompleteResponse response) {
    listener.onFailure(Strings.failedSearchLocation);
  }

  setDefault() {
    _userPosition = null;
    _markers = null;
    _cameraOrMarkerPosition = null;
    _locationName = null;
    init = true;
  }
}
