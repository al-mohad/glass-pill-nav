# Changelog

All notable changes to this project will be documented in this file.

## [1.1.1] - 2026-03-02

### 🛠 Fixes

- **AnimatedContainer Interpolation**: Resolved a crash in `GlassPillNav.morphing` mode where `AnimatedContainer` failed to interpolate between finite and unbounded constraints. Width transitions are now explicitly calculated using screen dimensions.

## [1.1.0] - 2026-03-02

### ✨ New Features

- **Expandable Mode**: `GlassPillNav.expandable` named constructor for revealing extra tab items from a floating central action button.
- **Morphing Variant**: `GlassPillNav.morphing` named constructor that starts as a single button and expands horizontally to reveal the full navigation bar.
- **Scroll-Reactive Behavior**: Navigation bar now automatically shrinks when scrolling down and expands when scrolling up or tapping (requires a `ScrollController`).
- **Smooth Morphing Animations**: Center action button and navigation bar now feature fluid transitions and GPU-accelerated morphing effects.

### 🛠 Improvements & Fixes

- **Unified Architecture**: Integrated expandable logic directly into the main `GlassPillNav` widget.
- **Overflow Prevention**: Re-engineered layout to automatically hide labels and scale icons in shrunk mode, preventing `RenderFlex` overflows.
- **Enhanced Design System**: Added new tokens to `GlassPillNavStyle` for refined control over expanded/shrunk states.
- **API Modernization**: Resolved Flutter deprecation warnings for Color and Matrix4 APIs.
- **Redesigned Demo**: Updated example app with a mode switcher and interactive scroll demonstrations.

## [1.0.1] - 2026-02-16

### 🔄 Navigation Enhancements

- **Optional Callbacks**: Made `onTap` in `GlassPillNavItem` optional to support more flexible navigation patterns.
- **Global Event Handler**: Introduced `onTabTap` callback on `GlassPillNav` for centralized tab event management.
- **Refined Example**: Updated the example application and tests to leverage the new callback structure.
- **Lint Cleanup**: Fixed deprecated API usages, replacing `withOpacity` with `withValues`.

## [1.0.0] - 2026-02-16

### 🚀 Initial Public Release

- **Glassmorphic "Supreme" Architecture**: A completely modular, industry-standard navigation package.
- **Style Presets**: Added `GlassPillNavStyle.nebula()` for instant high-end design applications.
- **Elite Liquid Glass Variant**: GPU-accelerated GLSL fragment shader for an organic, melting pill effect.
- **Pixel-Perfect Action Widget**: The `GlassPillAction` component recreates high-end design standards with glass sheen and teal-to-orange gradients.
- **Intelligent Theming**: Automatic Light/Dark mode color resolution and style inheritance (`GlassPillNavScope`).
- **Tactile Performance**: Integrated haptic feedback and `RepaintBoundary` isolation for smooth 60/120fps rendering.
- **Accessibility & UX**: Semantic labels, accessible navigation, and customizable animation curves (Cubic/Back).
- **Pro Styling API**: Encapsulated configuration via the `GlassPillNavStyle` class.
