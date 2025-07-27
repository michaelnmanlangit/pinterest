# pinterest

# 📌 Pinterest Clone - Flutter App

A complete Pinterest clone built with Flutter, featuring the latest 2025 mobile app design with all the core functionalities of Pinterest.

## ✨ Features

### 🏠 **Home Feed**
- Masonry grid layout (Pinterest-style staggered grid)
- Category-based filtering (Home Decor, Food, Fashion, Travel, etc.)
- Pull-to-refresh functionality
- Responsive design for all screen sizes
- Infinite scroll capability

### 🔍 **Search & Discovery**
- Real-time search with autocomplete
- Category browsing with gradient tiles
- Advanced filtering options
- Search history and suggestions

### 👤 **User Profile**
- Personal profile with avatar and stats
- Saved pins collection
- Created pins management
- Settings and preferences
- Follow/following system

### 📌 **Pin Management**
- Like/unlike pins with heart animation
- Save/unsave pins with bookmark feature
- Pin detail view with zoom capability
- Related pins suggestions
- Share functionality

### 📋 **Boards System**
- Create and manage boards
- Organize pins into collections
- Secret boards support
- Board detail views with statistics

## 🎨 Design Highlights

- **2025 Modern UI**: Latest Pinterest mobile app aesthetics
- **Material Design 3**: Modern Android design language
- **Responsive Layout**: Adapts to mobile, tablet, and desktop
- **Smooth Animations**: Engaging micro-interactions
- **Custom Components**: Pinterest-style widgets
- **Dark Mode Ready**: Prepared for theme switching

## 🚀 Technology Stack

- **Framework**: Flutter 3.8.1+
- **State Management**: Provider pattern
- **UI Components**: Material Design 3
- **Image Loading**: Network images with caching
- **Data Storage**: JSON-based (no database required)
- **Fonts**: Google Fonts (Inter)
- **Architecture**: Clean, scalable MVVM pattern

## 📱 Platform Support

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)
- ✅ Web (Progressive Web App)
- ✅ Desktop (Windows, macOS, Linux)

## 🛠️ Installation & Setup

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Android SDK (for Android builds)
- Xcode (for iOS builds - macOS only)

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd pinterest
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  flutter_staggered_grid_view: ^0.7.0  # Pinterest-style grid
  google_fonts: ^6.1.0                 # Beautiful typography
  provider: ^6.1.1                     # State management
  shared_preferences: ^2.2.2           # Local storage
```

## 📂 Project Structure

```
lib/
├── models/           # Data models (Pin, User, Board)
├── providers/        # State management
├── screens/          # App screens
├── services/         # Data services
├── utils/           # Utilities (responsive helper)
├── widgets/         # Reusable components
└── main.dart        # App entry point

assets/
├── data/            # JSON data files
└── images/          # App images
```

## 🎯 Key Features Demo

### Home Screen
- Staggered grid with various pin sizes
- Category chips for filtering
- Smooth scrolling with loading states
- Responsive design across devices

### Search Screen
- Instant search with results
- Category exploration tiles
- Search history and suggestions
- Advanced filtering options

### Profile Screen
- User statistics and information
- Saved pins collection
- Created pins management
- Settings and preferences

### Pin Detail Screen
- Full-size pin view with zoom
- Pin information and stats
- Related pins suggestions
- Like, save, and share actions

## 🌟 Sample Data

The app includes rich sample data:
- **10+ diverse pins** across multiple categories
- **User profiles** with avatars and statistics
- **Board collections** with cover images
- **High-quality images** from Unsplash
- **Realistic interactions** and engagement data

## 🎨 Responsive Design

The app automatically adapts to different screen sizes:

- **Mobile (< 600px)**: 2-column grid
- **Tablet (600-900px)**: 3-column grid
- **Desktop (900px+)**: 4-5 column grid
- **Dynamic spacing**: Adjusts padding based on screen size
- **Touch-friendly**: Optimized for touch interactions

## 🔧 Performance Optimizations

- **Image Loading**: Optimized network image loading
- **Memory Management**: Proper widget disposal
- **Lazy Loading**: Load content as needed
- **Smooth Animations**: 60fps animations
- **State Management**: Efficient state updates

## 📱 Platform-Specific Features

### Android
- Material Design 3 components
- Edge-to-edge display support
- System navigation gestures
- Adaptive icons and splash screens

### iOS
- Cupertino design elements
- Safe area handling
- iOS-specific navigation patterns
- App Store compliance

### Web
- Progressive Web App capabilities
- Responsive web design
- SEO optimization
- Browser compatibility

## 🚀 Getting Started

1. **Launch**: App opens with Pinterest-style splash screen
2. **Explore**: Browse pins in the main feed
3. **Search**: Find specific content or explore categories
4. **Interact**: Like, save, and view pin details
5. **Profile**: Check your saved pins and profile

## 🎯 Future Enhancements

- [ ] Real-time notifications
- [ ] User authentication
- [ ] Create new pins
- [ ] Advanced board management
- [ ] Social features (comments, messages)
- [ ] Offline mode support
- [ ] Push notifications
- [ ] Analytics integration

## 📄 License

This project is for educational and demonstration purposes.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

**Built with ❤️ using Flutter**

*Experience the Pinterest you love with modern Flutter technology!*
