import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_import;
import 'package:permission_handler/permission_handler.dart';
import 'package:rova_star/core/network/local/cache.dart';
import 'package:rova_star/core/services/googleMap/utils/utils_google_map.dart';
import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/utils/constants.dart';
import 'package:rova_star/core/utils/extensions.dart';
import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/navigation/view/manager/homeBloc/cubit.dart';

class GoogleMapWithoutScaffold extends StatefulWidget {
  final double? height;
  final bool? locationName;
  final bool? detectLocationName;

  const GoogleMapWithoutScaffold({super.key, this.height, this.locationName, this.detectLocationName});

  @override
  State<GoogleMapWithoutScaffold> createState() => _GoogleMapWithoutScaffoldState();
}

class _GoogleMapWithoutScaffoldState extends State<GoogleMapWithoutScaffold> {
  @override
  void initState() {
    requestLocation();
    // _getLocation();
    //UtilsGoogleMap.addUpdateMyMarker(latLng: Constants.locationCache);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GoogleMapWithoutScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  // Future<void> _moveCameraToMyLocation() async {
  //   final currentLocation = await getCurrentLocation();
  //   final cameraUpdate = CameraUpdate.newLatLngZoom(
  //     currentLocation,
  //     11.0, // adjust zoom level as needed
  //   );
  //   _markers[0] = Marker(
  //     markerId: const MarkerId('myMarker'),
  //     position: LatLng(currentLocation.latitude, currentLocation.longitude),
  //   );
  //
  //   final GoogleMapController googleMapController = await _controller.future;
  //   googleMapController.animateCamera(cameraUpdate);
  //   _getLocation();
  //   setState(() {});
  // }

  Future<void> _getLocation({LatLng? currentLocation}) async {
    final location = location_import.Location();
    List<Placemark>? placeMarks;
    debugPrint('currentLocation $currentLocation');
    try {
      if (currentLocation == null) {
        await location.getLocation().then((value) {
          currentLocation = LatLng(value.latitude!, value.longitude!);
        });
      }

      UtilsGoogleMap.addUpdateMyMarker(
        latLng: LatLng(
          currentLocation!.latitude,
          currentLocation!.longitude,
        ),
      );
      placeMarks = await placemarkFromCoordinates(
        currentLocation!.latitude,
        currentLocation!.longitude,
      );
      locationCacheValue = '${placeMarks[0].street}, ${placeMarks[0].locality}, ${placeMarks[0].country}';
      userCache?.put(locationCacheKey, locationCacheValue);
      // AddressCubit.of(context).selectDistanceForBranches(
      //   argument: LatLng(
      //     currentLocation!.latitude,
      //     currentLocation!.longitude,
      //   ),
      //   context: context,
      // );
      HomeCubit.of(context).changeState();
      Constants.locationCache = LatLng(
        currentLocation!.latitude,
        currentLocation!.longitude,
      );
      //  AddressCubit.of(context).setAddress(address: locationCacheValue ?? '');

      setState(() {});
      log('updatingMarker');
      //widget.cubit.changeToCustomer();
      // await AddressCubit.of(context).controllerGoogleMap?.animateCamera(
      //       CameraUpdate.newLatLng(
      //         LatLng(
      //           currentLocation!.latitude,
      //           currentLocation!.longitude,
      //         ),
      //       ),
      //     );
      debugPrint('currentLocation $locationCacheValue');
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void requestLocation() async {
    final status = await Permission.location.request();
    if (status.isDenied) Utils.showToast(title: 'You must allow us to locate you', state: UtilState.error);
  }

  // final List<Marker> _markers = [
  //   Marker(
  //     markerId: const MarkerId('myMarker'),
  //     position: Constants.locationCache,
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height != null ? context.screenHeight * (widget.height ?? .36) : null,
      decoration: BoxDecoration(border: Border.all(color: AppColors.grey)),
      /*child: BlocProvider.value(
        value: BlocProvider.of<AddressCubit>(context),
        child: BlocConsumer<AddressCubit, AddressState>(
          listener: (context, state) {
            if (state is AddressUpdateMarkerState) _getLocation(currentLocation: state.latLng);
          },
          builder: (context, state) {
            return GoogleMap(
              mapType: MapType.terrain,
              markers: Set.from(ConstantsGoogleMap.markers.toSet()),
              compassEnabled: false,
              trafficEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: Constants.locationCache,
                zoom: 16,
              ),
              style: Constants.mapStyleString,
              onTap: (argument) async {
                animationDialogLoading(context);
                await _getLocation(currentLocation: argument);
                closeDialog(context);
                setState(() {});
              },
              // onCameraMove: (position) async {
              //   await _getLocation(currentLocation: LatLng(position.target.latitude, position.target.longitude));
              //
              //   setState(() {});
              // },
              onMapCreated: (GoogleMapController controller) {
                log('created map');
                if (!AddressCubit.of(context).controller.isCompleted) {
                  AddressCubit.of(context).controller.complete(controller);
                }
                AddressCubit.of(context).controllerGoogleMap = controller;
                //  _getLocation();
                setState(() {});
              },
            );
          },
        ),
      ),*/
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
