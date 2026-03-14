class AppConstants {
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String categoriesCollection = 'categories';

  // Order Status Messages
  static const Map<int, String> orderStatusMessages = {
    0: 'तुमचा ऑर्डर प्लेस झाला आहे',
    1: 'तुमचा ऑर्डर पैक केला जात आहे',
    2: 'तुमचा ऑर्डर शिप केला गेला आहे',
    3: 'तुमचा ऑर्डर डिलिव्हरीसाठी निघाला आहे',
    4: 'तुमचा ऑर्डर डिलिव्हर झाला आहे',
  };

  // App Strings
  static const String appName = 'E-Commerce App';
  static const String welcomeMessage = 'स्वागत आहे!';
  static const String loginPrompt = 'कृपया लॉगिन करा';
  
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
  static const String networkError = 'इंटरनेट कनेक्शन चेक करा';
  static const String unknownError = 'काहीतरी चूक झाली आहे';
  static const String loginRequired = 'कृपया पहिले लॉगिन करा';
}