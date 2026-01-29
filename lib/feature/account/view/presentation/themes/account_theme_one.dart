import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/services/biometrics/biometric_service.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/extensions.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/account/view/helpCenter/presentation/help_center_view.dart';
import 'package:dobzz_seller/feature/account/view/manager/deleteAccount/cubit/delete_account_cubit.dart';
import 'package:dobzz_seller/feature/account/view/myDetalis/presentation/manager/editProfile/cubit/edit_profile_cubit.dart';
import 'package:dobzz_seller/feature/account/view/myDetalis/presentation/my_details_veiw.dart';
import 'package:dobzz_seller/feature/account/view/presentation/language_view.dart';
import 'package:dobzz_seller/feature/favorites/views/manager/wishList/cubit/wish_list_cubit.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_view.dart';
import 'package:dobzz_seller/mainCubit/cubit/main_cubit_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/component/login_dialog.dart';
import '../../../../address/view/presentation/address_view.dart';

class ProfileViewThemeOne extends StatefulWidget {
  const ProfileViewThemeOne({Key? key}) : super(key: key);

  @override
  State<ProfileViewThemeOne> createState() => _ProfileViewThemeOneState();
}

class _ProfileViewThemeOneState extends State<ProfileViewThemeOne> {
  final currentLanguage = 'English';
  DeleteAccountCubit deleteAccountCubit = DeleteAccountCubit();
  EditProfileCubit editProfileCubit = EditProfileCubit();
  final BiometricService _biometricService = BiometricService();
  bool _biometricSupported = false;
  bool _biometricEnabled = false;

  Future<void> _initBiometrics() async {
    final bool supported = await _biometricService.isDeviceSupported();
    final bool canCheck = await _biometricService.canCheckBiometrics();
    final bool enabled = await _biometricService.isBiometricEnabled() && loginCacheValue?.data?.email == loginCache?.get(loginEmailKey);
    if (!mounted) return;
    setState(() {
      _biometricSupported = supported && canCheck;
      _biometricEnabled = enabled;
    });
    print('enable ${await _biometricService.isBiometricEnabled()}. supported $supported. canCheck $canCheck');
  }

  @override
  void initState() {
    _initBiometrics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: BlocBuilder<MainCubitCubit, MainCubitState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              const SliverAppBar(
                toolbarHeight: 0,
                backgroundColor: AppColors.primaryColor,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.light,
                  statusBarColor: AppColors.primaryColor,
                  statusBarBrightness: Brightness.dark,
                ),
              ),
              // Custom App Bar with curved background
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 20, bottom: 30, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Account'.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {

