# WeMeet 💜🦋

A vibrant Flutter-based mobile application that connects K-pop enthusiasts and community members through real-time chat, events, and social posts. Build meaningful connections with friends, discover your favorite groups, and stay updated with community activities.

---

## 🌟 Features

### Authentication & User Management
- **Email/Password Authentication**: Secure user registration and login via Firebase Authentication
- **Google Sign-In Integration**: Quick and easy authentication using Google accounts
- **User Profiles**: Customizable profile with display name and profile picture
- **Profile Picture Upload**: Upload and store profile pictures using Cloudinary CDN

### Community Features
- **Create Communities**: Users can establish their own communities around interests
- **Join Communities**: Browse and join existing communities
- **Community Management**: View created and joined communities
- **Community Feed**: See activities from communities you're part of

### Real-Time Chat
- **Chat Rooms**: Community-based chat rooms for group conversations
- **Message Features**:
  - Text messages with real-time delivery
  - Image sharing within chats
  - Message reactions (❤️, 😂, 😢, 😡, ⭐)
  - Reply functionality
  - Message deletion
- **Cloud Storage**: Chat data persisted in Cloud Firestore
- **Message History**: Access previous conversations

### Posts & Community Feed
- **Create Posts**: Share rich content including text and images
- **Post Management**: Edit, delete, and manage your posts
- **Image Uploads**: Multi-image upload support with Cloudinary integration
- **Post Privacy Options**:
  - Control comment permissions
  - Hide/show like counts
  - Customize post visibility

### Events
- **Create Events**: Community organizers can create events with details and cover images
- **Live & Upcoming Events**: Browse and discover events by date
- **Event Details**: View comprehensive event information including date, community, and description
- **Event Notifications**: Automatic notifications to community members when new events are created
- **Date Filtering**: Auto-archiving of past events

### Notifications
- **Real-Time Alerts**: Instant notifications for community activities
- **Notification Types**:
  - New posts in communities
  - Event announcements
  - Chat messages
  - Community invitations
- **Notification Management**: Mark as read, dismiss, and organize notifications
- **Notification History**: View all past notifications

### UI/UX Enhancements
- **Dark/Light Theme Support**: Toggle between dark and light themes with preference persistence
- **Animations**: Smooth Lottie animations for empty states
- **Custom Navigation**: Curved bottom navigation bar for easy access to main features
- **Responsive Design**: Optimized for various screen sizes
- **Custom Fonts**: Beautiful typography with Pacifico, Dancing Script, and Lobster fonts

### Connectivity
- **Offline Detection**: Network connectivity monitoring with offline screen
- **Graceful Degradation**: Handles no internet scenarios elegantly

---

## 📱 Tech Stack

### Frontend
- **Framework**: Flutter 3.6.2+
- **Language**: Dart 3.6.2+
- **State Management**: Provider 6.1.2
- **UI Components**:
  - Curved Navigation Bar
  - Lottie Animations
  - Font Awesome Icons
  - Google Fonts
  - Image Picker
  - Emoji Picker

### Backend & Services
- **Firebase Suite**:
  - Firebase Core 3.12.0
  - Firebase Authentication 5.5.0
  - Cloud Firestore 5.6.4
  - Firebase Storage 12.4.3
  - Google Sign-In 6.2.2

### Media & Storage
- **Cloudinary Integration**:
  - Cloudinary SDK 5.0.0
  - Cloudinary URL Generator 1.7.0
  - Cloudinary Flutter 1.3.0
- **Image Management**: Image Picker 1.1.2
- **GIF Integration**: Giphy Picker 3.0.2

### Additional Libraries
- **HTTP Client**: http 1.3.0
- **URL Launcher**: url_launcher 6.3.1
- **Carousel**: carousel_slider 5.0.0
- **Connectivity**: connectivity_plus 6.1.3
- **Date/Time**: intl 0.20.2
- **Reactive**: rxdart 0.28.0
- **Code Highlighting**: flutter_highlight 0.7.0
- **Navigation**: get 4.7.2
- **Persistent Storage**: shared_preferences 2.5.2
- **Notifications**: fluttertoast 8.2.12

---

## 🏗️ Project Structure

