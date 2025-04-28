import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/account/view/notificationSetting/presentation/manager/notiSetting/cubit/notification_setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      appBar: customAppBar(context: context, title: 'Notification'),
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
      return const Center(child: Text('No notification settings available'));
    }

    return ListView(
      children: [
        _buildSwitchTile(
          title: 'Two Factor Authentication',
          value: data.twoFactorAuth ?? false,
          onChanged: (value) => _updateSetting('two_factor_auth', value),
        ),
        const Divider(),
        _buildSwitchTile(
          title: 'Push Notifications',
          value: data.pushNotifications ?? false,
          onChanged: (value) => _updateSetting('push_notifications', value),
        ),
        const Divider(),
        _buildSwitchTile(
          title: 'Desktop Notifications',
          value: data.desktopNotifications ?? false,
          onChanged: (value) => _updateSetting('desktop_notifications', value),
        ),
        const Divider(),
        _buildSwitchTile(
          title: 'Email Notifications',
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

  Widget _buildLanguageSection() {
    final data = ConstantsModels.generalNotificationModel?.data;
    final currentLanguage = data?.language ?? 'English';

    return Container(
      color: Colors.white,
      child: ListTile(
        title: const Text(
          'Language',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          currentLanguage,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _showLanguageSelector(currentLanguage),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    final data = ConstantsModels.generalNotificationModel?.data;
    final currentAppearance = data?.appearance ?? 'Light';

    return Container(
      color: Colors.white,
      child: ListTile(
        title: const Text(
          'Appearance',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          currentAppearance,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _showAppearanceSelector(currentAppearance),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
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

  void _showLanguageSelector(String currentLanguage) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Select Language',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              _buildLanguageOption('English', currentLanguage),
              _buildLanguageOption('Arabic', currentLanguage),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language, String currentLanguage) {
    final isSelected = language == currentLanguage;

    return ListTile(
      title: Text(
        language,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.black) : null,
      onTap: () {
        if (ConstantsModels.generalNotificationModel?.data != null) {
          ConstantsModels.generalNotificationModel!.data!.language = language;
          _cubit.updateNotificationSetting(context: context, language: 'language');

          setState(() {});
        }
        Navigator.pop(context);

        // Here you would typically call an API to save the language setting
        // For example: _cubit.updateLanguageSetting(language: language);
      },
    );
  }

  void _showAppearanceSelector(String currentAppearance) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Appearance',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              _buildAppearanceOption('Light', currentAppearance),
              _buildAppearanceOption('Dark', currentAppearance),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppearanceOption(String appearance, String currentAppearance) {
    final isSelected = appearance == currentAppearance;

    return ListTile(
      title: Text(
        appearance,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.black) : null,
      onTap: () {
        if (ConstantsModels.generalNotificationModel?.data != null) {
          ConstantsModels.generalNotificationModel!.data!.appearance = appearance;
          setState(() {});
        }
        Navigator.pop(context);

        // Here you would typically call an API to save the appearance setting
        // For example: _cubit.updateAppearanceSetting(appearance: appearance);
      },
    );
  }
}
