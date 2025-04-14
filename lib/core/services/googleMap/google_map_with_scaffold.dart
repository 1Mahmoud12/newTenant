import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_import;
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/navigation/view/manager/homeBloc/cubit.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleMapWithScaffold extends StatefulWidget {
  final double? height;
  final bool? locationName;
  final bool? detectLocationName;
  final LatLng? customLocation;

  const GoogleMapWithScaffold({super.key, this.height, this.locationName, this.detectLocationName, this.customLocation});

  @override
  State<GoogleMapWithScaffold> createState() => _GoogleMapWithScaffoldState();
}

class _GoogleMapWithScaffoldState extends State<GoogleMapWithScaffold> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  @override
  void initState() {
    requestLocation();
    // _getLocation();
    super.initState();
  }

  Future<void> _moveCameraToMyLocation() async {
    LatLng currentLocation = const LatLng(0, 0);

    if (widget.customLocation != null) {
      currentLocation = widget.customLocation!;
    } else {
      currentLocation = await getCurrentLocation();
    }
    final cameraUpdate = CameraUpdate.newLatLngZoom(
      currentLocation,
      11.0, // adjust zoom level as needed
    );
    _markers[0] = Marker(
      markerId: const MarkerId('myMarker'),
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    final GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(cameraUpdate);
    _getLocation();
    setState(() {});
  }

  Future<void> _getLocation({LatLng? currentLocation}) async {
    final location = location_import.Location();
    List<Placemark>? placeMarks;
    debugPrint('object');
    try {
      if (currentLocation == null) {
        await location.getLocation().then((value) {
          currentLocation = LatLng(value.latitude!, value.longitude!);
        });
      }

      placeMarks = await placemarkFromCoordinates(
        currentLocation!.latitude,
        currentLocation!.longitude,
      );
      locationCacheValue = '${placeMarks[0].street}, ${placeMarks[0].locality}, ${placeMarks[0].country}';
      userCache?.put(locationCacheKey, locationCacheValue);
      HomeCubit.of(context).changeState();
      //widget.cubit.changeToCustomer();

      debugPrint('currentLocation ${placeMarks[0].locality}');
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<LatLng> getCurrentLocation() async {
    final location = await location_import.Location().getLocation();
    debugPrint('(location.toJson() $location');
    return LatLng(location.latitude ?? 0, location.longitude ?? 0);
  }

  void requestLocation() async {
    final status = await Permission.location.request();
    if (status.isDenied) Utils.showToast(title: 'You must allow us to locate you', state: UtilState.error);
  }

  final List<Marker> _markers = [
    Marker(
      markerId: const MarkerId('myMarker'),
      position: Constants.locationCache,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: widget.height != null ? context.screenHeight * (widget.height ?? .36) : null,
        decoration: BoxDecoration(border: Border.all(color: AppColors.grey)),
        child: GoogleMap(
          mapType: MapType.terrain,
          markers: Set.from(_markers),
          style: Constants.mapStyleString,
          initialCameraPosition: CameraPosition(
            target: Constants.locationCache,
            zoom: 11,
          ),
          onTap: (argument) async {
            _markers[0] = Marker(markerId: const MarkerId('myMarker'), position: LatLng(argument.latitude, argument.longitude));
            await _getLocation(currentLocation: argument);
            setState(() {});
          },
          onCameraMove: (position) {
            _markers[0] = Marker(markerId: const MarkerId('myMarker'), position: LatLng(position.target.latitude, position.target.longitude));
            setState(() {});
          },
          onMapCreated: (GoogleMapController controller) {
            //   AddressCubit.of(context).controller.complete(controller);
            _moveCameraToMyLocation();
            setState(() {});
          },
        ),
      ),
    );
  }
}
/*
Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.locationName ?? false)
          Text(
            'Location: ${Constants.locationCache}',
            style: Styles.style14700.copyWith(color: AppColors.black),
          ),
        Container(
          height: widget.height != null ? context.screenHeight * (widget.height ?? .36) : null,
          decoration: BoxDecoration(border: Border.all(color: AppColors.grey)),
          child: GoogleMap(
            mapType: MapType.terrain,
            markers: Set.from(_markers),
            initialCameraPosition: CameraPosition(
              target: Constants.cairoLatLng,
              zoom: 11,
            ),
            onTap: (argument) async {
              _markers[0] = Marker(markerId: const MarkerId('myMarker'), position: LatLng(argument.latitude, argument.longitude));
              await _getLocation(currentLocation: argument);
              setState(() {});
            },
            onCameraMove: (position) {
              _markers[0] = Marker(markerId: const MarkerId('myMarker'), position: LatLng(position.target.latitude, position.target.longitude));
              setState(() {});
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setState(() {});
            },
          ),
        ),
        if (widget.detectLocationName ?? false)
          CustomTextButton(
            backgroundColor: AppColors.primaryColor,
            borderColor: AppColors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.location,
                  colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                ),
                5.ESW(),
                Text(
                  'Detect my location',
                  style: Styles.style16700.copyWith(color: AppColors.white),
                ),
              ],
            ),
            onPress: () => _moveCameraToMyLocation(),
          ),
      ],
    )
 */
