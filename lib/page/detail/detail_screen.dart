import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stall_noodle/base/base_state.dart';
import 'package:stall_noodle/common/custom_colors.dart';
import 'package:stall_noodle/common/dimens.dart';
import 'package:stall_noodle/common/strings.dart';
import 'package:stall_noodle/common/styles.dart';
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
  GoogleMapController _mapController;

  @override
  void initState() {
    _detailProvider = Provider.of<DetailProvider>(context, listen: false);
    _detailProvider.listener = this;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _detailProvider.performGetCurrentLocation(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: (){},
      //   label: Text('My Location'),
      //   icon: Icon(Icons.location_on),
      // ),
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
              return provider.getUserPosition != null
                  ? _buildMap()
                  : Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    if (!_detailProvider.init) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _detailProvider.getMarkerPosition,
            zoom: 18,
          ),
        ),
      );
    }
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: _detailProvider.getUserPosition,
            zoom: 8,
          ),
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: _detailProvider.getMarkerPosition ??
                      _detailProvider.getUserPosition,
                  zoom: 18,
                ),
              ),
            );
          },
          myLocationEnabled: true,
          onTap: (position) {
            _detailProvider.changeLocation(
              position: position,
              ramenId: widget.id,
            );
          },
          markers: _detailProvider.getMarker,
        ),
        Positioned(
          top: 15.0,
          right: 64.0,
          left: 16.0,
          child: InkWell(
            onTap: () async {
              await _detailProvider.searchLocation(context);
            },
            child: Container(
              height: Dimens.standard_36,
              padding: EdgeInsets.symmetric(horizontal: Dimens.standard_16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(Dimens.standard_4),
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.black000000.withOpacity(.2),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _detailProvider.getSearch ?? Strings.searchLocation,
                  style: Style.ibmPleXSansRegular.copyWith(
                    color: CustomColors.neutral20E3033.withOpacity(.8),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _detailProvider.setDefault();
    super.dispose();
  }
}
