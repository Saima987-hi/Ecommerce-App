import 'package:flutter/material.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'checkout_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> cart = [];
  List<bool> selectedItems = [];

  Widget _getCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return HomePage(
          cart: cart,
          onAddToCart: (product) {
            setState(() {
              cart.add(product);
              selectedItems.add(true);
            });
          },
          onNavigateToCart: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
        );
      case 1:
        return CartPage(
          cartItems: cart,
          selectedItems: selectedItems,
          onUpdateCart: (updatedCart, updatedSelectedItems) {
            setState(() {
              cart = updatedCart;
              selectedItems = updatedSelectedItems;
            });
          },
          onNavigateToHome: () {
            setState(() {
              _selectedIndex = 0;
            });
          },
          onNavigateToCheckout: () {
            if (selectedItems.any((element) => element)) {
              setState(() {
                _selectedIndex = 2;
              });
            }
          },
        );
      case 2:
        return CheckoutPage(
          cartItems: cart,
          selectedItems: selectedItems,
          onOrderConfirmed: () {
            setState(() {
              cart.clear();
              selectedItems.clear();
              _selectedIndex = 0;
            });
          },
          onBackToCart: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
          onNavigateToHome: () {
            setState(() {
              _selectedIndex = 0;
            });
          },
        );
      default:
        return HomePage(
          cart: cart,
          onAddToCart: (product) {
            setState(() {
              cart.add(product);
              selectedItems.add(true);
            });
          },
          onNavigateToCart: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: "Checkout",
          ),
        ],
      ),
    );
  }
}