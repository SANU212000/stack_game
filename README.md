# Stack Tower Game 🎮

A fully-featured Flutter implementation of the Stack Tower game using **MVVM architecture** with clean code principles, SOLID design patterns, and production-ready standards.

## 🎯 Game Overview

Stack Tower is a precision-based stacking game where:
- Blocks slide horizontally across the screen
- Tap to drop the block at the right moment
- Misaligned blocks get trimmed, making the next block smaller
- Build the tallest tower possible!
- Score increases with each successfully placed block
- Game ends when a block becomes too small

## 🏗️ Architecture

This project follows a clean **MVVM (Model-View-ViewModel)** architecture:

```
lib/
  core/
    constants/     # App-wide constants
    utils/         # Extension methods and utilities
    di/            # Dependency injection setup
  features/
    stack_tower/
      model/       # Data models (BlockModel, GameStateModel, AnimationModel)
      viewmodel/   # Business logic (StackTowerViewModel)
      view/         # UI screens (StackTowerScreen)
      widgets/      # Reusable UI components
      services/     # Storage and external services
```

### Key Design Decisions

1. **State Management**: Uses `ChangeNotifier` with `Provider`
   - Lightweight, built-in Flutter solution
   - Easy to test and mock
   - Can be swapped to Riverpod/Bloc if needed via adapter pattern

2. **Dependency Injection**: Uses `GetIt`
   - Simple, efficient DI without widget tree dependencies
   - Better for MVVM where ViewModels are pure Dart classes
   - Easy testing with mock registration

3. **Rendering**: Uses `CustomPainter` for tower area
   - Optimal performance for 60fps animations
   - Smooth block movement and rendering
   - Efficient repaint logic

## 📦 Dependencies

- `provider: ^6.1.1` - State management
- `get_it: ^7.7.0` - Dependency injection
- `shared_preferences: ^2.2.2` - Local storage for high scores

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository** (or navigate to project directory)

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

### Running on Specific Platforms

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# Desktop (Windows/Mac/Linux)
flutter run -d windows  # or macos/linux
```

## 🧪 Testing

Run unit tests:

```bash
flutter test
```

The test suite includes:
- Game initialization tests
- Block movement tests
- Alignment and trimming logic tests
- Score calculation tests
- High score persistence tests
- Game over condition tests

## 🎮 How to Play

1. **Start Game**: Tap "Start Game" on the initial screen
2. **Watch the Block**: A block slides horizontally across the tower area
3. **Drop the Block**: Tap anywhere on the screen to drop the block
4. **Align Perfectly**: Try to align the block perfectly with the one below
5. **Build Higher**: Each successful placement increases your score
6. **Avoid Misalignment**: Misaligned blocks get trimmed, making the next block smaller
7. **Game Over**: Game ends when a block becomes too small to place

## 📁 Project Structure Details

### Models (`lib/features/stack_tower/model/`)

- **BlockModel**: Represents a single block with position, size, and color
- **GameStateModel**: Tracks score, best score, and game status
- **AnimationModel**: Manages animation configurations

### ViewModel (`lib/features/stack_tower/viewmodel/`)

- **StackTowerViewModel**: Contains ALL game logic
  - Horizontal movement calculation
  - Tap-to-drop handling
  - Alignment and trimming algorithm
  - Score updates
  - High score persistence
  - Game over conditions
  - **NO UI code** - pure business logic

### Views & Widgets (`lib/features/stack_tower/view/` & `widgets/`)

- **StackTowerScreen**: Main game screen
- **TowerArea**: Custom painter for rendering blocks
- **ScoreBoard**: Displays current and best score
- **GameOverCard**: Modal shown when game ends
- **RestartButton**: Button to restart the game
- **BlockWidget**: Individual block rendering (used in alternative rendering)

### Services (`lib/features/stack_tower/services/`)

- **StorageService**: Handles persistent storage using SharedPreferences

### Core (`lib/core/`)

- **Constants**: App-wide constants (colors, sizes, durations)
- **Utils**: Extension methods for common operations
- **DI**: Dependency injection setup

## 🔧 Key Features

✅ **Smooth 60fps animations**  
✅ **Local high score persistence**  
✅ **Responsive UI for all screen sizes**  
✅ **Clean MVVM architecture**  
✅ **Comprehensive unit tests**  
✅ **Production-ready code quality**  
✅ **SOLID principles**  
✅ **Modular folder structure**  
✅ **Dependency injection**  
✅ **Extensible design**

## 🎨 Customization

### Adjusting Game Difficulty

Edit `lib/core/constants/app_constants.dart`:

```dart
static const double blockSpeed = 2.0;        // Increase for faster movement
static const double minBlockWidth = 20.0;    // Decrease for easier game
static const double initialBlockWidth = 200.0; // Adjust starting width
```

### Changing Colors

Modify color constants in `app_constants.dart`:

```dart
static const int primaryColorValue = 0xFF2196F3; // Change to your color
```

### Animation Speed

Adjust animation durations:

```dart
static const int dropAnimationDuration = 300; // Milliseconds
```

## 🚀 Future Enhancements (TODO)

The codebase includes TODO notes for potential improvements:

1. **Sound Effects**: Add audio feedback for block placement
2. **Particle Effects**: Visual effects when blocks are trimmed
3. **Difficulty Levels**: Easy, Medium, Hard modes
4. **Power-ups**: Special blocks with unique abilities
5. **Multiplayer**: Compete with friends
6. **Achievements**: Unlock achievements for milestones
7. **Leaderboards**: Global high score tracking
8. **Themes**: Multiple color themes
9. **Haptic Feedback**: Vibration on block placement
10. **Analytics**: Track gameplay statistics

## 🏆 Performance Optimizations

- CustomPainter with efficient repaint logic
- Timer-based movement (60fps) instead of animation controller
- Unmodifiable lists for placed blocks
- Minimal widget rebuilds using Consumer pattern
- Efficient alignment calculation algorithm

## 📝 Code Quality

- ✅ Follows Flutter best practices
- ✅ Comprehensive comments explaining complex logic
- ✅ SOLID principles throughout
- ✅ Separation of concerns (UI vs Logic)
- ✅ Immutable models where possible
- ✅ Extension methods for utilities
- ✅ Type-safe code with null safety

## 🤝 Contributing

This is a production-ready template. Feel free to:
- Add new features
- Improve performance
- Enhance UI/UX
- Add more tests
- Refactor for scalability

## 📄 License

This project is created for educational and demonstration purposes.

## 👨‍💻 Author

Built with ❤️ using Flutter and MVVM architecture principles.

---

**Enjoy building your tower! 🏗️**
