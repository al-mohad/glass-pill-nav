# Glass Pill Nav 🧪✨

A premium, state-of-the-art glassmorphic floating pill navigation bar for Flutter. Now featuring an **Elite GPU-accelerated Liquid Glass variant** and professional-grade modular architecture.

![Glass Pill Nav Standard](https://raw.githubusercontent.com/yourusername/glass_pill_nav/main/screenshots/standard.png)

_Elite Liquid Variant:_
![Glass Pill Nav Liquid](https://raw.githubusercontent.com/yourusername/glass_pill_nav/main/screenshots/standard.png)

## 🌟 Key Features

- 🧪 **Elite Liquid Variant**: Organic, GPU-accelerated GLSL fragment shaders for a "melting glass" effect.
- ✨ **Supreme Glassmorphism**: High-performance backdrop filters with custom sheen and inner rim highlights.
- 🏗️ **Modular API**: Clean separation of concerns with `GlassPillNavStyle` and dedicated action components.
- 🎨 **Pixel-Perfect Actions**: The new `GlassPillAction` recreates elite design standards from Apple & Google.
- 📳 **Tactile Feedback**: Integrated haptic feedback for a premium user experience.
- ♿ **Full Accessibility**: Semantic labeling and screen-reader support baked in.
- 🌓 **Dynamic Theming**: Intelligent color resolution for seamless Light/Dark mode transitions.

## 🚀 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  glass_pill_nav:
    git: https://github.com/yourusername/glass_pill_nav.git
```

### 🧬 Shader Setup (Optional)

To enable the **Liquid Glass variant**, ensure you have the shader defined in your `pubspec.yaml`:

```yaml
flutter:
  shaders:
    - packages/glass_pill_nav/shaders/liquid_pill.frag
```

## 🛠️ Usage

### Basic Setup

```dart
import 'package:glass_pill_nav/glass_pill_nav.dart';

GlassPillNav(
  currentIndex: _currentIndex,
  items: [
    GlassPillNavItem(icon: Icons.home, label: 'Home', onTap: () => setState(() => _currentIndex = 0)),
    GlassPillNavItem(icon: Icons.person, label: 'Profile', onTap: () => setState(() => _currentIndex = 1)),
  ],
)
```

### Pro Setup (with Liquid Effect & Custom Action)

```dart
GlassPillNav(
  currentIndex: _currentIndex,
  style: GlassPillNavStyle(
    activeColor: Colors.blueAccent,
    enableLiquidEffect: true, // Enables GLSL shader
    animationCurve: Curves.easeOutBack,
  ),
  centerAction: const GlassPillAction(), // High-end Teal-Orange button
  onCenterActionTap: () => print("Action Tapped!"),
  items: items,
)
```

## 🎨 Customization (`GlassPillNavStyle`)

| Property             | Description                    | Default       |
| -------------------- | ------------------------------ | ------------- |
| `height`             | Height of the navigation bar   | `70`          |
| `borderRadius`       | Overall border radius          | `35`          |
| `blurSigma`          | Glass blur intensity           | `15`          |
| `activeColor`        | Color of active elements       | Theme Primary |
| `enableLiquidEffect` | Toggle for GLSL Liquid Shader  | `false`       |
| `enableShimmer`      | Toggle for icon shimmer effect | `true`        |
| `animationDuration`  | Transition speed               | `300ms`       |

## 🌟 Style Presets

Achieve "Elite" designs with a single line of code:

```dart
GlassPillNav(
  style: GlassPillNavStyle.nebula(), // Matches standard screenshot style
  items: items,
)
```

## 🛠️ Performance Design

This package uses `RepaintBoundary` and GPU-accelerated shaders to ensure that complex glass and liquid effects do not impact the main UI thread performance.

## 📄 License

MIT - Designed by Antigravity (Advanced Agentic Coding).
