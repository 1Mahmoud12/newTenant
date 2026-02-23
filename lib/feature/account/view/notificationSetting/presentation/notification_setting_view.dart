import 'package:rova_star/core/component/custom_app_bar.dart';
import 'package:rova_star/core/component/loadsErros/loading_widget.dart';
import 'package:rova_star/core/utils/constants_models.dart';
import 'package:rova_star/core/utils/utils.dart';
import 'package:rova_star/feature/account/view/notificationSetting/presentation/manager/notiSetting/cubit/notification_setting_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsSettingsView extends StatefulWidget {
  const NotificationsSettingsView({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsView> createState() => _NotificationsSettingsViewState();
}

class _NotificationsSettingsViewState extends State<NotificationsSettingsView> {
  final NotificationSettingCubit _cubit = NotificationSettingCubit();

  @override
  void initState() {
    super.initState();
    _cubit.getNotificationSetting(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Notification'.tr()),
      body: BlocProvider(
        create: (context) => _cubit,
        child: BlocConsumer<NotificationSettingCubit, NotificationSettingState>(
          listener: (context, state) {
            if (state is NotificationSettingError) {
              Utils.showToast(title: state.e, state: UtilState.error);
            }
          },
          builder: (context, state) {
            if (state is NotificationSettingLoading) {
              return const Center(child: LoadingWidget());
            } else if (state is NotificationSettingSuccess || ConstantsModels.generalNotificationModel?.data != null) {
              return _buildSettingsList();
            } else if (state is NotificationSettingError) {
              return Center(child: Text('Error: ${state.e}'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildSettingsList() {
    final data = ConstantsModels.generalNotificationModel?.data;

    if (data == null) {
      return  Center(child: Text('No notification settings available'.tr()));
    }

    return ListView(
      children: [
        _buildSwitchTile(
          title: 'Two Factor Authentication'.tr(),
          value: data.twoFactorAuth ?? false,
          onChanged: (value) => _updateSetting('two_factor_auth', value),
        ),
        const Divider(),
        _buildSwitchTile(
          title: 'Push Notifications'.tr(),
          value: data.pushNotifications ?? false,
          onChanged: (value) => _updateSetting('push_notifications', value),
        ),
        const Divider(),
        _buildSwitchTile(
          title: 'Desktop Notifications'.tr(),
          value: data.desktopNotifications ?? false,
          onChanged: (value) => _updateSetting('desktop_notifications', value),
        ),
        const Divider(),
        _buildSwitchTile(
          title: 'Email Notifications'.tr(),
          value: data.emailNotifications ?? false,
          onChanged: (value) => _updateSetting('email_notifications', value),
        ),
        //  const Divider(),
        // _buildLanguageSection(),
        // const Divider(),
        // _buildAppearanceSection(),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      trailing: SizedBox(
        height: 45,
        child: FittedBox(
          child: Switch(
            value: value,
            onChanged: onChanged,
            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
            activeTrackColor: Colors.black,
            activeColor: Colors.white,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  void _updateSetting(String key, bool value) {
    // Update the local model
    final data = ConstantsModels.generalNotificationModel?.data;
    if (data == null) return;

    switch (key) {
      case 'two_factor_auth':
        data.twoFactorAuth = value;
        _cubit.updateNotificationSetting(context: context, twoFactorAuth: value);
        break;
      case 'push_notifications':
        data.pushNotifications = value;
        _cubit.updateNotificationSetting(context: context, pushNotifications: value);

        break;
      case 'desktop_notifications':
        data.desktopNotifications = value;
        _cubit.updateNotificationSetting(context: context, desktopNotifications: value);

        break;
      case 'email_notifications':
        data.emailNotifications = value;
        _cubit.updateNotificationSetting(context: context, emailNotifications: value);

        break;
    }

    // Update UI
    setState(() {});

    // Here you would typically call an API to save the settings
    // For example: _cubit.updateNotificationSetting(key: key, value: value);
  }
}
