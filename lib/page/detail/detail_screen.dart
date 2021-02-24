import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stall_noodle/base/base_state.dart';
import 'package:stall_noodle/common/strings.dart';
import 'package:stall_noodle/page/detail/detail_provider.dart';
import 'package:stall_noodle/widget/custom_app_bar.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final int id;

  const DetailScreen({this.id});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends BaseState<DetailScreen> {
  DetailProvider _detailProvider;

  @override
  void initState() {
    _detailProvider = Provider.of<DetailProvider>(context, listen: false);
    _detailProvider.listener = this;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _detailProvider.performGetCurrentLocation();
      // _checkPermissionAndService();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backFlag: true,
        title: Strings.ramenStallTracker,
      ),
      body: SafeArea(
        left: false,
        right: false,
        child: Container(
          child: Consumer<DetailProvider>(
            builder: (context, provider, child) {
              return provider.getCurrentPosition != null ? GoogleMap(
                zoomGesturesEnabled: true,
                tiltGesturesEnabled: false,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: provider.getCurrentPosition,
                  zoom: 8,
                ),
                onMapCreated: (GoogleMapController controller) {
                  // _mapController = controller;
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: provider.getCurrentPosition,
                        zoom: 14,
                      ),
                    ),
                  );
                },
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                onLongPress: (position) {},
                onTap: (position) {
                  _detailProvider.changeLocation(position);
                },
                markers: provider.getMarker,
              ) : Container();
            },
          ),
        ),
      ),
    );
  }

  /*_checkPermissionAndService() async {
    bool _serviceEnabled;
    LocationPermission _permission;

    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission != LocationPermission.whileInUse &&
          _permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $_permission).');
      }
    }
  }*/

  @override
  void dispose() {
    _detailProvider.setDefault();
    super.dispose();
  }
}
