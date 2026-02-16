# Changelog

All notable changes to this project will be documented in this file.

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
