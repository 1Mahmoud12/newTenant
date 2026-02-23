import 'package:rova_star/core/component/buttons/custom_text_button.dart';
import 'package:rova_star/core/component/custom_app_bar.dart';
import 'package:rova_star/core/component/custom_drop_down_menu.dart';
import 'package:rova_star/core/component/fields/custom_text_form_field.dart';
import 'package:rova_star/core/component/location_picker_map.dart';
import 'package:rova_star/core/component/phone_number_field.dart';
import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/utils/constant_gaping.dart';
import 'package:rova_star/core/utils/extensions.dart';
import 'package:rova_star/feature/address/data/models/address_model.dart';
import 'package:rova_star/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../manager/addAddress/cubit/add_address_cubit.dart';
import '../manager/address/cubit/address_cubit.dart';
import '../manager/city/cubit/city_cubit.dart';
import '../manager/state/cubit/state_cubit.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({
    super.key,
    required this.addressCubit,
    this.isUpdate = false,
    this.addressDataModel,
  });
  final AddressCubit addressCubit;
  final bool isUpdate;
  final AddressDataModel? addressDataModel;
  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  List<DropDownModel> addressList = [
    DropDownModel(name: 'Asyut', value: 0),
    DropDownModel(name: 'California', value: 1),
  ];
  final AddAddressCubit addAddressCubit = AddAddressCubit();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    addAddressCubit.close();
    super.dispose();
  }

  // Location tracking variables
  String _selectedAddress = '';
  bool _showMap = false;
  bool restrictAddLocationFirstTimeUpdated = false;
  @override
  void initState() {
    if (widget.isUpdate) {
      logger.d(widget.addressDataModel?.toJson());
      addAddressCubit.nameController.text = widget.addressDataModel?.name ?? 'unKnow address';
      addAddressCubit.addressNicknameController.text = widget.addressDataModel?.address ?? 'unKnow address';
      addAddressCubit.phoneController.text = widget.addressDataModel?.phone ?? 'unKnow phone number';
      addAddressCubit.stateId = widget.addressDataModel?.stateId ?? -1;
      addAddressCubit.stateName.text = widget.addressDataModel?.state ?? '';
      addAddressCubit.city.text = widget.addressDataModel?.city ?? '';
      addAddressCubit.cityId = widget.addressDataModel?.cityId ?? -1;
      addAddressCubit.isDefault = widget.addressDataModel?.isDefault ?? false;
    }
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        restrictAddLocationFirstTimeUpdated = true;
      });
    });
    super.initState();
  }

  StateCubit stateCubit = StateCubit();
  CityCubit cityCubit = CityCubit();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: widget.isUpdate ? 'update_address'.tr() : 'new_address'.tr()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  outPadding: EdgeInsets.zero,
                  controller: addAddressCubit.nameController,
                  hintText: 'enter_address_name'.tr(),
                  maxLines: 1,
                  nameField: '${'address_name'.tr()} *',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'address_name_is_required'.tr();
                    }
                    return null;
                  },
                  hintStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  nameFieldStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                h10,

                // Phone Number Field
                Text(
                  '${'phone_number'.tr()} *',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                h5,
                PhoneNumberField(
                  controller: addAddressCubit.phoneController,
                  outPadding: EdgeInsets.zero,
                ),

                h10,

                // Location Selection Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'select_location'.tr(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    CustomTextButton(
                      isExpanded: false,
                      backgroundColor: AppColors.primaryColor,
                      borderColor: AppColors.transparent,
                      onPress: () {
                        setState(() {
                          _showMap = !_showMap;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            _showMap ? Icons.map : Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _showMap ? 'hide_map'.tr() : 'select_on_map'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                h10,

                // Selected location display
                if (_selectedAddress.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacityNew(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacityNew(0.3),
                      ),
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
                          ),
                        ),
                      ],
                    ),
                  ),

                // Map widget
                h10,
                LocationPickerMap(
                  height: 300,
                  showMap: _showMap,
                  onLocationSelected: (
                    LatLng position,
                    String address, {
                    String? city,
                    String? state,
                  }) {
                    if (restrictAddLocationFirstTimeUpdated) {
                      setState(() {
                        addAddressCubit.selectedLocation = position;
                        _selectedAddress = address;
                      });

                      // Update the address details field with the selected location
                      addAddressCubit.addressNicknameController.text = address;

                      // Update city and state fields if available
                      if (city != null && city.isNotEmpty) {
                        addAddressCubit.city.text = city;
                      }
                      if (state != null && state.isNotEmpty) {
                        addAddressCubit.stateName.text = state;
                      }
                    }
                  },
                  searchHint: 'search_for_your_location'.tr(),
                ),

                h10,

                // Info message about auto-filling
                if (_showMap)
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacityNew(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacityNew(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'city_and_state_will_be_automatically_filled_when_you_select_a_location_on_the_map'.tr(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                CustomTextFormField(
                  outPadding: EdgeInsets.zero,
                  controller: addAddressCubit.stateName,
                  hintText: 'enter_state_name'.tr(),
                  maxLines: 1,
                  nameField: '${'state_name'.tr()} *',
                  fontSizeHintText: 12,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'state_name_is_required'.tr();
                    }
                    return null;
                  },
                  suffixIcon: addAddressCubit.stateName.text.isNotEmpty
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        )
                      : null,
                ),
                h10,
                CustomTextFormField(
                  outPadding: EdgeInsets.zero,
                  controller: addAddressCubit.city,
                  hintText: 'enter_city_name'.tr(),
                  maxLines: 1,
                  nameField: '${'city_name'.tr()} *',
                  fontSizeHintText: 12,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'city_name_is_required'.tr();
                    }
                    return null;
                  },
                  suffixIcon: addAddressCubit.city.text.isNotEmpty
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        )
                      : null,
                ),
                h10,
                CustomTextFormField(
                  outPadding: EdgeInsets.zero,
                  controller: addAddressCubit.addressNicknameController,
                  hintText: 'enter_address_details'.tr(),
                  maxLines: 3,
                  nameField: '${'address_details'.tr()} *',
                  fontSizeHintText: 12,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'address_details_is_required'.tr();
                    }
                    return null;
                  },
                ),
                h10,

                LabeledCheckButton(
                  initialValue: addAddressCubit.isDefault,
                  onChanged: (value) {
                    addAddressCubit.isDefault = value;
                  },
                ),
                h20,
                BlocProvider.value(
                  value: addAddressCubit,
                  child: BlocBuilder<AddAddressCubit, AddAddressState>(
                    builder: (context, state) {
                      return CustomTextButton(
                        state: state is UpdateAddressLoading,
                        loadingColor: Colors.white,
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            if (widget.isUpdate) {
                              addAddressCubit.updateAddress(
                                context: context,
                                addressCubit: widget.addressCubit,
                                addressId: widget.addressDataModel?.id ?? -1,
                              );
                            } else {
                              addAddressCubit.addAddress(
                                context: context,
                                addressCubit: widget.addressCubit,
                              );
                            }
                          }
                        },
                        borderRadius: 8,
                        child: state is AddAddressLoading
                            ? const Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  'Add'.tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TrackOrderItem extends StatelessWidget {
  final String status;
  final String address;
  final bool isCompleted;
  final bool showConnector;

  const TrackOrderItem({
    Key? key,
    required this.status,
    required this.address,
    required this.isCompleted,
    required this.showConnector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status indicator column (dot and connector line)
        SizedBox(
          width: 24,
          child: Column(
            children: [
              // Status dot indicator
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? Colors.black : Colors.white,
                  border: Border.all(
                    color: isCompleted ? Colors.black : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
              ),

              // Connector line
              if (showConnector)
                Container(
                  width: 2,
                  height: 65,
                  color: Colors.grey.shade300,
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Status text info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCompleted ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class LabeledCheckButton extends StatefulWidget {
  final String label;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const LabeledCheckButton({
    Key? key,
    this.label = 'Make this as a default address',
    this.initialValue = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<LabeledCheckButton> createState() => _LabeledCheckButtonState();
}

class _LabeledCheckButtonState extends State<LabeledCheckButton> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Custom checkbox
        GestureDetector(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
              if (widget.onChanged != null) {
                widget.onChanged?.call(_isChecked);
              }
            });
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isChecked ? AppColors.primaryColor : Colors.grey.shade300,
              ),
              color: _isChecked ? AppColors.primaryColor : Colors.white,
            ),
            child: _isChecked
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 8),
        // Label
        Text(
          widget.label.tr(),
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
