# RevoltronX Yoga App

A beautifully designed Flutter application that delivers guided yoga sessions with synchronized audio instructions and visual pose guides. Built for the RevoltronX internship assignment, this app provides an immersive wellness experience focused on spinal mobility and mindful movement.

## 🧘‍♀️ Features

- **Guided Yoga Sessions**: Interactive yoga flows with professional audio narration
- **Visual Pose Guides**: Real-time pose demonstrations with synchronized imagery
- **Audio Synchronization**: Precisely timed audio cues for breathing and movement
- **Dark Mode UI**: Elegant dark theme optimized for relaxation and focus
- **Responsive Design**: Works seamlessly across mobile devices
- **Modular Architecture**: Clean separation of concerns with Provider state management

## 🎯 Current Session: Cat-Cow Flow

The app currently features a complete Cat-Cow sequence designed for spinal mobility:

- **Duration**: Configurable 4-cycle flow (approximately 3-4 minutes)
- **Focus**: Spinal articulation, breath awareness, and mindful movement
- **Audio**: Professional narration with intro, loop, and outro segments
- **Visuals**: Three distinct pose images (Base, Cat, Cow positions)
- **Tempo**: Slow, meditative pace synchronized with breathing

## 🏗️ Technical Architecture

### Core Technologies
- **Flutter**: Cross-platform mobile development framework
- **Provider**: State management for session data and UI updates
- **AudioPlayers**: High-performance audio playback from assets
- **Google Fonts**: Custom typography with Inter font family
- **Shared Preferences**: Local storage for user progress and streaks

### Project Structure
```
lib/
├── main.dart                 # App initialization and routing
├── models/
│   └── session_model.dart   # Data models for yoga sessions
├── providers/
│   ├── session_provider.dart    # Business logic and state management
│   └── screens/
│       ├── pose_preview_screen.dart   # Pre-session preview
│       └── session_screen.dart        # Active session interface
```

### Data Models
- **YogaSession**: Complete session configuration
- **SequenceItem**: Individual flow segments (intro, loop, outro)
- **ScriptItem**: Timed narration with visual cues
- **Assets**: Centralized image and audio references

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / Xcode / VS Code

### Installation
1. Clone the repository:
   ```bash
   git clone [repository-url]
   cd revoltronx_yoga_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

### Building for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📱 Usage

1. **Launch the app** to see the welcome screen
2. **Tap "Start"** to begin the Cat-Cow flow session
3. **Follow along** with audio instructions and visual pose guides
4. **Complete the flow** with the guided outro sequence

## 🎨 Design System

- **Primary Color**: Deep Purple (#8A3FFC)
- **Secondary Color**: Teal (#03DAC5)
- **Background**: Dark theme (#121212)
- **Typography**: Inter font family for modern readability
- **Icons**: Material Design with custom styling

## 🔧 Configuration

### Session Configuration
Located in `assets/json/script.json`, sessions can be customized by modifying:
- Audio file references
- Image assets
- Timing and duration
- Loop counts and iterations
- Narration scripts

### Asset Management
- **Images**: PNG format, optimized for mobile screens
- **Audio**: MP3 format, professionally recorded
- **JSON**: Structured session configuration

## 🤝 Contributing

This project was developed as part of the RevoltronX internship assignment. For contributions or questions, please contact the development team.

## 📄 License

This project is proprietary software developed for RevoltronX. All rights reserved.

## 🙏 Acknowledgments

- Built with Flutter and Google's Material Design
- Audio production and yoga instruction by the RevoltronX team
- Special thanks to the internship program coordinators
