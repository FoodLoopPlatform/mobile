import 'package:flutter/material.dart';
import 'package:foodloop/features/cart/presentation/views/cart_view.dart';
import 'package:foodloop/features/market/presentation/views/market_view.dart';
import 'package:foodloop/features/navigation/presentation/views/widgets/custom_bottom_nav_bar.dart';
import 'package:foodloop/features/orders/presentation/views/orders_view.dart';
import 'package:foodloop/features/profile/presentation/views/profile_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _currentIndex = 0;
  // int _currentIndex = 3;
  late final PageController _pageController;

  final List<Widget> _views = const [
    MarketView(),
    OrdersView(),
    CartView(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _views,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
