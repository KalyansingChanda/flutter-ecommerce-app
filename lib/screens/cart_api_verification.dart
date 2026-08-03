import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/simple_cart_provider.dart';
import 'dart:convert';

class CartApiVerificationPage extends StatefulWidget {
  const CartApiVerificationPage({super.key});

  @override
  State<CartApiVerificationPage> createState() => _CartApiVerificationPageState();
}

class _CartApiVerificationPageState extends State<CartApiVerificationPage> {
  bool _isLoading = false;
  Map<String, dynamic>? _firebaseData;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 Firebase Cart Verification'),
        backgroundColor: const Color(0xFF0F83C0),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Local Cart Data Section
            _buildSection(
              title: '📱 Local Storage Cart Data',
              child: Consumer<SimpleCartProvider>(
                builder: (context, cartProvider, _) {
                  if (cartProvider.items.isEmpty) {
                    return const Text(
                      'No items in local cart',
                      style: TextStyle(color: Colors.grey),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDataRow('Items Count', '${cartProvider.itemCount}'),
                      _buildDataRow('Total Amount', '₹${cartProvider.totalAmount.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      const Text(
                        'Cart Items:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...cartProvider.items.asMap().entries.map((entry) {
                        int index = entry.key;
                        var item = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Item ${index + 1}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              _buildDataRow('Product ID', item.productId),
                              _buildDataRow('Name', item.name),
                              _buildDataRow('Price', '₹${item.price.toStringAsFixed(2)}'),
                              _buildDataRow('Quantity', '${item.quantity}'),
                              _buildDataRow(
                                'Subtotal',
                                '₹${item.totalPrice.toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Firebase Verification Section
            _buildSection(
              title: '☁️ Firebase Database Data',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _fetchFirebaseData,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.refresh),
                      label: Text(_isLoading ? 'Loading...' : 'Check Firebase'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F83C0),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Error:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_firebaseData != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '✅ Data Found in Firebase',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildDataRow('User ID', _firebaseData!['userId'] ?? 'N/A'),
                            _buildDataRow(
                              'Item Count',
                              '${(_firebaseData!['items'] as List?)?.length ?? 0}',
                            ),
                            _buildDataRow(
                              'Total Amount',
                              '₹${(_firebaseData!['totalAmount'] ?? 0).toStringAsFixed(2)}',
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Items in Firebase:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...((_firebaseData!['items'] as List?)?.asMap().entries.map((entry) {
                              int index = entry.key;
                              var item = entry.value as Map<String, dynamic>;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Item ${index + 1}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    _buildDataRow('Product ID', item['productId'] ?? 'N/A'),
                                    _buildDataRow('Name', item['name'] ?? 'N/A'),
                                    _buildDataRow(
                                      'Price',
                                      '₹${(item['price'] ?? 0).toStringAsFixed(2)}',
                                    ),
                                    _buildDataRow('Quantity', '${item['quantity'] ?? 0}'),
                                  ],
                                ),
                              );
                            }).toList() ?? []),
                            const SizedBox(height: 12),
                            const Text(
                              'Raw JSON Data:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                jsonEncode(_firebaseData),
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Instructions Section
            _buildSection(
              title: '📋 How to Verify',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInstruction('1', 'Add items to your cart from the main page'),
                  _buildInstruction('2', 'Click "Check Firebase" button to fetch data'),
                  _buildInstruction('3', 'See cart data stored in Firebase database'),
                  _buildInstruction('4', 'JSON data shows exact format in Firestore'),
                  _buildInstruction('5', 'Local and Firebase data should match'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // How to Manual Check Section
            _buildSection(
              title: '🔐 Manual Firebase Check',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'To manually verify data in Firebase Console:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildInstruction(
                    '1',
                    'Go to: firebase.google.com/console',
                  ),
                  _buildInstruction(
                    '2',
                    'Select your project → Firestore Database',
                  ),
                  _buildInstruction(
                    '3',
                    'Look for "carts" collection',
                  ),
                  _buildInstruction(
                    '4',
                    'Document ID = Your User ID',
                  ),
                  _buildInstruction(
                    '5',
                    'View "items" array with all cart products',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F83C0),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade50,
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF0F83C0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchFirebaseData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _firebaseData = null;
    });

    try {
      final cartProvider = context.read<SimpleCartProvider>();
      final data = await cartProvider.getFirebaseCartData();

      setState(() {
        if (data != null) {
          _firebaseData = data;
          _errorMessage = null;
        } else {
          _firebaseData = null;
          _errorMessage = 'No cart data found in Firebase. Add items to cart first.';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
