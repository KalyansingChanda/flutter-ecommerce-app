import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/simple_product_provider.dart';
import 'providers/simple_cart_provider.dart';
import 'providers/auth_user_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/profile/orders_page.dart';
import 'screens/profile/wishlist_page.dart';
import 'screens/profile/rewards_page.dart';
import 'screens/profile/profile_settings_page.dart';
import 'screens/cart_page_new.dart';

const Color kPrimary = Color(0xFF0F83C0);
const Color kTopBarBg = Color(0xFFF5F5F5);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize cart from storage on app startup
    Future.microtask(() {
      final cartProvider = Provider.of<SimpleCartProvider>(context, listen: false);
      cartProvider.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SimpleProductProvider()),
        ChangeNotifierProvider(create: (_) => SimpleCartProvider()),
        ChangeNotifierProvider(create: (_) => AuthUserProvider()),
      ],
      child: MaterialApp(
        title: 'MegaMart',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
          useMaterial3: true,
        ),
        home: const MegaMartHome(),
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

// ─────────────────────────────────────────────
// ROOT SHELL
// ─────────────────────────────────────────────
class MegaMartHome extends StatefulWidget {
  const MegaMartHome({super.key});

  @override
  State<MegaMartHome> createState() => _MegaMartHomeState();
}

