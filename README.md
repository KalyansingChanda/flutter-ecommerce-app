# 🛒 Flutter E-Commerce App

A modern, feature-rich e-commerce application built with Flutter, inspired by Amazon and Flipkart's user interface and functionality.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)

## 🚀 Features

### 🔐 **Authentication System**
- **Login Screen** with email/password authentication
- **Signup Screen** with comprehensive form validation
- **Demo Login** functionality for testing
- **Password visibility toggle** for better UX
- **Terms & Conditions** acceptance

### 🛍️ **Shopping Experience**
- **Product Catalog** with multiple categories
  - Electronics
  - Fashion 
  - Home & Garden
- **Shopping Cart** with add/remove functionality
- **Real-time cart updates** and quantity management
- **Professional UI** inspired by Amazon/Flipkart

### 👤 **User Profile Management**
- **Profile Dropdown Menu** with all essential options
- **Orders Page** - Track your purchase history
- **Wishlist Page** - Save favorite items  
- **Rewards Page** - Loyalty program integration
- **Profile Settings** - Update account information

### 🎨 **Modern UI/UX Design**
- **Material Design 3** components
- **Responsive layouts** for all screen sizes
- **Professional color schemes** matching e-commerce standards
- **Smooth animations** and transitions
- **Clean, intuitive navigation**

### Order Tracking Statuses
1. **Order Placed** (ऑर्डर प्लेस किया गया)
2. **Order Packed** (ऑर्डर pack किया गया) 
3. **Order Shipped** (ऑर्डर ship किया गया)
4. **Out for Delivery** (डिलिवरी के लिए निकला)
5. **Delivered** (डिलिवर हो गया)

## 🛠️ Tech Stack

- **Frontend**: Flutter
- **Backend**: Firebase
- **Database**: Cloud Firestore (NoSQL)
- **Authentication**: Firebase Auth
- **Storage**: Firebase Storage
- **State Management**: Provider
- **UI**: Material Design

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── product.dart
│   ├── order.dart
│   └── cart_item.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── product_provider.dart
│   ├── cart_provider.dart
│   └── order_provider.dart
├── services/                 # Firebase services
│   ├── user_service.dart
│   ├── product_service.dart
│   └── order_service.dart
├── screens/                  # App screens
│   ├── splash_screen.dart
│   ├── auth/
│   │   └── login_screen.dart
│   └── home/
│       └── home_screen.dart
├── widgets/                  # Reusable widgets
│   └── product_card.dart
└── utils/                    # Constants & themes
    ├── constants.dart
    └── theme.dart
```

## 🔧 Setup Instructions

### 1. Prerequisites
- Flutter SDK installed (version 3.0.0+)
- VS Code with Flutter extension
- Firebase account
- Android Studio (for Android development)

### 2. Firebase Setup

#### Step 1: Create Firebase Project
1. [Firebase Console](https://console.firebase.google.com/) पर जाएं
2. "Create a project" click करें
3. Project name: `ecommerce-app` (या कोई भी नाम)
4. Google Analytics enable करें (optional)

#### Step 2: Add Android App
1. Firebase project में "Add app" click करें
2. Android icon select करें
3. Package name: `com.example.ecommerce_app`
4. `google-services.json` file download करें
5. इस file को `android/app/` folder में paste करें

#### Step 3: Enable Firebase Services
Firebase Console में जाकर निम्नलिखित services enable करें:

**Authentication:**
1. Authentication → Sign-in method
2. Email/Password enable करें
3. Google Sign-in enable करें

**Firestore Database:**
1. Firestore Database → Create database
2. Test mode में start करें
3. Location: asia-south1 (Mumbai) select करें

**Storage:**
1. Storage → Get started
2. Test mode में start करें

### 3. Install Dependencies

```bash
# Project folder में जाएं
cd E-Coommerce

# Dependencies install करें
flutter pub get
```

### 4. Run the App

```bash
# Android emulator या device connect करें
flutter run
```

## 🔥 Database Schema (Firestore)

### Users Collection
```javascript
{
  "uid": "user_unique_id",
  "name": "User Name",
  "email": "user@email.com", 
  "address": "Complete Address",
  "phone": "1234567890",
  "isAdmin": false,
  "createdAt": timestamp
}
```

### Products Collection
```javascript
{
  "id": "product_unique_id",
  "name": "Product Name",
  "price": 999.99,
  "description": "Product description",
  "imageUrl": "https://...",
  "category": "Electronics",
  "createdAt": timestamp
}
```

### Orders Collection
```javascript
{
  "orderId": "order_unique_id",
  "userId": "user_id",
  "items": [
    {
      "productId": "product_id",
      "productName": "Product Name",
      "price": 999.99,
      "quantity": 2,
      "imageUrl": "https://..."
    }
  ],
  "totalAmount": 1999.98,
  "address": "Delivery Address", 
  "status": 0, // 0-4 (Order status)
  "timestamp": timestamp
}
```

## 📱 Screen Flow

```
Splash Screen
    ↓
Login Screen (if not logged in)
    ↓
Home Screen → Product Catalog
    ↓
Cart Screen → Checkout
    ↓
Order Placed → Order Tracking
    ↓
Order History
```

## 🎨 UI Components

### Order Tracking Stepper
```dart
// Real-time order tracking with beautiful stepper UI
Stepper(
  currentStep: orderStatus.index,
  steps: [
    Step(title: Text('Order Placed')),
    Step(title: Text('Order Packed')), 
    Step(title: Text('Order Shipped')),
    Step(title: Text('Out for Delivery')),
    Step(title: Text('Delivered')),
  ],
)
```

## 🚀 Build APK

```bash
# Release APK build करने के लिए
flutter build apk --release

# APK file यहाँ मिलेगी:
# build/app/outputs/flutter-apk/app-release.apk
```

## 🔐 Security Rules

Firestore Security Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Products: Anyone can read, only admins can write
    match /products/{document} {
      allow read: if true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Orders: Users can read their own orders, admins can read all
    match /orders/{orderId} {
      allow read, create: if request.auth != null;
      allow update: if request.auth != null && 
        (resource.data.userId == request.auth.uid || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true);
    }
  }
}
```

## 🎯 Next Steps

1. **Firebase Configuration**: `google-services.json` को actual Firebase project की file से replace करें
2. **Admin Panel**: Admin dashboard screens बनाएं
3. **Payment Gateway**: Razorpay या Stripe integration करें
4. **Push Notifications**: Order updates के लिए notifications add करें
5. **Search**: Advanced search और filtering features
6. **Categories**: Product categories और filtering

## 🆘 Troubleshooting

### Common Issues:

1. **Firebase not connecting**: `google-services.json` file check करें
2. **Build errors**: `flutter clean` और `flutter pub get` run करें
3. **Auth issues**: Firebase Console में authentication methods enable करें
4. **Firestore permission denied**: Security rules check करें

### Debug Commands:
```bash
flutter doctor          # Flutter setup check करें
flutter clean          # Build cache clean करें
flutter pub get        # Dependencies refresh करें
flutter run --verbose  # Detailed logs के साथ run करें
```

## 📞 Support

कोई भी problem हो तो GitHub issues में पूछ सकते हैं या documentation देखें:

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Documentation](https://pub.dev/packages/provider)

---

**Happy Coding! 🚀✨**

Made with ❤️ in Flutter & Firebase