import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/web_cart_provider.dart';

class WebCartPage extends StatefulWidget {
  const WebCartPage({super.key});

  @override
  State<WebCartPage> createState() => _WebCartPageState();
}

class _WebCartPageState extends State<WebCartPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SimpleCartProvider>(
      builder: (context, cart, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Shopping Cart'),
            backgroundColor: const Color(0xFF0F83C0),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: cart.items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add items to your cart to get started',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Continue Shopping'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Cart Items
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final item = cart.items[index];
                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Product Image
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.shopping_bag),
                                  ),
                                  const SizedBox(width: 12),
                                  // Product Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₹${item.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Color(0xFF0F83C0),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Quantity Controls
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 28,
                                              height: 28,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (item.quantity > 1) {
                                                    cart.updateQuantity(
                                                      item.productId,
                                                      item.quantity - 1,
                                                    );
                                                  }
                                                },
                                                child: const Text('-'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 40,
                                              child: Center(
                                                child: Text(
                                                  '${item.quantity}',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 28,
                                              height: 28,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  cart.updateQuantity(
                                                    item.productId,
                                                    item.quantity + 1,
                                                  );
                                                },
                                                child: const Text('+'),
                                              ),
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                cart.removeFromCart(
                                                  item.productId,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Order Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border(
                          top:
                              BorderSide(color: Colors.grey[300]!, width: 1),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                '₹${cart.totalPrice.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Shipping',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const Text(
                                'Free',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Divider(color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '₹${cart.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F83C0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F83C0),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Proceeding to checkout...'),
                                  ),
                                );
                              },
                              child: const Text(
                                'Proceed to Checkout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
        );
      },
    );
  }
}