class _MegaMartHomeState extends State<MegaMartHome> {
  int _selectedCategory = 0;
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _categories = [
    'Groceries',
    'Premium Fruits',
    'Home & Kitchen',
    'Fashion',
    'Electronics',
    'Beauty',
    'Home Improvement',
    'Sports, Toys & Luggage',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<SimpleCartProvider>(context);
    final productProvider = Provider.of<SimpleProductProvider>(context);
    final authProvider = Provider.of<AuthUserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          // ── 1. TOP INFO BAR ──────────────────
          _TopInfoBar(authProvider: authProvider),

          // ── 2. MAIN HEADER ───────────────────
          _MainHeader(
            searchCtrl: _searchCtrl,
            cartProvider: cartProvider,
            authProvider: authProvider,
          ),

          // ── 3. CATEGORY NAV BAR ──────────────
          _CategoryNavBar(
            categories: _categories,
            selectedIndex: _selectedCategory,
            onSelect: (i) => setState(() => _selectedCategory = i),
          ),

          // ── 4. PAGE BODY ─────────────────────
          Expanded(
            child: _HomeBody(
              productProvider: productProvider,
              cartProvider: cartProvider,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 1. TOP INFO BAR
// ─────────────────────────────────────────────
class _TopInfoBar extends StatelessWidget {
  final AuthUserProvider authProvider;
  const _TopInfoBar({required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kTopBarBg,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Row(
        children: [
          const Text(
            'Welcome to worldwide Megamart!',
            style: TextStyle(fontSize: 12, color: Color(0xFF555555)),
          ),
          const Spacer(),
          _topBarItem(Icons.location_on_outlined, 'Deliver to 423651'),
          const SizedBox(width: 16),
          const Text('|', style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 14)),
          const SizedBox(width: 16),
          _topBarItem(Icons.local_shipping_outlined, 'Track your order'),
          const SizedBox(width: 16),
          const Text('|', style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 14)),
          const SizedBox(width: 16),
          _topBarItem(Icons.local_offer_outlined, 'All Offers'),
        ],
      ),
    );
  }

  Widget _topBarItem(IconData icon, String label) {
    // Bold the last word (e.g. "423651", "order", "Offers")
    final parts = label.split(' ');
    final bold = parts.last;
    final rest = parts.sublist(0, parts.length - 1).join(' ');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: kPrimary),
        const SizedBox(width: 4),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
            children: [
              TextSpan(text: rest.isEmpty ? '' : '$rest '),
              TextSpan(
                text: bold,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// 2. MAIN HEADER
// ─────────────────────────────────────────────
class _MainHeader extends StatefulWidget {
  final TextEditingController searchCtrl;
  final SimpleCartProvider cartProvider;
  final AuthUserProvider authProvider;

  const _MainHeader({
    required this.searchCtrl,
    required this.cartProvider,
    required this.authProvider,
  });

  @override
  State<_MainHeader> createState() => _MainHeaderState();
}

class _MainHeaderState extends State<_MainHeader> {
  final GlobalKey _profileKey = GlobalKey();
  OverlayEntry? _overlay;

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  void _showProfileMenu() {
    final box = _profileKey.currentContext!.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);
    final size = box.size;
    _overlay = OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _hideOverlay,
        child: Stack(
          children: [
            Positioned(
              top: pos.dy + size.height + 4,
              right: MediaQuery.of(context).size.width - pos.dx - size.width,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: _ProfileDropdown(
                  authProvider: widget.authProvider,
                  onClose: _hideOverlay,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _hideOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  @override
  Widget build(BuildContext context) {
    final auth = widget.authProvider;
    final cart = widget.cartProvider;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          // ── Hamburger + Logo ──
          const Icon(Icons.menu, color: kPrimary, size: 24),
          const SizedBox(width: 10),
          const Text(
            'MegaMart',
            style: TextStyle(
              color: kPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(width: 24),

          // ── Search Bar ──
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFDDDDDD)),
              ),
              child: TextField(
                controller: widget.searchCtrl,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search essentials, groceries and more...',
                  hintStyle:
                      const TextStyle(fontSize: 13, color: Color(0xFF999999)),
                  prefixIcon: const Icon(Icons.search,
                      color: Color(0xFF888888), size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune,
                        color: Color(0xFF888888), size: 20),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 24),

          // ── Sign Up / Sign In ──
          GestureDetector(
            key: _profileKey,
            onTap: auth.isLoggedIn
                ? _showProfileMenu
                : () => Navigator.pushNamed(context, '/login'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_outline,
                    color: Color(0xFF333333), size: 22),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      auth.isLoggedIn
                          ? (auth.userName ?? 'Account')
                          : 'Sign Up/Sign In',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222222),
                      ),
                    ),
                    if (auth.isLoggedIn)
                      const Text(
                        'My Account ▼',
                        style: TextStyle(fontSize: 11, color: kPrimary),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // ── Separator ──
          Container(
            width: 1,
            height: 30,
            color: const Color(0xFFDDDDDD),
          ),

          const SizedBox(width: 16),

          // ── Cart ──
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart_outlined,
                        color: Color(0xFF333333), size: 24),
                    if (cart.itemCount > 0)
                      Positioned(
                        top: -6,
                        right: -6,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: kPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${cart.itemCount}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 6),
                const Text(
                  'Cart',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222222),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PROFILE DROPDOWN
// ─────────────────────────────────────────────
class _ProfileDropdown extends StatelessWidget {
  final AuthUserProvider authProvider;
  final VoidCallback onClose;
  const _ProfileDropdown({required this.authProvider, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F3F6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: kPrimary,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.userName ?? 'User',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        authProvider.userEmail ?? '',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _dropItem(context, Icons.person_outline, 'My Profile',
              '/profile-settings'),
          _dropItem(
              context, Icons.shopping_bag_outlined, 'My Orders', '/orders'),
          _dropItem(context, Icons.favorite_outline, 'Wishlist', '/wishlist'),
          _dropItem(
              context, Icons.card_giftcard_outlined, 'Rewards', '/rewards'),
          const Divider(height: 1),
          InkWell(
            onTap: () {
              authProvider.logout();
              onClose();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.logout, size: 18, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Logout',
                      style: TextStyle(color: Colors.red, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropItem(
      BuildContext context, IconData icon, String label, String route) {
    return InkWell(
      onTap: () {
        onClose();
        Navigator.pushNamed(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF555555)),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 13)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                size: 11, color: Color(0xFFAAAAAA)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 3. CATEGORY NAV BAR
// ─────────────────────────────────────────────
class _CategoryNavBar extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _CategoryNavBar({
    required this.categories,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(categories.length, (i) {
            final isSelected = i == selectedIndex;
            final isFirst = i == 0;
            return GestureDetector(
              onTap: () => onSelect(i),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? kPrimary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? null
                      : Border.all(color: const Color(0xFFCCCCCC)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      categories[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF666666),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 4. HOME BODY
// ─────────────────────────────────────────────
class _HomeBody extends StatelessWidget {
  final SimpleProductProvider productProvider;
  final SimpleCartProvider cartProvider;

  const _HomeBody({
    required this.productProvider,
    required this.cartProvider,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              _HeroBanner(),
              const SizedBox(height: 20),

              // ── Products section ──
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF222222)),
                                children: [
                                  TextSpan(text: 'Grab the best deal on '),
                                  TextSpan(
                                    text: 'Smartphones',
                                    style: TextStyle(color: kPrimary),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(width: 160, height: 2, color: kPrimary),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Row(
                            children: [
                              Text('View All',
                                  style: TextStyle(
                                      color: kPrimary, fontSize: 13)),
                              Icon(Icons.arrow_forward_ios,
                                  size: 12, color: kPrimary),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _ProductsRow(
                      products: productProvider.products,
                      cartProvider: cartProvider,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Top Categories ──
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(
                        label: 'Shop From ', highlight: 'Top Categories'),
                    const SizedBox(height: 12),
                    const _TopCategoriesRow(),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Daily Essentials ──
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(
                        label: 'Daily ', highlight: 'Essentials'),
                    const SizedBox(height: 12),
                    const _DailyEssentialsRow(),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Footer (full width)
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HERO BANNER
// ─────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 14),

          // ── Left arrow (outside card) ──
          _arrowBtn(Icons.chevron_left),

          const SizedBox(width: 10),

          // ── Banner card ──
          Expanded(
            child: Container(
              height: 245,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D1B2E), Color(0xFF1C3D60)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    // Left text
                    Positioned(
                      left: 30,
                      top: 0,
                      bottom: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Best Deal Online on smart watches',
                            style: TextStyle(
                                color: Color(0xFF8BB4D4), fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'SMART WEARABLE.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'UP to 80% OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Dot indicators
                          Row(
                            children: List.generate(
                              6,
                              (i) => Container(
                                margin: const EdgeInsets.only(right: 6),
                                width: i == 0 ? 22 : 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: i == 0
                                      ? Colors.white
                                      : Colors.white.withAlpha(70),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right watch image with left-edge gradient blend
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: 240,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=400&q=80',
                              fit: BoxFit.contain,
                              alignment: Alignment.centerRight,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.watch,
                                size: 100,
                                color: Color(0xFF88AACC),
                              ),
                            ),
                          ),
                          // Gradient overlay blends left edge into banner
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF1C3D60),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [0.0, 0.35],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ── Right arrow (outside card) ──
          _arrowBtn(Icons.chevron_right),

          const SizedBox(width: 14),
        ],
      ),
    );
  }

  Widget _arrowBtn(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: const Color(0xFF444444), size: 24),
    );
  }
}

// ─────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  final String highlight;
  const _SectionHeader({required this.label, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222)),
                children: [
                  TextSpan(text: label),
                  TextSpan(
                      text: highlight,
                      style: const TextStyle(color: kPrimary)),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Container(width: 120, height: 2, color: kPrimary),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Row(
            children: [
              Text('View All',
                  style: TextStyle(color: kPrimary, fontSize: 13)),
              Icon(Icons.arrow_forward_ios, size: 12, color: kPrimary),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PRODUCTS ROW
// ─────────────────────────────────────────────
class _ProductsRow extends StatelessWidget {
  final List products;
  final SimpleCartProvider cartProvider;

  const _ProductsRow({
    required this.products,
    required this.cartProvider,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: products.length,
        itemBuilder: (ctx, i) {
          final p = products[i];
          final saving = p.originalPrice - p.price;
          return Container(
            width: 168,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE8E8E8)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8)),
                      child: Image.network(
                        p.imageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 150,
                          color: const Color(0xFFF5F5F5),
                          child: Center(
                            child: Icon(_icon(p.category),
                                size: 52, color: kPrimary),
                          ),
                        ),
                      ),
                    ),
                    if (p.discountPercent > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: kPrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${p.discountPercent}%\nOFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600,
                            color: Color(0xFF222222)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '₹${p.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF222222)),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '₹${p.originalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF999999),
                                decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Save - ₹${saving.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF00A650),
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () {
                          cartProvider.addToCart(p);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${p.name} added!'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: kPrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Text(
                              'Add to Cart',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _icon(String category) {
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
}

// ─────────────────────────────────────────────
// EMPTY PRODUCTS
// ─────────────────────────────────────────────
class _EmptyProducts extends StatelessWidget {
  final VoidCallback onLoad;
  const _EmptyProducts({required this.onLoad});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined,
              size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('No products yet',
              style: TextStyle(color: Colors.grey, fontSize: 15)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onLoad,
            style:
                ElevatedButton.styleFrom(backgroundColor: kPrimary),
            child: const Text('Load Products',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TOP CATEGORIES ROW
// ─────────────────────────────────────────────
class _TopCategoriesRow extends StatelessWidget {
  const _TopCategoriesRow();

  static const List<Map<String, dynamic>> _cats = [
    {'label': 'Mobile', 'icon': Icons.smartphone},
    {'label': 'Cosmetics', 'icon': Icons.spa},
    {'label': 'Electronics', 'icon': Icons.devices_other},
    {'label': 'Furniture', 'icon': Icons.chair},
    {'label': 'Watches', 'icon': Icons.watch},
    {'label': 'Decor', 'icon': Icons.local_florist},
    {'label': 'Accessories', 'icon': Icons.diamond},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _cats.length,
        itemBuilder: (ctx, i) {
          return SizedBox(
            width: 80,
            child: Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFDDDDDD)),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 4,
                          offset: Offset(0, 2)),
                    ],
                  ),
                  child: Icon(_cats[i]['icon'] as IconData,
                      color: kPrimary, size: 26),
                ),
                const SizedBox(height: 6),
                Text(
                  _cats[i]['label'] as String,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF333333)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DAILY ESSENTIALS ROW
// ─────────────────────────────────────────────
class _DailyEssentialsRow extends StatelessWidget {
  const _DailyEssentialsRow();

  static const List<Map<String, dynamic>> _items = [
    {
      'label': 'Daily Essentials',
      'icon': Icons.shopping_basket,
      'color': Color(0xFFFFE0B2)
    },
    {'label': 'Vegetables', 'icon': Icons.eco, 'color': Color(0xFFC8E6C9)},
    {'label': 'Fruits', 'icon': Icons.apple, 'color': Color(0xFFFFCCBC)},
    {
      'label': 'Strawberry',
      'icon': Icons.restaurant,
      'color': Color(0xFFFFCDD2)
    },
    {
      'label': 'Mango',
      'icon': Icons.local_dining,
      'color': Color(0xFFFFF9C4)
    },
    {
      'label': 'Cherry',
      'icon': Icons.breakfast_dining,
      'color': Color(0xFFEECECE)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _items.length,
        itemBuilder: (ctx, i) {
          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Column(
              children: [
                Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: _items[i]['color'] as Color,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8)),
                  ),
                  child: Center(
                    child: Icon(_items[i]['icon'] as IconData,
                        size: 36, color: Colors.brown[700]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 5),
                  child: Column(
                    children: [
                      Text(
                        _items[i]['label'] as String,
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'UP to 50% OFF',
                        style: TextStyle(
                            fontSize: 10,
                            color: kPrimary,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FOOTER
// ─────────────────────────────────────────────
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A2D45),
      padding:
          const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand column
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MegaMart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _footerContact(Icons.location_on_outlined,
                        'Where2Bee,\n+1 282-418-2120'),
                    const SizedBox(height: 10),
                    _footerContact(
                        Icons.call_outlined, 'Call Us\n+1 282-418-2120'),
                    const SizedBox(height: 16),
                    const Text('Download App',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _appBadge('App Store', Icons.apple),
                        const SizedBox(width: 8),
                        _appBadge('Google Play', Icons.android),
                      ],
                    ),
                  ],
                ),
              ),
              // Categories column
              Expanded(
                child: _footerColumn('Most Popular Categories', [
                  'Staples',
                  'Beverages',
                  'Personal Care',
                  'Home Care',
                  'Baby Care',
                  'Vegetables & Fruits',
                  'Snacks & Foods',
                  'Dairy & Bakery',
                ]),
              ),
              // Support column
              Expanded(
                child: _footerColumn('Customer Services', [
                  'About Us',
                  'Terms & Conditions',
                  'FAQ',
                  'Privacy Policy',
                  'E-waste Policy',
                  'Cancellation & Return Policy',
                ]),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFF2E4060)),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              '© 2024 All rights reserved. MegaMart Ltd.',
              style: TextStyle(color: Color(0xFF8899AA), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerContact(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Text(text,
            style:
                const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _appBadge(String label, IconData icon) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _footerColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(width: 40, height: 2, color: kPrimary),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.arrow_right,
                    color: Colors.white54, size: 14),
                const SizedBox(width: 4),
                Text(item,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
