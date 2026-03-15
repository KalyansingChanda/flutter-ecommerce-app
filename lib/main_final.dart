import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/simple_product_provider.dart';
import 'providers/simple_cart_provider.dart';
import 'providers/auth_user_provider.dart';
import 'utils/theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/profile/orders_page.dart';
import 'screens/profile/wishlist_page.dart';
import 'screens/profile/rewards_page.dart';
import 'screens/profile/profile_settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SimpleProductProvider()),
        ChangeNotifierProvider(create: (context) => SimpleCartProvider()),
        ChangeNotifierProvider(create: (context) => AuthUserProvider()),
      ],
      child: MaterialApp(
        title: '🛒 E-Commerce App',
        theme: AppTheme.lightTheme,
        home: const ECommerceHome(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => const LoginScreen(),
          '/orders': (context) => const OrdersPage(),
          '/wishlist': (context) => const WishlistPage(),
          '/rewards': (context) => const RewardsPage(),
          '/profile-settings': (context) => const ProfileSettingsPage(),
        },
      ),
    );
  }
}

class ECommerceHome extends StatefulWidget {
  const ECommerceHome({super.key});

  @override
  State<ECommerceHome> createState() => _ECommerceHomeState();
}

class _ECommerceHomeState extends State<ECommerceHome> {
  int _currentIndex = 0;
  final GlobalKey _profileButtonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<SimpleCartProvider>(context);
    final productProvider = Provider.of<SimpleProductProvider>(context);
    final authProvider = Provider.of<AuthUserProvider>(context);

    List<Widget> pages = [
      _buildHomePage(productProvider, cartProvider, authProvider),
      _buildCategoriesPage(productProvider, cartProvider, authProvider),
      _buildCartPage(cartProvider, authProvider),
      _buildProfilePage(authProvider),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartProvider.itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${cartProvider.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(String title, AuthUserProvider authProvider) {
    return AppBar(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      title: title == 'Home'
          ? Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            )
          : Text(title),
      actions: [
        if (authProvider.isLoggedIn)
          GestureDetector(
            key: _profileButtonKey,
            onTap: () => _showProfileDropdown(authProvider),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 16, color: Colors.blue),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    authProvider.userName ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
                ],
              ),
            ),
          )
        else
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  void _showProfileDropdown(AuthUserProvider authProvider) {
    final RenderBox renderBox = _profileButtonKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = _createOverlayEntry(position, size, authProvider);
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry(Offset position, Size buttonSize, AuthUserProvider authProvider) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy + buttonSize.height,
        left: position.dx - 200 + buttonSize.width,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // User Info Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F3F6),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authProvider.userName ?? 'User',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              authProvider.userEmail ?? 'user@example.com',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Menu Items
                _buildDropdownItem(Icons.person_outline, 'My Profile', () {
                  _hideOverlay();
                  Navigator.pushNamed(context, '/profile-settings');
                }),
                _buildDropdownItem(Icons.shopping_bag_outlined, 'Orders', () {
                  _hideOverlay();
                  Navigator.pushNamed(context, '/orders');
                }),
                _buildDropdownItem(Icons.favorite_outline, 'Wishlist', () {
                  _hideOverlay();
                  Navigator.pushNamed(context, '/wishlist');
                }),
                _buildDropdownItem(Icons.card_giftcard_outlined, 'Rewards', () {
                  _hideOverlay();
                  Navigator.pushNamed(context, '/rewards');
                }),
                _buildDropdownItem(Icons.notification_important_outlined, 'Notifications', () {
                  _hideOverlay();
                  _showComingSoon();
                }),
                _buildDropdownItem(Icons.help_outline, '24x7 Customer Care', () {
                  _hideOverlay();
                  _showComingSoon();
                }),
                _buildDropdownItem(Icons.download_outlined, 'Download App', () {
                  _hideOverlay();
                  _showComingSoon();
                }),
                
                const Divider(height: 1),
                
                _buildDropdownItem(Icons.logout, 'Logout', () {
                  _hideOverlay();
                  authProvider.logout();
                  setState(() => _currentIndex = 0);
                }, textColor: Colors.red),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(IconData icon, String title, VoidCallback onTap, {Color? textColor}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: textColor ?? Colors.grey[700]),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: textColor ?? Colors.black87,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showComingSoon() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon!'),
        content: const Text('This feature will be available in the next update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage(SimpleProductProvider productProvider, SimpleCartProvider cartProvider, AuthUserProvider authProvider) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar('Home', authProvider) as PreferredSizeWidget,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner
            Container(
              height: 180,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      'E-Commerce Store',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Shop the best products\\nat amazing prices',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            // Products Section  
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Products',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _currentIndex = 1),
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),

            productProvider.products.isEmpty
                ? _buildEmptyState(productProvider)
                : _buildProductsList(productProvider.products, cartProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(SimpleProductProvider productProvider) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No products available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => productProvider.addSampleProducts(),
            child: const Text('Add Sample Products'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(List products, SimpleCartProvider cartProvider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getProductIcon(product.category),
                        size: 50,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.category,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            cartProvider.addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} added to cart!'),
                                duration: const Duration(seconds: 1),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriesPage(SimpleProductProvider productProvider, SimpleCartProvider cartProvider, AuthUserProvider authProvider) {
    return Scaffold(
      appBar: _buildAppBar('Categories', authProvider) as PreferredSizeWidget,
      body: productProvider.products.isEmpty
          ? _buildEmptyState(productProvider)
          : _buildProductsList(productProvider.products, cartProvider),
    );
  }

  Widget _buildCartPage(SimpleCartProvider cartProvider, AuthUserProvider authProvider) {
    return Scaffold(
      appBar: _buildAppBar('My Cart (${cartProvider.itemCount} items)', authProvider) as PreferredSizeWidget,
      body: cartProvider.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 120, color: Colors.grey[300]),
                  const SizedBox(height: 24),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() => _currentIndex = 0),
                    child: const Text('Start Shopping'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartProvider.items.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.shopping_bag, color: Colors.blue),
                          title: Text(item.name),
                          subtitle: Text('₹${item.price.toStringAsFixed(0)} x ${item.quantity}'),
                          trailing: Text(
                            '₹${item.totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(
                            '₹${cartProvider.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('🎉 Order Placed!'),
                                content: const Text('Thank you for your order!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      cartProvider.clearCart();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                          child: Text('CHECKOUT (${cartProvider.itemCount} items)'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProfilePage(AuthUserProvider authProvider) {
    return Scaffold(
      appBar: _buildAppBar('My Profile', authProvider) as PreferredSizeWidget,
      body: authProvider.isLoggedIn
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Profile loaded successfully!',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Use the profile menu in the top-right corner',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_outline, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    'Please login to access your profile',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text('Login Now'),
                  ),
                ],
              ),
            ),
    );
  }

  IconData _getProductIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Icons.devices;
      case 'clothing':
        return Icons.checkroom;
      case 'footwear':
        return Icons.sports_basketball;
      default:
        return Icons.shopping_bag;
    }
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }
}