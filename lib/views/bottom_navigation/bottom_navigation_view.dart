import 'package:flutter/material.dart';
import 'package:orenda/views/screens/cart_view.dart';
import 'package:orenda/views/screens/menu_view.dart';
import 'package:orenda/views/screens/order_view.dart';
import 'package:orenda/views/waiter_dashboard_view.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late final PageController _pageController;
  int _currentIndex = 1;

  final List<Widget> _pages = const [
    WaiterDashboard(),
    MenuView(),
    OrderView(),
    CartView(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  void _onBottomNavTap(int index) {
    final pageIndex = index + 1;
    setState(() {
      _currentIndex = pageIndex;
    });
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          physics: const BouncingScrollPhysics(),
          children: _pages,
        ),
      ),
      bottomNavigationBar: _currentIndex == 0
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex - 1,
              onTap: _onBottomNavTap,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_menu),
                  label: 'Menu',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long),
                  label: 'Orders',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Cart',
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
