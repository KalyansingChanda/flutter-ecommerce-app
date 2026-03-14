import 'package:flutter/material.dart';






























































































































































































































































































































































































}  }    );      ),        ],          ),            child: const Text('Clear All'),            },              );                ),                  backgroundColor: Colors.green,                  content: Text('Wishlist cleared successfully'),                const SnackBar(              ScaffoldMessenger.of(context).showSnackBar(              Navigator.pop(context);              });                _wishlistItems.clear();              setState(() {            onPressed: () {          TextButton(          ),            child: const Text('Cancel'),            onPressed: () => Navigator.pop(context),          TextButton(        actions: [        content: const Text('Are you sure you want to remove all items from your wishlist?'),        title: const Text('Clear Wishlist'),      builder: (context) => AlertDialog(      context: context,    showDialog(        if (_wishlistItems.isEmpty) return;  void _clearWishlist() {  }    );      ),        ),          },            });              _wishlistItems.insert(index, item);            setState(() {          onPressed: () {          textColor: Colors.white,          label: 'UNDO',        action: SnackBarAction(        backgroundColor: Colors.red,        content: Text('${item['name']} removed from wishlist'),      SnackBar(    ScaffoldMessenger.of(context).showSnackBar(        });      _wishlistItems.removeAt(index);    setState(() {    final item = _wishlistItems[index];  void _removeFromWishlist(int index) {  }    });      _wishlistItems.removeWhere((element) => element['name'] == item['name']);    setState(() {    // Remove from wishlist after adding to cart        );      ),        ),          },            Navigator.pop(context); // Go back to main app with cart tab          onPressed: () {          textColor: Colors.white,          label: 'VIEW CART',        action: SnackBarAction(        backgroundColor: Colors.green,        content: Text('${item['name']} added to cart!'),      SnackBar(    ScaffoldMessenger.of(context).showSnackBar(  void _addToCart(Map<String, dynamic> item) {  }    }        return Icons.shopping_bag;      default:        return Icons.checkroom;      case 'clothing':        return Icons.sports_basketball;      case 'footwear':        return Icons.devices;      case 'electronics':    switch (category.toLowerCase()) {  IconData _getCategoryIcon(String category) {  }    );      ),        ),          ),            ],              ),                ),                  ],                    ),                      ],                        ),                          tooltip: 'Remove from Wishlist',                          icon: const Icon(Icons.delete, color: Colors.red),                          onPressed: () => _removeFromWishlist(index),                        IconButton(                        const SizedBox(width: 8),                        ),                          ),                            ),                              style: const TextStyle(fontSize: 12),                              item['inStock'] ? 'Add to Cart' : 'Out of Stock',                            child: Text(                            ),                              ),                                borderRadius: BorderRadius.circular(8),                              shape: RoundedRectangleBorder(                              padding: const EdgeInsets.symmetric(vertical: 8),                              foregroundColor: Colors.white,                              backgroundColor: item['inStock'] ? Colors.orange : Colors.grey,                            style: ElevatedButton.styleFrom(                            onPressed: item['inStock'] ? () => _addToCart(item) : null,                          child: ElevatedButton(                        Expanded(                      children: [                    Row(                    // Action Buttons                                        const SizedBox(height: 12),                                        ),                      ],                        ),                          ),                            ),                              fontWeight: FontWeight.bold,                              color: Colors.green.shade700,                              fontSize: 10,                            style: TextStyle(                            '$discount% OFF',                          child: Text(                          ),                            borderRadius: BorderRadius.circular(4),                            color: Colors.green.shade100,                          decoration: BoxDecoration(                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),                        Container(                        const SizedBox(width: 8),                        ),                          ),                            decoration: TextDecoration.lineThrough,                            color: Colors.grey[500],                            fontSize: 12,                          style: TextStyle(                          '₹${item['originalPrice'].toStringAsFixed(0)}',                        Text(                        const SizedBox(width: 8),                        ),                          ),                            color: Colors.green,                            fontWeight: FontWeight.bold,                            fontSize: 16,                          style: const TextStyle(                          '₹${item['price'].toStringAsFixed(0)}',                        Text(                      children: [                    Row(                    // Price Section                                        const SizedBox(height: 8),                                        ),                      ],                        ),                          ),                            color: Colors.grey[600],\n            fontSize: 12,                          style: TextStyle(                          '(${item['rating']})',                        Text(                        const SizedBox(width: 8),                        )),                          color: Colors.amber,                          size: 16,                                  : Icons.star_border,                                  ? Icons.star_half                              : i < item['rating']                              ? Icons.star                          i < item['rating'].floor()                        ...List.generate(5, (i) => Icon(                      children: [                    Row(                    // Rating                                        const SizedBox(height: 8),                                        ),                      ),                        fontSize: 12,                        color: Colors.grey[600],                      style: TextStyle(                      item['category'],                    Text(                                        const SizedBox(height: 4),                                        ),                      overflow: TextOverflow.ellipsis,                      maxLines: 2,                      ),                        fontWeight: FontWeight.bold,                        fontSize: 16,                      style: const TextStyle(                      item['name'],                    Text(                  children: [                  crossAxisAlignment: CrossAxisAlignment.start,                child: Column(              Expanded(              // Product Details                            const SizedBox(width: 16),                            ),                ),                  color: Colors.blue,                  size: 40,                  _getCategoryIcon(item['category']),                child: Icon(                ),                  borderRadius: BorderRadius.circular(12),                  color: Colors.blue.shade50,                decoration: BoxDecoration(                height: 80,                width: 80,              Container(              // Product Image            children: [          child: Row(          padding: const EdgeInsets.all(16),        child: Padding(        ),          ),            end: Alignment.bottomRight,            begin: Alignment.topLeft,            colors: [Colors.white, Colors.grey.shade50],          gradient: LinearGradient(          borderRadius: BorderRadius.circular(16),        decoration: BoxDecoration(      child: Container(      ),        borderRadius: BorderRadius.circular(16),      shape: RoundedRectangleBorder(      elevation: 4,      margin: const EdgeInsets.only(bottom: 16),    return Card(        final discount = ((item['originalPrice'] - item['price']) / item['originalPrice'] * 100).round();  Widget _buildWishlistCard(Map<String, dynamic> item, int index) {  }    );      ),        ],          ),            ),              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),              'Browse Products',            child: const Text(            ),              ),                borderRadius: BorderRadius.circular(12),              shape: RoundedRectangleBorder(              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),              foregroundColor: Colors.white,              backgroundColor: Colors.blue,            style: ElevatedButton.styleFrom(            onPressed: () => Navigator.pop(context),          ElevatedButton(          const SizedBox(height: 32),          ),            textAlign: TextAlign.center,            ),              color: Colors.grey[500],              fontSize: 16,            style: TextStyle(            'Add products you love to your wishlist',          Text(          const SizedBox(height: 12),          ),            ),              color: Colors.grey[600],              fontWeight: FontWeight.bold,              fontSize: 24,            style: TextStyle(            'Your Wishlist is Empty',          Text(          const SizedBox(height: 24),          ),            color: Colors.grey[400],            size: 100,            Icons.favorite_border,          Icon(        children: [        mainAxisAlignment: MainAxisAlignment.center,      child: Column(    return Center(  Widget _buildEmptyState() {  }    );      ),              ),                },                  return _buildWishlistCard(item, index);                  final item = _wishlistItems[index];                itemBuilder: (context, index) {                itemCount: _wishlistItems.length,                padding: const EdgeInsets.all(16),            : ListView.builder(            ? _buildEmptyState()        child: _wishlistItems.isEmpty        ),          ),            colors: [Colors.blue.shade50, Colors.white],            end: Alignment.bottomCenter,            begin: Alignment.topCenter,          gradient: LinearGradient(        decoration: BoxDecoration(      body: Container(      ),        ],          ),            tooltip: 'Clear All',            icon: const Icon(Icons.clear_all),            onPressed: () => _clearWishlist(),          IconButton(        actions: [        elevation: 0,        title: Text('My Wishlist (${_wishlistItems.length})'),        foregroundColor: Colors.white,        backgroundColor: Colors.blue,      appBar: AppBar(    return Scaffold(  Widget build(BuildContext context) {  @override  ];    },      'inStock': false,      'category': 'Electronics',      'rating': 4.7,      'originalPrice': 7999.00,      'price': 5999.00,      'name': 'Smart Watch',    {    },      'inStock': true,      'category': 'Footwear',      'rating': 4.2,      'originalPrice': 2499.00,      'price': 1899.00,      'name': 'Running Shoes',    {    },      'inStock': true,      'category': 'Electronics',      'rating': 4.5,      'originalPrice': 3999.00,      'price': 2999.00,      'name': 'Wireless Headphones',    {  final List<Map<String, dynamic>> _wishlistItems = [class _WishlistPageState extends State<WishlistPage> {}  State<WishlistPage> createState() => _WishlistPageState();  @override  const WishlistPage({super.key});class WishlistPage extends StatefulWidget {class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<Map<String, dynamic>> _orders = [
    {
      'id': '#ORD001',
      'date': '2024-03-10',
      'status': 'Delivered',
      'total': 2599.00,
      'items': 3,
      'color': Colors.green,
    },
    {
      'id': '#ORD002',
      'date': '2024-03-08',
      'status': 'In Transit',
      'total': 1299.00,
      'items': 1,
      'color': Colors.blue,
    },
    {
      'id': '#ORD003',
      'date': '2024-03-05',
      'status': 'Processing',
      'total': 899.00,
      'items': 2,
      'color': Colors.orange,
    },
    {
      'id': '#ORD004',
      'date': '2024-02-28',
      'status': 'Cancelled',
      'total': 1599.00,
      'items': 1,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('My Orders'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: _orders.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return _buildOrderCard(order);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No Orders Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start shopping to see your orders here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Start Shopping',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order['id'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: order['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: order['color'],
                        width: 1,
                      ),
                    ),
                    child: Text(
                      order['status'],
                      style: TextStyle(
                        color: order['color'],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Order Details
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    order['date'],
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 24),
                  Icon(Icons.shopping_cart_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${order['items']} items',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Total Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ₹${order['total'].toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          _showOrderDetails(order);
                        },
                        child: const Text('View Details'),
                      ),
                      if (order['status'] != 'Cancelled')
                        TextButton(
                          onPressed: () {
                            _trackOrder(order);
                          },
                          child: const Text('Track Order'),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order ${order['id']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${order['status']}'),
            const SizedBox(height: 8),
            Text('Date: ${order['date']}'),
            const SizedBox(height: 8),
            Text('Items: ${order['items']}'),
            const SizedBox(height: 8),
            Text('Total: ₹${order['total'].toStringAsFixed(0)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _trackOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Tracking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tracking order ${order['id']}'),
            const SizedBox(height: 16),
            const Text('This feature will show real-time order tracking information.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}