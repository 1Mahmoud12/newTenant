import 'package:dobzz_seller/core/component/confirmation_delete_dailog.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../manager/address/cubit/address_cubit.dart';
import 'add_address_view.dart';
import 'address_item_skeleton.dart';

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
      appBar: customAppBar(context: context, title: 'Addresses'.tr()),
      persistentFooterButtons: [
        Column(
          children: [
            InkWell(
              onTap: () => context.navigateToPage(
                AddAddressView(
                  addressCubit: addressCubit,
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Add New Address'.tr(),
                        style: TextStyle(
                          fontSize: Constants.tablet ? 16 : 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        )

        // BlocProvider.value(
        //   value: addressCubit,
        //   child: BlocBuilder<AddressCubit, AddressState>(
        //     builder: (context, state) {
        //       // Only show Apply button if there are addresses
        //       if (state is AddressSuccess && (ConstantsModels.addressModel?.data?.isNotEmpty ?? false)) {
        //         return CustomTextButton(
        //           borderRadius: 8,
        //           onPress: () {},
        //           childText: 'Apply',
        //         );
        //       } else {
        //         // Show Add Address button instead when no addresses
        //         return CustomTextButton(
        //           borderRadius: 8,
        //           onPress: () => context.navigateToPage(
        //             AddAddressView(
        //               addressCubit: addressCubit,
        //             ),
        //           ),
        //           childText: 'Add Address',
        //         );
        //       }
        //     },
        //   ),
        // ),
      ],
      body: BlocProvider.value(
        value: addressCubit,
        child: BlocBuilder<AddressCubit, AddressState>(
          buildWhen: (previous, current) =>
              current is AddressLoading ||
              current is AddressError ||
              current is AddressSuccess,
          builder: (context, state) {
            if (state is AddressLoading) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'addresses_saved'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Constants.tablet ? 20 : 20.sp,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Skeletonizer(
                        enabled: true,
                        effect: ShimmerEffect(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                        ),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) =>
                              const AddressItemSkeleton(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is AddressError) {
              return Center(
                child: Text(
                  state.e,
                  style: TextStyle(
                    fontSize: Constants.tablet ? 16 : 16.sp,
                    color: Colors.red,
                  ),
                ),
              );
            }
            if (state is AddressSuccess) {
              // Check if addresses are empty
              if (ConstantsModels.addressModel?.data?.data == null ||
                  ConstantsModels.addressModel!.data!.data!.isEmpty) {
                return _buildEmptyAddressState();
              }

              // Show address list if not empty
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'addresses_saved'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Constants.tablet ? 20 : 20.sp,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            ConstantsModels.addressModel?.data?.data?.length ??
                                0,
                        itemBuilder: (context, index) {
                          final address =
                              ConstantsModels.addressModel?.data?.data![index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
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
                                      address?.title ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Constants.tablet ? 16 : 16.sp,
                                      ),
                                    ),
                                    if (address?.defaultAddress == 1) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          address?.defaultAddress == 1
                                              ? 'Default'.tr()
                                              : '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              '${address?.countryName ?? ''} - ${address?.stateName ?? ''} - ${address?.cityName ?? ''} - ${address?.postcode ?? ''}',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      h10,
                                      Row(
                                        children: [
                                          s,
                                          InkWell(
                                            onTap: () {
                                              context.navigateToPage(
                                                AddAddressView(
                                                  addressCubit: addressCubit,
                                                  addressDataModel: address,
                                                  isUpdate: true,
                                                ),
                                              );
                                            },
                                            child: SizedBox(
                                              height: 30,
                                              width: 60,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Edit'.tr(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14.sp,
                                                            color: const Color(
                                                                0xff808080)),
                                                  ),
                                                  SvgPicture.asset(
                                                      AppIcons.edit),
                                                ],
                                              ),
                                            ),
                                          ),
                                          w10,
                                          InkWell(
                                            onTap: () {
                                              ConfirmationDeleteDialog.show(
                                                stateStream:
                                                    addressCubit.stream,
                                                loadingStateCheck: (state) =>
                                                    state
                                                        is DeleteAddressLoading,
                                                context: context,
                                                onConfirm: () async {
                                                  await addressCubit
                                                      .deleteAddress(
                                                          context: context,
                                                          addressId:
                                                              address?.id ??
                                                                  -1);
                                                  Navigator.pop(context);
                                                  await addressCubit.getAddress(
                                                      context: context);
                                                },
                                              );
                                            },
                                            child: SizedBox(
                                              height: 30,
                                              width: 60,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Delete'.tr(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14.sp,
                                                            color: const Color(
                                                                0xffDD5A5D)),
                                                  ),
                                                  SvgPicture.asset(
                                                      AppIcons.deleteIc),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
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
                      // _buildAddAddressButton(),
                    ],
                  ),
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
              size: Constants.tablet ? 80 : 80.sp,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No addresses saved yet'.tr(),
              style: TextStyle(
                fontSize: Constants.tablet ? 18 : 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please add a delivery address to continue'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Constants.tablet ? 16 : 16.sp,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            //   _buildAddAddressButton(),
          ],
        ),
      ),
    );
  }
}
