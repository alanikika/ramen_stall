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
              return GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: provider.getCurrentPosition,
                  zoom: 4,
                ),
                onMapCreated: (GoogleMapController controller) {
                  // _mapController = controller;
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: provider.getCurrentPosition,
                        zoom: 10,
                      ),
                    ),
                  );
                },
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                onLongPress: (position) {},
                onTap: (position) {},
                // markers: state.markers,
              );
            },
          ),
        ),
      ),
    );
  }
  /*@override
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
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: const LatLng(0, 0),
              zoom: 2,
            ),
            markers: _markers.values.toSet(),
          ),
        ),
      ),
    );
  }

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }*/

}
