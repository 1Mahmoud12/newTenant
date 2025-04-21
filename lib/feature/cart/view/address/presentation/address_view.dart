import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/cart/view/address/presentation/add_address_view.dart';
import 'package:dobzz_seller/feature/cart/view/address/presentation/manager/address/cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressView extends StatefulWidget {
  const AddressView({super.key});

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  int selectedAddressIndex = 0;
  bool hasAddresses = false;

  AddressCubit addressCubit = AddressCubit();
  @override
  void initState() {
    addressCubit.getAddress(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Address'),
      persistentFooterButtons: [
        BlocProvider.value(
          value: addressCubit,
          child: BlocBuilder<AddressCubit, AddressState>(
            builder: (context, state) {
              // Only show Apply button if there are addresses
              if (state is AddressSuccess && (ConstantsModels.addressModel?.data?.isNotEmpty ?? false)) {
                return CustomTextButton(
                  borderRadius: 8,
                  onPress: () {},
                  childText: 'Apply',
                );
              } else {
                // Show Add Address button instead when no addresses
                return CustomTextButton(
                  borderRadius: 8,
                  onPress: () => context.navigateToPage(const AddAddressView()),
                  childText: 'Add Address',
                );
              }
            },
          ),
        ),
      ],
      body: BlocProvider.value(
        value: addressCubit,
        child: BlocBuilder<AddressCubit, AddressState>(
          builder: (context, state) {
            if (state is AddressLoading) {
              return const Center(child: LoadingWidget());
            }
            if (state is AddressError) {
              return Center(
                child: Text(
                  state.e,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.red,
                  ),
                ),
              );
            }
            if (state is AddressSuccess) {
              // Check if addresses are empty
              if (ConstantsModels.addressModel?.data == null || ConstantsModels.addressModel!.data!.isEmpty) {
                return _buildEmptyAddressState();
              }

              // Show address list if not empty
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saved Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: ConstantsModels.addressModel?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final address = ConstantsModels.addressModel?.data![index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: RadioListTile(
                              value: index,
                              groupValue: selectedAddressIndex,
                              onChanged: (value) {
                                setState(() {
                                  selectedAddressIndex = value!;
                                });
                              },
                              fillColor: const WidgetStatePropertyAll(AppColors.primaryColor),
                              activeColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    address?.name ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  if (address?.isDefault ?? false)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        address?.isDefault ?? false ? 'Default' : '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        '${address?.country ?? ''} - ${address?.state ?? ''} - ${address?.city ?? ''} - ${address?.pinCode ?? ''}',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildAddAddressButton(),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Method to build the empty state widget
  Widget _buildEmptyAddressState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 80.sp,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No addresses saved yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please add a delivery address to continue',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            _buildAddAddressButton(),
          ],
        ),
      ),
    );
  }

  // Method for the add address button to avoid duplication
  Widget _buildAddAddressButton() {
    return InkWell(
      onTap: () => context.navigateToPage(const AddAddressView()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add),
              const SizedBox(width: 8),
              Text(
                'Add New Address',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
