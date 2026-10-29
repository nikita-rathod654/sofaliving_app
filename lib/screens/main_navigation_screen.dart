import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import 'home/home_screen.dart';
import 'product_listing/product_listing_screen.dart';
import 'wishlist/wishlist_screen.dart';
import 'cart/cart_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onTabChange: _onTabTapped),
      const ProductListingScreen(),
      WishlistScreen(
        onExplore: () => _onTabTapped(1),
        onGoToCart: () => _onTabTapped(3),
      ),
      CartScreen(
        onContinueShopping: () => _onTabTapped(1),
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Consumer2<CartProvider, WishlistProvider>(
        builder: (context, cart, wishlist, _) {
          final cartCount = cart.totalItemCount;
          final wishCount = wishlist.itemCount;

          return Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border, width: 0.8)),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              backgroundColor: AppColors.surface,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textMuted,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              type: BottomNavigationBarType.fixed,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined),
                  activeIcon: Icon(Icons.explore),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: _buildBadgeIcon(
                    icon: Icons.favorite_border,
                    badgeCount: wishCount,
                  ),
                  activeIcon: _buildBadgeIcon(
                    icon: Icons.favorite,
                    badgeCount: wishCount,
                  ),
                  label: 'Wishlist',
                ),
                BottomNavigationBarItem(
                  icon: _buildBadgeIcon(
                    icon: Icons.shopping_bag_outlined,
                    badgeCount: cartCount,
                  ),
                  activeIcon: _buildBadgeIcon(
                    icon: Icons.shopping_bag,
                    badgeCount: cartCount,
                  ),
                  label: 'Cart',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBadgeIcon({required IconData icon, required int badgeCount}) {
    if (badgeCount <= 0) {
      return Icon(icon);
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        Positioned(
          right: -6,
          top: -4,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
            child: Text(
              '$badgeCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
