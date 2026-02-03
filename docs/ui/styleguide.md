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
| Secondary Action | `colorScheme.secondary` + `onSecondary` | Secondary buttons |
| Surface | `colorScheme.surface` + `onSurface` | Cards, pages |
| Success | `semantic.success` + `semantic.onSuccess` | Success banner/badge |
| Warning | `semantic.warning` + `semantic.onWarning` | Warning banner/badge |
| Error | `colorScheme.error` + `onError` | Error states, destructive actions |
| Disabled | `colorScheme.onSurface` with opacity | Disabled buttons/text |

> Do NOT introduce new color meanings without approval and documentation.

### 2.3 Semantic Tokens (Project-Defined)

If material 3 does not provide a semantic token (e.g success/warning), define it once and reuse.

**Allowed Patterns:**

- `ThemeExtension<AppSemanticColors>`
- Central `AppColors` 

**Not Allowed:**

- Do NOT define any color token inside any widget.