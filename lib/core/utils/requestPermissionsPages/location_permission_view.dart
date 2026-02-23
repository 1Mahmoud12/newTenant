import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rova_star/core/component/buttons/custom_text_button.dart';
import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/utils/app_images.dart';

class LocationPermissionView extends StatelessWidget {
  const LocationPermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.notificationPermission),
            const SizedBox(
              height: 36,
            ),
            Text(
              'what_is_your_location_?'.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'to_find_nearby_service_provider.'.tr(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.cSecondaryBlack),
            ),
            const SizedBox(
              height: 36,
            ),
            CustomTextButton(
              onPress: () {
                // AddressCubit.of(context).floorController.clear();
                // AddressCubit.of(context).buildingController.clear();
                // AddressCubit.of(context).addressNameController.clear();
                // AddressCubit.of(context).detailsAddressController.clear();
                // AddressCubit.of(context).extraNotesControllerController.clear();
                // AddressCubit.of(context).branchId = null;
                // AddressCubit.of(context).districtId = null;
                // AddressCubit.of(context).setImageBuilding(image: File(''));
                // AddressCubit.of(context).setImageLocation(image: Uint8List(0), reset: true);
                // context.navigateToPage(const AddressView());
              },
              childText: 'enter_location'.tr(),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
