import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/account/view/faq/presentation/faq_view.dart';
import 'package:dobzz_seller/feature/account/view/helpCenter/presentation/help_center_view.dart';
import 'package:dobzz_seller/feature/account/view/myDetalis/presentation/my_details_veiw.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/presentation/my_order_view.dart';
import 'package:dobzz_seller/feature/account/view/notificationSetting/presentation/notification_setting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AccountView extends StatelessWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Account', stopLeading: true),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile image
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: Container(
                        color: Colors.grey[700],
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Name
                  const Text(
                    'Ahmed Osama',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Member since
                  Text(
                    'member since 10/10/2024',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Menu items
            Expanded(
              child: ListView(
                children: [
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
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: AppIcons.paymentMethod,
                    title: 'Payment Methods',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: AppIcons.notificationIcon,
                    title: 'Notifications',
                    onTap: () {
                      context.navigateToPage(const NotificationsSettingsview());
                    },
                  ),
                  _buildMenuItem(
                    icon: AppIcons.faq,
                    title: 'FAQs',
                    onTap: () {
                      context.navigateToPage(const FaqsView());
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
                      showLogoutDialog(context, () {});
                    },
                    isLogout: true,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context, VoidCallback onConfirm) {
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
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Logout?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to logout?',
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Yes, Logout',
                    style: TextStyle(color: Colors.white),
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
  }) {
    return ListTile(
      leading: SvgPicture.asset(
        icon,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          isLogout ? Colors.red : Colors.black,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black,
          fontSize: 14,
        ),
      ),
      trailing: isLogout ? null : SvgPicture.asset(AppIcons.arrowRight),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
