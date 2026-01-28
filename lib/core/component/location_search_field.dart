import 'dart:convert';

import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationSearchField extends StatefulWidget {
  final String hintText;
  final String? initialValue;
  final Function(LatLng position, String address) onLocationSelected;
  final Function(String)? onSearchChanged;
  final bool enabled;

  const LocationSearchField({
    Key? key,
    this.hintText = 'Search for a location...',
    this.initialValue,
    required this.onLocationSelected,
    this.onSearchChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<PlacePrediction> _predictions = [];
  bool _showPredictions = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _searchController.text = widget.initialValue!;
    }
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _showPredictions = _focusNode.hasFocus && _predictions.isNotEmpty;
    });
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
        _showPredictions = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          '${Constants.urlGoogleMapPlace}?input=$query&key=${Constants.kGoogleMap}&types=geocode&language=en',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          setState(() {
            _predictions = (data['predictions'] as List).map((json) => PlacePrediction.fromJson(json)).toList();
            _showPredictions = _focusNode.hasFocus;
          });
        }
      }
    } catch (e) {
      debugPrint('Error searching places: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${Constants.urlGoogleMapLocation}?place_id=$placeId&key=${Constants.kGoogleMap}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final result = data['result'];
          final location = result['geometry']['location'];
          final address = result['formatted_address'];

          final latLng = LatLng(
            location['lat'].toDouble(),
            location['lng'].toDouble(),
          );

          _searchController.text = address;
          setState(() {
            _showPredictions = false;
          });

          widget.onLocationSelected(latLng, address);
        }
      }
    } catch (e) {
      debugPrint('Error getting place details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          validator: (e){},
          outPadding: EdgeInsets.zero,
          controller: _searchController,
          hintText: widget.hintText,
          prefixIcon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: LoadingWidget(),
                  ),
                )
              : const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _predictions = [];
                      _showPredictions = false;
                    });
                  },
                )
              : null,
          onChange: (value) {
            widget.onSearchChanged?.call(value);
            if (value.length >= 2) {
              _searchPlaces(value);
            } else {
              setState(() {
                _predictions = [];
                _showPredictions = false;
              });
            }
          },
          focusNode: _focusNode,
          enable: widget.enabled,
        ),
        if (_showPredictions && _predictions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _predictions.length > 5 ? 5 : _predictions.length,
              itemBuilder: (context, index) {
                final prediction = _predictions[index];
                return ListTile(
                  leading: const Icon(Icons.location_on, color: AppColors.primaryColor),
                  title: Text(
                    prediction.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    _getPlaceDetails(prediction.placeId);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class PlacePrediction {
  final String description;
  final String placeId;

  PlacePrediction({
    required this.description,
    required this.placeId,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      description: json['description'] ?? '',
      placeId: json['place_id'] ?? '',
    );
  }
}
