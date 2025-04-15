import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/account/view/myDetalis/presentation/my_details_veiw.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/presentation/my_order_view.dart';
import 'package:flutter/material.dart';
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
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: AppIcons.faq,
                    title: 'FAQs',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: AppIcons.helpCenter,
                    title: 'Help Center',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: AppIcons.logout,
                    title: 'Logout',
                    onTap: () {},
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
