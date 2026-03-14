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
1. **Order Placed** 
2. **Order Packed** 
3. **Order Shipped** 
4. **Out for Delivery** 
5. **Delivered**

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
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Project name: `ecommerce-app` (or any name you prefer)
4. Enable Google Analytics (optional)

#### Step 2: Add Android App
1. Click "Add app" in Firebase project
2. Select Android icon
3. Package name: `com.example.ecommerce_app`
4. Download `google-services.json` file
5. Paste this file in `android/app/` folder

#### Step 3: Enable Firebase Services
Go to Firebase Console and enable the following services:

**Authentication:**
1. Authentication → Sign-in method
2. Enable Email/Password
3. Enable Google Sign-in

**Firestore Database:**
1. Firestore Database → Create database
2. Start in test mode
3. Select Location: asia-south1 (Mumbai)

**Storage:**
1. Storage → Get started
2. Start in test mode

### 3. Install Dependencies

```bash
# Go to project folder
cd E-Coommerce

# Install dependencies
flutter pub get
```

### 4. Run the App

```bash
# Connect Android emulator or device
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
# To build release APK
flutter build apk --release

# APK file will be available at:
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

1. **Firebase Configuration**: Replace `google-services.json` with actual Firebase project file
2. **Admin Panel**: Create admin dashboard screens
3. **Payment Gateway**: Integrate Razorpay or Stripe
4. **Push Notifications**: Add notifications for order updates
5. **Search**: Advanced search and filtering features
6. **Categories**: Product categories and filtering

## 🆘 Troubleshooting

### Common Issues:

1. **Firebase not connecting**: Check `google-services.json` file
2. **Build errors**: Run `flutter clean` and `flutter pub get`
3. **Auth issues**: Enable authentication methods in Firebase Console
4. **Firestore permission denied**: Check security rules

### Debug Commands:
```bash
flutter doctor          # Check Flutter setup
flutter clean          # Clean build cache
flutter pub get        # Refresh dependencies
flutter run --verbose  # Run with detailed logs
```

## 📞 Support

For any problems, you can ask in GitHub issues or check the documentation:

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Documentation](https://pub.dev/packages/provider)

---

**Happy Coding! 🚀✨**

Made with ❤️ in Flutter & Firebase