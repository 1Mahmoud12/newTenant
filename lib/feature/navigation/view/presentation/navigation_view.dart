import 'package:dobzz_seller/feature/account/view/presentation/account_view.dart';
import 'package:dobzz_seller/feature/cart/view/presentation/cart_view.dart';
import 'package:dobzz_seller/feature/favorites/views/presentation/favorite_view.dart';
import 'package:dobzz_seller/feature/home/views/presentation/home_page_view.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_bar_theme/circled_border_Theme.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_bar_theme/reguler_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum NavigationTheme {
  circular,
  regular,
}

class NavigationViewWithThemes extends StatefulWidget {
  const NavigationViewWithThemes({
    Key? key,
    this.initialIndex = 0,
    this.theme = NavigationTheme.regular,
  }) : super(key: key);

  final int? initialIndex;
  final NavigationTheme theme;

  @override
  State<NavigationViewWithThemes> createState() => _NavigationViewWithThemesState();
}

class _NavigationViewWithThemesState extends State<NavigationViewWithThemes> {
  int _selectedIndex = 0;
  late NavigationTheme _theme;

  @override
  void initState() {
    _selectedIndex = widget.initialIndex!;
    _theme = widget.theme;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    const HomePageView(),
    const CartView(),
    const FavoriteView(),
    const AccountView(),
  ];

  // Function to handle back button press
  Future<bool> _onWillPop() async {
    // Exit the app when back button is pressed
    SystemNavigator.pop();
    return false; // Return false to prevent default back navigation
  }

  @override
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents default pop behavior
      onPopInvokedWithResult: (didPop, o) {
        if (!didPop) {
          SystemNavigator.pop(); // Close the app manually
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _screens[_selectedIndex],
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: NavigationThemeSwitcher(
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
                theme: _theme,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage with navigation theme switcher
class NavigationThemeSwitcher extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final NavigationTheme theme;

  const NavigationThemeSwitcher({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (theme) {
      case NavigationTheme.circular:
        return CircledBorderTheme(
          // Using renamed component
          selectedIndex: selectedIndex,
          onItemTapped: onItemTapped,
        );
      case NavigationTheme.regular:
        return RegularNavigationBar(
          selectedIndex: selectedIndex,
          onItemTapped: onItemTapped,
        );
    }
  }
}
