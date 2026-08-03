import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/simple_product_provider.dart';
import 'providers/web_cart_provider.dart';
import 'screens/web_cart_page.dart';

const Color kPrimary = Color(0xFF0F83C0);
const Color kTopBarBg = Color(0xFFF5F5F5);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SimpleProductProvider()),
        ChangeNotifierProvider(create: (_) => SimpleCartProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
    // Load cart from local storage on app startup
    Future.microtask(() {
      if (mounted) {
        Provider.of<SimpleCartProvider>(context, listen: false).initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MegaMart - Web Version',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
        useMaterial3: true,
      ),
      home: const MegaMartHome(),
      onGenerateRoute: (settings) {
        if (settings.name == '/cart') {
          return MaterialPageRoute(
            builder: (context) => const WebCartPage(),
          );
        }
        return null;
      },
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

  static const List<String> _categories = [
    'All',
    'Electronics',
    'Clothing',
    'Books',
    'Home',
  ];

  final List<String> _categoryEmojis = ['🔍', '📱', '👕', '📚', '🏠'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // TOP BAR
          Container(
            color: kTopBarBg,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '🛒 MegaMart',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: kPrimary,
                      ),
                    ),
                    Consumer<SimpleCartProvider>(
                      builder: (context, cart, _) => Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/cart'),
                          ),
                          if (cart.items.isNotEmpty)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${cart.items.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: kPrimary),
                    ),
                    prefixIcon: const Icon(Icons.search, color: kPrimary),
                  ),
                ),
              ],
            ),
          ),
          // CATEGORIES
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(
                      '${_categoryEmojis[index]} ${_categories[index]}',
                    ),
                    selected: _selectedCategory == index,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = index);
                    },
                  ),
                );
              },
            ),
          ),
          // PRODUCTS GRID
          Expanded(
            child: Consumer<SimpleProductProvider>(
              builder: (context, productProvider, _) {
                final products = productProvider.products;
                if (products.isEmpty) {
                  return const Center(
                    child: Text('No products available'),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.grey[200],
                              child: product.imageUrl.isNotEmpty
                                  ? Image.network(
                                      product.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.image_not_supported),
                                    )
                                  : const Icon(Icons.shopping_bag),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₹${product.price}',
                                  style: const TextStyle(
                                    color: kPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                    ),
                                    onPressed: () {
                                      Provider.of<SimpleCartProvider>(context,
                                              listen: false)
                                          .addToCart(
                                        product.id,
                                        product.name,
                                        product.price,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${product.name} added to cart',
                                          ),
                                          duration:
                                              const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Add',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }
}