```
lib/
├── main.dart                      # App entry point with Firebase initialization
├── onboarding_screen.dart         # Welcome/onboarding flow
├── login_signup_screen.dart       # Authentication screens
├── home_screen.dart               # Main home/dashboard
├── community_page.dart            # Community details and management
├── join_community_screen.dart     # Browse and join communities
├── create_community.dart          # Create new communities
├── chat_list_screen.dart          # List of chat rooms
├── chat_room_screen.dart          # Real-time chat interface
├── create_post_page.dart          # Create community posts
├── event_list.dart                # List of events
├── event_details.dart             # Event information display
├── create_event.dart              # Create new events
├── notification_screen.dart       # Notification center
├── notification_service.dart      # Notification business logic
├── notification_model.dart        # Notification data model
├── dashboard_screen.dart          # User profile management
├── theme_provider.dart            # Theme management (Light/Dark)
├── network_service.dart           # Network connectivity service
├── no_network_screen.dart         # Offline UI
├── firestore_service.dart         # Firestore utilities wrapper
├── gif_picker.dart                # GIF selection UI
├── clipper.dart                   # Custom UI shapes

assets/                           # App assets
├── images/
│   ├── logo.png
│   ├── bg.png
│   ├── image1-3.png (onboarding)
│   ├── google_logo.png
│   ├── default_avatar.png
│   └── icons/
├── animations/ (Lottie JSON)
│   ├── no_network.json
│   ├── empty.json
│   ├── no_join.json
│   ├── no_post.json
│   ├── no_events.json
│   └── no_chat.json
└── fonts/
    ├── Pacifico-Regular.ttf
    ├── DancingScript-Regular.ttf
    └── Lobster-Regular.ttf

android/                          # Android-specific configuration
ios/                              # iOS-specific configuration
web/                              # Web platform support
linux/                            # Linux platform support
macos/                            # macOS platform support
```

---

## 🔐 Security & Authentication

### Authentication Methods
1. **Email/Password Authentication**
   - Firebase Authentication handles password hashing and security
   - Passwords are never stored in the app
   - Password reset via email recovery

2. **Google Sign-In**
   - OAuth 2.0 protocol
   - Secure credential exchange
   - No password stored locally

3. **Firestore Security Rules**
   - User data isolation - users can only access their own data
   - Community member verification for chat and post access
   - Event creator validation for modifications

### Data Protection
- **Cloud Firestore**: All data encrypted in transit and at rest
- **Firebase Storage**: Secure image and media storage with access control
- **Cloudinary**: Third-party CDN for media with API key-based authentication
- **SharedPreferences**: Local theme preferences stored securely

### Environment & Configuration
- **API Keys Management**: Cloudinary API credentials configured in code (consider environment variables for production)
- **Firebase Configuration**: Handled automatically via Google Services JSON (Android) and GoogleService-Info.plist (iOS)

### Best Practices Implemented
- ✅ No sensitive data in logs
- ✅ HTTPS/TLS for all network communications
- ✅ User session management via Firebase
- ✅ Permission handling for camera, photo gallery, and storage access
- ✅ Input validation for text fields and file uploads

---

## 📋 Requirements

### Development Environment
- **Flutter SDK**: 3.6.2 or higher
- **Dart SDK**: 3.6.2 or higher
- **Android Studio** or **Xcode** (for iOS development)
- **Git**: Version control

### Minimum Platform Versions
- **Android**: API Level 21 (Android 5.0) and above
- **iOS**: iOS 12.0 and above
- **Web**: Chrome, Firefox, Safari, Edge (latest versions)
- **macOS**: macOS 10.14 and above
- **Linux**: Ubuntu 18.04 LTS and above

