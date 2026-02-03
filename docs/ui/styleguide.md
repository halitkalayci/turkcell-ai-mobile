# STYLEGUIDE.MD

## UI STYLING RULES

This document defines **mandatory UI, styling and design rules**.

All UI code (human or AI-generated) **must comply** with these rules.

**Flutter Theme (Material 3) is mandatory**

No hardcoded colors, no inline styling sprawl is allowed unless explicitly asked.


---

## 1) DESIGN PHILOSOPHY

- Clean, minimal and predictable UI 
- Content-first not decoration-first
- Accessibility-aware by default. 

> If a design decision conflicts with usability or clarity, choose usability.

## 2) COLOR SYSTEM (STRICT)

### 2.1 Allowed Color Sources

Allowed:

- `ThemeData` / `ColorScheme` (Material 3)
- Project-defined **semantic tokens** only.

Not Allowed: 
- Hardcoded `Color(0xFFF)`, hex, rgb are **forbidden**

- Random colors picked per-screen are **forbidden**

- Widget-level one-off colors are **forbidden**

### 2.2 Semantic Color Usage

Use colors by intent, not by appearance.

| Intent | Source (M3) | Typical Usage |
| ------ | ----------- | ------------- |
| Primary Action | `colorScheme.primary` + `onPrimary` | Primary buttons, key actions |
| 