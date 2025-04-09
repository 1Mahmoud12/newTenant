import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mamlaka/core/component/buttons/custom_text_button.dart';
import 'package:mamlaka/core/utils/constants.dart';
import 'package:mamlaka/core/utils/custom_show_toast.dart';
import 'package:mamlaka/core/utils/errorLoadingWidgets/empty_widget.dart';
import 'package:mamlaka/core/utils/extensions.dart';

class StopInternetWidget extends StatelessWidget {
  const StopInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: context.screenHeight * .15),
            child: EmptyWidget(
              emptyImage: EmptyImages.noInternetConnection,
              data: 'no_internet_connection'.tr(),
              subData: 'seems_like_your_internet_connection_is_lost,_please_check_on_your_connection'.tr(),
            ),
          ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: CustomTextButton(
              padding: const EdgeInsets.symmetric(vertical: 12),
              onPress: () {
                if (!Constants.noInternet) {
                  Navigator.pop(context);
                } else {
                  customShowToast(context, 'no_internet_connection'.tr(), showToastStatus: ShowToastStatus.error);
                }
              },
              childText: 'check_internet'.tr(),
            ),
          ),
        ],
      ),
    );
  }
}
