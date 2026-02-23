import 'package:bloc/bloc.dart';
import 'package:rova_star/core/utils/constants_models.dart';
import 'package:rova_star/feature/account/view/notificationSetting/data/dataSource/get_general_noti_setting_data_source.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'notification_setting_state.dart';

class NotificationSettingCubit extends Cubit<NotificationSettingState> {
  NotificationSettingCubit() : super(NotificationSettingInitial());

  Future<void> getNotificationSetting({required BuildContext context}) async {
    emit(NotificationSettingLoading());
    await GetGeneralNotiSettingDataSource.getGeneralNotiSetting().then(
      (value) async {
        value.fold((l) {
          emit(NotificationSettingError(e: l.errMessage));
        }, (r) async {
          //  log('cart items: ${r.data?.length}');
          ConstantsModels.generalNotificationModel = r;
          //  log('Cart items list: ${ConstantsModels.cartItemModel?.data?.length}');

          emit(NotificationSettingSuccess());
        });
      },
    );
  }

  Future<void> updateNotificationSetting({
    required BuildContext context,
    bool? twoFactorAuth,
    String? language,
    bool? pushNotifications,
    bool? desktopNotifications,
    bool? emailNotifications,
  }) async {
    await GetGeneralNotiSettingDataSource.updateNotificationSetting(
      data: {
        if (language != null) 'language': language,
        if (twoFactorAuth != null) 'two_factor_auth': twoFactorAuth,
        if (pushNotifications != null) 'push_notifications': pushNotifications,
        if (desktopNotifications != null) 'desktop_notifications': desktopNotifications,
        if (emailNotifications != null) 'email_notifications': emailNotifications,
        '_method': 'put',
      },
    ).then(
      (value) async {
        value.fold((l) {}, (r) async {});
      },
    );
  }
}
