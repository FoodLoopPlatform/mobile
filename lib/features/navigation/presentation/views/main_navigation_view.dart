import 'package:flutter/material.dart';
import 'package:foodloop/core/utils/secure_storage_helper.dart';
import 'package:foodloop/features/add_product/presentation/views/add_product_view.dart';
import 'package:foodloop/features/cart/presentation/views/cart_view.dart';
import 'package:foodloop/features/inbox/presentation/views/inbox_view.dart';
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
  late final PageController _pageController;

  /// Stays false until we finish reading from SecureStorage.
  bool _isMerchant = false;
  bool _roleLoaded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _loadRole();
  }

  Future<void> _loadRole() async {
    final role = await SecureStorageHelper.getUserRole();
    if (mounted) {
      setState(() {
        _isMerchant = role == 'Merchant';
        _roleLoaded = true;
      });
    }
  }

  List<Widget> get _views => [
    const MarketView(),
    const OrdersView(),
    if (_isMerchant) const AddProductView() else const CartView(),
    const InboxView(),
    const ProfileView(),
  ];

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
    // Show a blank scaffold while the role is being read (usually <50ms)
    if (!_roleLoaded) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _views,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        isMerchant: _isMerchant,
      ),
    );
  }
}
