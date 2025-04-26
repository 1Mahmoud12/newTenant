import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/custom_drop_down_menu.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/cart/view/address/presentation/manager/addAddress/cubit/add_address_cubit.dart';
import 'package:dobzz_seller/feature/cart/view/address/presentation/manager/address/cubit/address_cubit.dart';
import 'package:dobzz_seller/feature/cart/view/address/presentation/manager/city/cubit/city_cubit.dart';
import 'package:dobzz_seller/feature/cart/view/address/presentation/manager/state/cubit/state_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({super.key, required this.addressCubit});
  final AddressCubit addressCubit;
  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  List<DropDownModel> addressList = [
    DropDownModel(name: 'Asyut', value: 0),
    DropDownModel(name: 'California', value: 1),
  ];
  @override
  void initState() {
    super.initState();
    stateCubit.getAddress(context: context);
  }

  StateCubit stateCubit = StateCubit();
  AddAddressCubit addAddressCubit = AddAddressCubit();
  CityCubit cityCubit = CityCubit();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'New Address'.tr()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                outPadding: EdgeInsets.zero,
                controller: addAddressCubit.addressNicknameController,
                hintText: 'Enter your address nickname',
                nameField: 'Address Nickname'.tr(),
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
              CustomTextFormField(
                outPadding: EdgeInsets.zero,
                controller: addAddressCubit.phoneController,
                hintText: 'Enter your number'.tr(),
                nameField: 'number'.tr(),
                textInputType: TextInputType.number,
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
              BlocProvider.value(
                value: stateCubit,
                child: BlocBuilder<StateCubit, StateState>(
                  builder: (context, state) {
                    return CustomDropDownMenu(
                      nameField: 'State'.tr(),
                      borderColor: Colors.grey.withOpacity(0.2),
                      selectedItem: DropDownModel(name: 'Choose your state'.tr(), value: 0),
                      items: ConstantsModels.stateModel?.data?.map((e) {
                            return DropDownModel(name: e.name ?? '', value: e.id ?? -1);
                          }).toList() ??
                          [],
                      onChanged: (value) {
                        setState(() {});
                        cityCubit.getAddress(context: context, stateId: addAddressCubit.stateId);
                        addAddressCubit.stateId = value?.value ?? -1;
                      },
                    );
                  },
                ),
              ),
              h10,
              if (addAddressCubit.stateId != -1)
                BlocProvider.value(
                  value: cityCubit,
                  child: BlocBuilder<CityCubit, CityState>(
                    builder: (context, state) {
                      return CustomDropDownMenu(
                        nameField: 'City',
                        borderColor: Colors.grey.withOpacity(0.2),
                        selectedItem: DropDownModel(name: 'Choose your city'.tr(), value: 0),
                        items: ConstantsModels.cityModel?.data?.map((e) {
                              return DropDownModel(name: e.name ?? '', value: e.id ?? -1);
                            }).toList() ??
                            [],
                        onChanged: (value) {
                          addAddressCubit.cityId = value?.value ?? -1;
                        },
                      );
                    },
                  ),
                ),
              h15,
              LabeledCheckButton(
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
                      onPress: () {
                        addAddressCubit.addAddress(context: context, addressCubit: widget.addressCubit);
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
            ],
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
                widget.onChanged!(_isChecked);
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
          widget.label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
