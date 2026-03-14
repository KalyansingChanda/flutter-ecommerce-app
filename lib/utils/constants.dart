class AppConstants {
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String categoriesCollection = 'categories';

  // Order Status Messages
  static const Map<int, String> orderStatusMessages = {
    0: 'Your order has been placed',
    1: 'Your order is being packed',
    2: 'Your order has been shipped',
    3: 'Your order is out for delivery',
    4: 'Your order has been delivered',
  };

  // App Strings
  static const String appName = 'E-Commerce App';
  static const String welcomeMessage = 'Welcome!';
  static const String loginPrompt = 'Please login';
  
  // Product Categories
  static const List<String> categories = [
    'Electronics',
    'Fashion',
    'Home & Kitchen',
    'Books',
    'Sports',
    'Beauty',
    'Toys',
    'Others',
  ];

  // Error Messages
  static const String networkError = 'Check internet connection';
  static const String unknownError = 'Something went wrong';
  static const String loginRequired = 'Please login first';
}