### External Services Required
- **Firebase Project**: Create at [Firebase Console](https://console.firebase.google.com)
- **Cloudinary Account**: Sign up at [Cloudinary](https://cloudinary.com) for image hosting
- **Google Cloud Project**: For Google Sign-In OAuth credentials

---

## 🚀 Getting Started

### Prerequisites
Before running the application, ensure you have:
- Flutter installed and configured
- A Firebase project set up
- Cloudinary account credentials
- Google OAuth 2.0 credentials (for Google Sign-In)

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/SnahaSree/WeMeet.git
   cd WeMeet
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   flutter pub upgrade
   ```

3. **Configure Firebase**
   - Create a Firebase project at [firebase.google.com](https://firebase.google.com)
   - Download `google-services.json` (Android) and place in `android/app/`
   - Download `GoogleService-Info.plist` (iOS) and add to Xcode project
   - Enable Authentication methods:
     - Email/Password
     - Google Sign-In
   - Create Firestore Database (Production mode, starting rules at `firestore.rules`)
   - Enable Storage for file uploads

4. **Configure Cloudinary**
   - Sign up at [Cloudinary](https://cloudinary.com)
   - Replace these values in the code:
     - `apiKey`: Your Cloudinary API Key
     - `apiSecret`: Your Cloudinary API Secret  
     - `cloudName`: Your Cloudinary Cloud Name
   - **Note**: For production, use environment variables or secure backend endpoints instead of hardcoding secrets

5. **Configure Google Sign-In**
   - Set up OAuth 2.0 credentials in Google Cloud Console
   - Configure for both Android and iOS platforms

6. **Run the Application**
   ```bash
   # For development
   flutter run

   # For specific platform
   flutter run -d android     # Android device
   flutter run -d ios         # iOS device
   flutter run -d chrome      # Web browser
   ```

---

## 📦 Configuration Files

### pubspec.yaml
```yaml
version: 1.0.0+1
environment:
  sdk: ^3.6.2

# Key dependencies included:
- flutter_native_splash: Native splash screens
- firebase_core & firebase_auth: Backend authentication
- cloud_firestore: Real-time database
- cloudinary_flutter: Image hosting
- provider: State management
- connectivity_plus: Network monitoring
```

### analysis_options.yaml
- Flutter lints enabled for code quality
- Dart code analysis configured
- Following Flutter best practices

### .gitignore
- Flutter build artifacts
- Android build outputs
- iOS CocoaPods dependencies
- IDE configurations
- API credentials

---

## 🏗️ Architecture

### State Management Pattern
- **Provider Pattern**: Used for managing app-wide state (ThemeProvider, NetworkController)
- **StreamBuilder**: Used for real-time Firebase data
- **FutureBuilder**: Used for one-time data fetches

### Data Flow
```
UI Widgets → State Management (Provider) → Services (Firebase, Cloudinary)
↓
Cloud Storage (Firestore, Firebase Storage, Cloudinary)
↓
Real-time Updates (StreamBuilder)
```

### Key Architectural Principles
- Separation of concerns (UI, business logic, data)
- Service layer abstraction
- Reusable components
- Responsive design patterns

---

## 🎯 Core Features Explained

### User Authentication Flow
1. User enters email and password or uses Google Sign-In
2. Firebase authenticates and creates user session
3. User profile stored in Firestore
4. Profile picture uploaded to Cloudinary
5. User redirected to home screen

### Community Chat Workflow
1. User joins a community
2. Views list of chat rooms
3. Selects a room to enter
4. Messages streamed from Firestore in real-time
5. Can send text, images, add reactions
6. Chat history persisted indefinitely

### Event Creation & Notification Flow
1. Community admin creates event with details
2. Event image uploaded to Cloudinary
3. Event stored in Firestore
4. Automatic notification sent to all community members
5. Event appears in "Live & Upcoming Events" list
6. Past events auto-archived

---

## 🧪 Testing

### Running Tests
```bash
flutter test
```

### Widget Tests
```bash
# Run specific test file
flutter test test/widget_test.dart
```

### Manual Testing Checklist
- [ ] Authentication (Email & Google)
- [ ] Community creation and joining
- [ ] Chat messaging and reactions
- [ ] Image uploads (posts, events, profiles)
- [ ] Event creation and notifications
- [ ] Dark/Light theme toggle
- [ ] Offline mode detection
- [ ] Notification management

---

## 📚 Code Quality & Standards

### Analysis
```bash
flutter analyze
```

### Code Standards
- Follows Dart/Flutter official guidelines
- lint rules configured in `analysis_options.yaml`
- Naming conventions: camelCase for variables/methods, PascalCase for classes
- Documentation comments for public APIs

### Common Issues & Solutions
- **API Key Exposure**: Never commit API keys to version control
- **Cloudinary Integration**: Ensure proper folder paths in configuration
- **Firestore Permissions**: Check security rules if data not loading
- **Image Upload Failures**: Verify Cloudinary credentials and network

---

## 🚢 Deployment

### Android Build
```bash
flutter build apk
flutter build appbundle  # For Play Store
```

### iOS Build
```bash
flutter build ios
# Then use Xcode for signing and deployment
```

### Web Build
```bash
flutter build web
```

### Pre-Deployment Checklist
- [ ] Remove debug mode
- [ ] Update app version in pubspec.yaml
- [ ] Test on multiple devices
- [ ] Verify Firebase rules in production
- [ ] Secure API credentials (use environment variables)
- [ ] Enable appropriate privacy policies
- [ ] Test all authentication methods
- [ ] Check notification permissions

---

## 🐛 Known Issues & Improvements

### Current Limitations
- Some duplicate code in services (marked with TODO comments)
- Tenor API key needs configuration for GIF picker
- Jitsi Meet integration commented out (ready for video calling)
- Some hardcoded Cloudinary credentials

### Future Enhancements
- [ ] Video calling support via Jitsi Meet
- [ ] Direct messaging (one-to-one chats)
- [ ] User search and discovery
- [ ] Advanced event filters and calendar
- [ ] Post editing and history
- [ ] User blocking and reports
- [ ] Rich text formatting for posts
- [ ] Push notifications (FCM)
- [ ] Message encryption
- [ ] Offline message queue
- [ ] Advanced analytics

---

## 📞 Support & Contact

For issues, questions, or feature requests:
- **GitHub Issues**: [Create an issue](https://github.com/SnahaSree/WeMeet/issues)
- **Developer**: [@SnahaSree](https://github.com/SnahaSree)

---

## 📄 License

This project is open source. Ensure appropriate licensing is added.

---

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **Firebase** - For backend services
- **Cloudinary** - For media management
- **Community Contributors** - For support and feedback

---

## 🔗 Useful Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Cloudinary Docs](https://cloudinary.com/documentation)
- [Dart Language Guide](https://dart.dev/guides)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security)

---

**Made with 💜 by the WeMeet Community**

Connect, Share, and Celebrate Together! 🦋✨
