import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rova_star/core/component/location_search_field.dart';
import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/utils/extensions.dart';
import 'package:rova_star/core/utils/utils.dart';

class LocationPickerMap extends StatefulWidget {
  final double? height;
  final LatLng? initialLocation;
  final Function(
    LatLng position,
    String address, {
    String? city,
    String? state,
  })? onLocationSelected;
  final bool showSearchField;
  final bool showMap;
  final String? searchHint;
  final bool enableTapToSelect;

  const LocationPickerMap({
    Key? key,
    this.height,
    this.initialLocation,
    this.onLocationSelected,
    this.showSearchField = true,
    this.showMap = false,
    this.searchHint = 'Search for a location...',
    this.enableTapToSelect = true,
  }) : super(key: key);

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  LatLng _selectedLocation = const LatLng(31.2001, 29.9187); // Default to Alexandria
  String _selectedAddress = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation!;
      _updateMarker(_selectedLocation);
      _getAddressFromCoordinates(_selectedLocation);
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Get current location using the existing method from GoogleMapWithScaffold
      final location = await _getLocation();
      if (location != null) {
        _selectedLocation = location;
        _updateMarker(_selectedLocation);
        await _getAddressFromCoordinates(_selectedLocation);
        _moveCameraToLocation(_selectedLocation);
      }
    } catch (e) {
      debugPrint('Error getting current location: $e');
      Utils.showToast(
        title: 'unable_to_get_location'.tr(),
        state: UtilState.error,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<LatLng?> _getLocation() async {
    try {
      // This is a simplified version - you might want to use the location package
      // For now, we'll use the default location
      return const LatLng(31.2001, 29.9187);
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  Future<void> _moveCameraToLocation(LatLng location) async {
    if (_controller.isCompleted) {
      final GoogleMapController googleMapController = await _controller.future;
      await googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(location, 15.0),
      );
    }
  }

  void _updateMarker(LatLng location) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: location,
          infoWindow: InfoWindow(
            title: 'selected_location',
            snippet: _selectedAddress.isNotEmpty ? _selectedAddress : 'tap_to_select_location'.tr(),
          ),
        ),
      };
    });
  }

  Future<void> _getAddressFromCoordinates(LatLng location) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks[0];
        setState(() {
          _selectedAddress = '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
        });

        // Update marker info window
        _updateMarker(location);

        // Extract city and state information
        final city = placemark.locality ?? placemark.subLocality ?? '';
        final state = placemark.administrativeArea ?? placemark.subAdministrativeArea ?? '';

        // Notify parent widget with additional location details
        widget.onLocationSelected?.call(location, _selectedAddress, city: city, state: state);
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
    }
  }

  void _onMapTapped(LatLng location) {
    if (widget.enableTapToSelect) {
      setState(() {
        _selectedLocation = location;
      });
      _updateMarker(location);
      _getAddressFromCoordinates(location);
    }
  }

  void _onLocationSelectedFromSearch(LatLng position, String address) {
    setState(() {
      _selectedLocation = position;
      _selectedAddress = address;
    });
    _updateMarker(position);
    _moveCameraToLocation(position);

    // Get detailed address information including city and state
    _getAddressFromCoordinates(position);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showSearchField) ...[
          LocationSearchField(
            hintText: widget.searchHint!,
            onLocationSelected: _onLocationSelectedFromSearch,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 16),
        ],
        if (widget.showMap) ...[
          Container(
            height: widget.height ?? 300,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  GoogleMap(
                    markers: _markers,
                    initialCameraPosition: CameraPosition(
                      target: _selectedLocation,
                      zoom: 15.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onTap: _onMapTapped,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  ),
                  if (_isLoading)
                    Container(
                      color: Colors.white.withOpacityNew(0.7),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: FloatingActionButton.small(
                      onPressed: _getCurrentLocation,
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.my_location,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  if (_selectedAddress.isNotEmpty)
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacityNew(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppColors.primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _selectedAddress,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