                              context.navigateToPage(
                                MyDetailsView(
                                  editProfileCubit: editProfileCubit,
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacityNew(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Edit Profile'.tr(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Profile info with horizontal layout
                      BlocProvider.value(
                        value: editProfileCubit,
                        child: BlocBuilder<EditProfileCubit, EditProfileState>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: Center(
                                    child: _buildUserInitials(loginCacheValue?.data?.firstName ?? ''),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loginCacheValue?.data?.firstName ?? 'Unknown'.tr(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Menu Categories
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 30, bottom: 10),
                  child: Text(
                    'My Account'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // Account Menu Items
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // _buildMenuItemNew(
                      //   icon: AppIcons.myOrders,
                      //   title: 'My Orders',
                      //   subtitle: 'View your order history',
                      //   onTap: () {
                      //     context.navigateToPage(const MyOrderView());
                      //   },
                      // ),
                      //  _buildDivider(),
                      _buildMenuItemNew(
                        icon: AppIcons.myDetails,
                        title: 'My Details',
                        subtitle: 'Manage your personal information',
                        onTap: () {
                          if (loginCacheValue?.data?.id == null) {
                            LoginDialog.show(
                              context,
                            );
                            return;
                          }
                          context.navigateToPage(
                            MyDetailsView(
                              editProfileCubit: editProfileCubit,
                            ),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildMenuItemNew(
                        icon: AppIcons.addressBook,
                        title: 'Address Book',
                        subtitle: 'Manage your shipping addresses',
                        onTap: () {
                          if (loginCacheValue?.data?.id == null) {
                            LoginDialog.show(
                              context,
                            );
                            return;
                          }
                          context.navigateToPage(const AddressView());
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Security Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 30, bottom: 10),
                  child: Text(
                    'Security & Preferences'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // Security Menu Items
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // _buildMenuItemNew(
                      //   icon: AppIcons.changePassword,
                      //   title: 'Change Password',
                      //   subtitle: 'Update your account password',
                      //   onTap: () {
                      //     context.navigateToPage(const ResetPasswordView(
                      //       openLoginScreen: false,
                      //     ));
                      //   },
                      // ),
                      // _buildDivider(),
                      // _buildMenuItemNew(
                      //   icon: AppIcons.notificationIcon,
                      //   title: 'Notifications',
                      //   subtitle: 'Manage alert preferences',
                      //   onTap: () {
                      //     context.navigateToPage(const NotificationsSettingsView());
                      //   },
                      // ),

                      _buildDivider(),

                      _buildMenuItemNew(
                        icon: AppIcons.translation,
                        title: 'Language',
                        subtitle: 'Select your preferred language',
                        onTap: () {
                          context.navigateToPage(const LanguageView());
                        },
                      ),
                      // if (loginCacheValue?.data?.email != Constants.demoAccount) ...[
                      //   _buildDivider(),
                      //   _buildMenuItemNew(
                      //     icon: AppIcons.bioMetricIc,
                      //     title: 'sing_in_by_biometric',
                      //     subtitle: 'manage_your_fingerprint',
                      //     onTap: bioMetricsMethod,
                      //     trailing: SafeCustomToggleSwitch(
                      //       isEnabled: _biometricEnabled,
                      //       onToggle: bioMetricsMethod,
                      //       isDisabled: !_biometricSupported,
                      //     ),
                      //   ),
                      // ],
                    ],
                  ),
                ),
              ),

              // Support Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 30, bottom: 10),
                  child: Text(
                    'Support'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // Support Menu Item
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _buildMenuItemNew(
                    icon: AppIcons.customerSerivce,
                    title: 'Help Center',
                    subtitle: 'Get help with your account',
                    onTap: () {
                      context.navigateToPage(const HelpCenterView());
                    },
                  ),
                ),
              ),

              // Account Actions Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 30, bottom: 10),
                  child: Text(
                    'Account Actions'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // Action Buttons
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildActionButton(
                        icon: Icons.logout_rounded,
                        title: 'Logout',
                        color: const Color(0xFFF44336),
                        onTap: () {
                          showLogoutDialog(context, () async {
                            loginCacheValue = null;
                            Constants.token = '';
                            Constants.customerId = null;
                            ConstantsModels.wishListModel = null;
                            context.read<WishListCubit>().wishList.clear();
                            await loginCache?.clear();
                            context.navigateToPage(const NavigationViewWithThemes());
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        icon: Icons.delete_outline_rounded,
                        title: 'Delete Account',
                        color: const Color(0xFF9E9E9E),
                        onTap: () {
                          if (loginCacheValue?.data?.email != Constants.demoAccount) {
                            showDeleteAccountDialog(context, () async {
                              await deleteAccountCubit.deleteAccount(context: context);
                            });
                          } else {
                            Utils.showToast(title: 'This is demo account you can not delete account', state: UtilState.error);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          );
        },
      ),
    );
  }

  void bioMetricsMethod() async {
    if (!_biometricSupported) {
      Utils.showToast(title: 'biometrics_not_supported'.tr(), state: UtilState.error);
      return;
    }

    if (_biometricEnabled) {
      await _biometricService.disableBiometricLogin();
      if (!mounted) return;
      setState(() {
        _biometricEnabled = false;
      });
      Utils.showToast(title: 'biometric_login_disabled'.tr(), state: UtilState.success);
    } else {
      final ok = await _biometricService.authenticate(reason: 'enable_biometric_login'.tr());
      if (!ok) {
        Utils.showToast(title: 'authentication_failed'.tr(), state: UtilState.error);
        return;
      }
      await _biometricService.enableBiometricLogin(ConstantsModels.registerModel!);
      if (!mounted) return;
      setState(() {
        _biometricEnabled = true;
      });
      Utils.showToast(title: 'biometric_login_enabled'.tr(), state: UtilState.success);
    }
  }

  // New elegant menu item design with subtitle
  Widget _buildMenuItemNew({
    required String icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacityNew(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle.tr(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey[400],
                ),
          ],
        ),
      ),
    );
  }

  // Action button for logout and delete account
  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title.tr(),
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 58),
      child: Container(
        height: 1,
        color: Colors.grey.withOpacityNew(0.2),
      ),
    );
  }

  Widget _buildUserInitials(String name) {
    final initials = _getInitials(name);
    return initials.isNotEmpty
        ? Text(
            initials,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        : const Icon(
            Icons.person,
            size: 40,
            color: Colors.white,
          );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  /// Shows a confirmation dialog for logging out
  void showLogoutDialog(BuildContext context, VoidCallback onConfirm) {
    _showConfirmationDialog(
      context,
      icon: const Icon(
        Icons.logout_rounded,
        color: Color(0xFFF44336),
        size: 48,
      ),
      title: 'Logout?'.tr(),
      message: 'Are you sure you want to logout?'.tr(),
      confirmButtonText: 'Yes, Logout'.tr(),
      confirmButtonColor: const Color(0xFFF44336),
      onConfirm: onConfirm,
    );
  }

  /// Shows a confirmation dialog for deleting account
  void showDeleteAccountDialog(BuildContext context, VoidCallback onConfirm) {
    _showConfirmationDialog(
      context,
      icon: const Icon(
        Icons.delete_forever_rounded,
        color: Color(0xFF9E9E9E),
        size: 48,
      ),
      title: 'Delete Account?'.tr(),
      message: 'Are you sure you want to delete your account? This action cannot be undone.'.tr(),
      confirmButtonText: 'Yes, Delete Account'.tr(),
      confirmButtonColor: const Color(0xFF9E9E9E),
      onConfirm: onConfirm,
    );
  }

  /// Redesigned confirmation dialog
  void _showConfirmationDialog(
    BuildContext context, {
    required Widget icon,
    required String title,
    required String message,
    required String confirmButtonText,
    required VoidCallback onConfirm,
    required Color confirmButtonColor,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: Constants.tablet ? 16 : 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmButtonColor,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    confirmButtonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'No, Cancel'.tr(),
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SafeCustomToggleSwitch extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onToggle;
  final bool isDisabled;

  const SafeCustomToggleSwitch({super.key, required this.isEnabled, this.onToggle, this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onToggle,
      child: Semantics(
        label: isEnabled ? 'Enabled' : 'Disabled',
        hint: 'Tap to toggle',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 50,
          height: 28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isDisabled
                ? Colors.grey
                : isEnabled
                    ? AppColors.primaryColor
                    : const Color(0xff343434),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment: isEnabled ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
            child: Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.all(2),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
