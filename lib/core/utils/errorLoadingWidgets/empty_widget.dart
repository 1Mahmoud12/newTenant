import 'package:rova_star/core/utils/app_images.dart';
import 'package:rova_star/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum EmptyImages {
  noOrders,
  noAnnouncements,
  appClosed,
  noInternetConnection,
  actionBlocked,
  emptyWallet,
  newUpdates,
  anErrorOccurred,
  noMessagesInbox,
  noNotificationYet,
  noCartItems,
  noSearchResult,
  noSavedItem,
  
}

class EmptyWidget extends StatelessWidget {
  final String? data;
  final String? subData;
  final EmptyImages? emptyImage; // Make this nullable

  const EmptyWidget({super.key, this.data, this.emptyImage, this.subData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: context.screenHeight * .12),
                // Switch based on the enum value, with a fallback if it's null
                switch (emptyImage ?? EmptyImages.noOrders) {
                  // Fallback to noOrders if null
                  EmptyImages.noOrders => Image.asset(AppImages.noOrdersIc),
                  EmptyImages.noAnnouncements => Image.asset(AppImages.noAnnouncements),
                  EmptyImages.appClosed => Image.asset(AppImages.appClosed),
                  EmptyImages.noInternetConnection => Image.asset(AppImages.noInternetConnection),
                  EmptyImages.actionBlocked => Image.asset(AppImages.actionBlocked),
                  EmptyImages.emptyWallet => Image.asset(AppImages.emptyWallet),
                  EmptyImages.newUpdates => Image.asset(AppImages.newUpdates),
                  EmptyImages.anErrorOccurred => Image.asset(AppImages.anErrorOccurred),
                  EmptyImages.noMessagesInbox => Image.asset(AppImages.noMessagesInbox),
                  EmptyImages.noNotificationYet => Image.asset(AppImages.emptyNotification),
                  EmptyImages.noCartItems => Image.asset(AppImages.noCartItem),
                  EmptyImages.noSearchResult => Image.asset(AppImages.noSearchResult),
                  EmptyImages.noSavedItem => Image.asset(AppImages.noSavedItem),
                },
                const SizedBox(height: 20),
                Text(
                  (data ?? 'no_Data,_sorry').tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                if (subData != null) const SizedBox(height: 8),
                if (subData != null)
                  Text(
                    subData!.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
