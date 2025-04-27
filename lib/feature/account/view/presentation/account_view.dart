import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/account/view/faq/presentation/faq_view.dart';
import 'package:dobzz_seller/feature/account/view/helpCenter/presentation/help_center_view.dart';
import 'package:dobzz_seller/feature/account/view/manager/deleteAccount/cubit/delete_account_cubit.dart';
import 'package:dobzz_seller/feature/account/view/myDetalis/presentation/my_details_veiw.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/presentation/my_order_view.dart';
import 'package:dobzz_seller/feature/account/view/notificationSetting/presentation/notification_setting_view.dart';
import 'package:dobzz_seller/feature/auth/forgetPassword/view/presentation/forget_password_view.dart';
import 'package:dobzz_seller/feature/auth/login/view/presentation/login_screen.dart';
import 'package:dobzz_seller/feature/cart/view/address/presentation/address_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final currentLanguage = 'English';
  DeleteAccountCubit deleteAccountCubit = DeleteAccountCubit();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              customAppBar(context: context, title: 'Account', stopLeading: true),
              // Profile header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile image
                    CacheImage(
                      errorColor: Colors.grey,
                      height: 60,
                      width: 60,
                      circle: true,
                      urlImage: userCacheValue?.data?.avatarPath ?? '',
                    ),
                    const SizedBox(height: 10),
                    // Name
                    Text(
                      userCacheValue?.data?.name ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // const SizedBox(height: 2),
                    // // Member since
                    // Text(
                    //   'member since 10/10/2024',
                    //   style: TextStyle(
                    //     color: Colors.grey[600],
                    //     fontSize: 12,
                    //   ),
                    // ),
                  ],
                ),
              ),

              // Menu items
              _buildMenuItem(
                icon: AppIcons.myOrders,
                title: 'My Orders',
                onTap: () {
                  context.navigateToPage(const MyOrderView());
                },
              ),
              _buildMenuItem(
                icon: AppIcons.myDetails,
                title: 'My Details',
                onTap: () {
                  context.navigateToPage(const MyDetailsView());
                },
              ),
              _buildMenuItem(
                icon: AppIcons.addressBook,
                title: 'Address Book',
                onTap: () {
                  context.navigateToPage(const AddressView());
                },
              ),
              _buildMenuItem(
                icon: AppIcons.changePassword,
                title: 'Change Password',
                onTap: () {
                  context.navigateToPage(const ForgetPasswordView());
                },
              ),
              // _buildMenuItem(
              //   icon: AppIcons.paymentMethod,
              //   title: 'Payment Methods',
              //   onTap: () {},
              // ),
              _buildMenuItem(
                icon: AppIcons.notificationIcon,
                title: 'Notifications',
                onTap: () {
                  context.navigateToPage(const NotificationsSettingsView());
                },
              ),
              // _buildMenuItem(
              //   icon: AppIcons.faq,
              //   title: 'FAQs',
              //   onTap: () {
              //     context.navigateToPage(const FaqsView());
              //   },
              // ),
              _buildMenuItem(
                icon: AppIcons.faq,
                title: 'Language',
                onTap: () {
                  _showLanguageSelector(currentLanguage, context);
                },
              ),
              _buildMenuItem(
                icon: AppIcons.customerSerivce,
                title: 'Help Center',
                onTap: () {
                  context.navigateToPage(const HelpCenterView());
                },
              ),
              _buildMenuItem(
                icon: AppIcons.logout,
                title: 'Logout',
                onTap: () {
                  showLogoutDialog(context, () async {
                    userCacheValue = null;
                    await userCache?.clear();
                    context.navigateToPageWithClearStack(const LoginScreen());
                  });
                },
                isLogout: true,
              ),
              _buildMenuItem(
                icon: AppIcons.deleteIcon,
                title: 'Delete Account',
                onTap: () {
                  showDeleteAccountDialog(context, () async {
                    await deleteAccountCubit.deleteAccount(context: context);
                  });
                },
                isDeleteAccount: true,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
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
        onTap: () => _showLanguageSelector(currentLanguage, context),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  void _showLanguageSelector(String currentLanguage, BuildContext context) {
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
              _buildLanguageOption('English', currentLanguage, context),
              _buildLanguageOption('Arabic', currentLanguage, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language, String currentLanguage, BuildContext context) {
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
        }
        setState(() {});
        Navigator.pop(context);
        // Here you would typically call an API to save the language setting
        // For example: _cubit.updateLanguageSetting(language: language);
      },
    );
  }

  /// Shows a confirmation dialog for logging out
  void showLogoutDialog(BuildContext context, VoidCallback onConfirm) {
    _showConfirmationDialog(
      context,
      icon: const Icon(
        Icons.logout_rounded,
        color: AppColors.primaryColor,
        size: 48,
      ),
      title: 'Logout?',
      message: 'Are you sure you want to logout?',
      confirmButtonText: 'Yes, Logout',
      onConfirm: onConfirm,
    );
  }

  /// Shows a confirmation dialog for deleting account
  void showDeleteAccountDialog(BuildContext context, VoidCallback onConfirm) {
    _showConfirmationDialog(
      context,
      icon: const Icon(
        Icons.delete_forever_rounded,
        color: AppColors.primaryColor,
        size: 48,
      ),
      title: 'Delete Account?',
      message: 'Are you sure you want to delete your account? This action cannot be undone.',
      confirmButtonText: 'Yes, Delete Account',
      onConfirm: onConfirm,
    );
  }

  /// Private helper method to avoid code duplication between the two dialogs
  void _showConfirmationDialog(
    BuildContext context, {
    required Widget icon,
    required String title,
    required String message,
    required String confirmButtonText,
    required VoidCallback onConfirm,
    Color confirmButtonColor = AppColors.primaryColor,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmButtonColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    confirmButtonText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'No, Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
    bool isDeleteAccount = false,
  }) {
    Color textColor = Colors.black;
    if (isLogout) textColor = Colors.red;
    if (isDeleteAccount) textColor = Colors.red;

    return ListTile(
      leading: SvgPicture.asset(
        icon,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          isLogout || isDeleteAccount ? Colors.red : Colors.black,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
        ),
      ),
      trailing: (isLogout || isDeleteAccount) ? null : SvgPicture.asset(AppIcons.arrowRight),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
