import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
import 'package:circle_bottom_navigation/widgets/tab_data.dart';
import 'package:rova_star/core/themes/colors.dart';
import 'package:rova_star/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleNavigationTheme extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CircleNavigationTheme({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return CircleBottomNavigation(
      initialSelection: selectedIndex,
      circleColor: AppColors.primaryColor,
      activeIconColor: Colors.white,
      inactiveIconColor: Colors.black,
      barHeight: 67,
      barBackgroundColor: Colors.white,
      //   cornerRadius: 14,
      shadowAllowance: 0.2,
      blurShadowRadius: 2,
      //  elevation: 4,
      tabs: [
        TabData(
          icon: Icons.home,
          iconSize: 24,
          title: '',
          fontSize: 0,
        ),
        TabData(
          icon: Icons.home,
          iconSize: 24,
          title: '',
          fontSize: 0,
        ),
        TabData(
          icon: Icons.home,
          iconSize: 24,
          title: '',
          fontSize: 0,
        ),
        TabData(
          icon: Icons.home,
          iconSize: 24,
          title: '',
          fontSize: 0,
        ),
      ],
      onTabChangedListener: onItemTapped,
    );
  }

  Widget getTabIcon(int index) {
    // Define which icons to use based on selection state
    String iconPath;
    if (index == 0) {
      iconPath = selectedIndex == 0 ? AppIcons.selectedHomeC : AppIcons.unSelectedHomeC;
    } else if (index == 1) {
      iconPath = selectedIndex == 1 ? AppIcons.selectedHomeR : AppIcons.unSelectedHomeR;
    } else if (index == 2) {
      iconPath = selectedIndex == 2 ? AppIcons.selectedFavoriteR : AppIcons.unSelectedFavoriteR;
    } else {
      iconPath = selectedIndex == 3 ? AppIcons.selectedProfileR : AppIcons.unSelectedProfileR;
    }

    return CustomSvgIcon(
      iconPath: iconPath,
      isSelected: selectedIndex == index,
    );
  }
}

class CustomSvgIcon extends StatelessWidget {
  final String iconPath;
  final bool isSelected;

  const CustomSvgIcon({
    Key? key,
    required this.iconPath,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        isSelected ? Colors.white : Colors.black,
        BlendMode.srcIn,
      ),
    );
  }
}
