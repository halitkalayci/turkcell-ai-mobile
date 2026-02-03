# STYLEGUIDE.MD

## UI STYLING RULES

This document defines **mandatory UI, styling and design rules**.

All UI code (human or AI-generated) **must comply** with these rules.

**Flutter Theme (Material 3) is mandatory**

All colors and spacing MUST be referenced from centralized token files.


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
- Project-defined **semantic tokens** via `AppSemanticColors`
- **Centralized design tokens** via `AppColors` class

Not Allowed: 
- Hardcoded `Color(0xFFF)`, hex, rgb **inside widgets** are **forbidden**

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
- Central `AppColors` class

**Not Allowed:**

- Do NOT define any color token inside any widget.

---

## 3) DESIGN TOKEN SYSTEM

### 3.1 AppColors Class (MANDATORY)

All UI colors MUST be referenced from `lib/ui/theme/app_colors.dart`.

**Location:** `lib/ui/theme/app_colors.dart`

**Color Token Categories:**

| Category | Tokens | Usage |
|----------|--------|-------|
| Surface | `cardBackground`, `pageBackground`, `imagePlaceholder` | Backgrounds |
| Text | `textPrimary`, `textSecondary`, `textHint`, `textDisabled` | Typography |
| Icon | `iconDefault`, `iconInactive`, `iconPlaceholder`, `iconFavoriteActive` | Icons |
| Navigation | `navBackground`, `navItemActive`, `navItemInactive` | Bottom nav |
| Component | `searchBarBackground`, `buttonBackground`, `buttonForeground` | UI elements |

**Spacing Token Categories:**

| Token | Value | Usage |
|-------|-------|-------|
| `spacingStandard` | 16.0 | Page padding, gaps |
| `spacingSmall` | 8.0 | Compact spacing |
| `spacingCard` | 12.0 | Card internal padding |
| `spacingGrid` | 12.0 | Grid item spacing |

**Border Radius Token Categories:**

| Token | Value | Usage |
|-------|-------|-------|
| `radiusCard` | 16.0 | Product cards |
| `radiusSearchBar` | 8.0 | Search inputs |
| `radiusNavBar` | 24.0 | Bottom nav corners |

### 3.2 Usage Example

```dart
// ✅ CORRECT - Using AppColors tokens
Container(
  color: AppColors.cardBackground,
  padding: const EdgeInsets.all(AppColors.spacingCard),
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimary),
  ),
);

// ❌ WRONG - Hardcoded values
Container(
  color: Colors.white,  // FORBIDDEN
  padding: const EdgeInsets.all(12),  // Use token instead
  child: Text(
    'Hello',
    style: TextStyle(color: Color(0xFF000000)),  // FORBIDDEN
  ),
);
```

### 3.3 Adding New Tokens

1. Add token to `AppColors` class with documentation
2. Document in this styleguide
3. Get approval before adding new color meanings

---

## 4) FORMATTER UTILITIES

### 4.1 Price Formatting

**Location:** `lib/core/formatters/price_formatter.dart`

```dart
// Format: "$96" or "$85.5"
PriceFormatter.format(product.price);

// Format: "96.00 TRY"
PriceFormatter.formatWithCode(price, currencyCode: 'TRY');
```

### 4.2 Product Formatting

**Location:** `lib/core/formatters/product_formatter.dart`

```dart
// Extract brand: "Nike Air Force" -> "Nike"
ProductFormatter.extractBrand(product.name);

// Format count: "25 products found"
ProductFormatter.formatProductCount(count);
```

### 4.3 Why Formatters?

- **Single Responsibility Principle** - Formatting logic separate from UI
- **Testable** - Unit test formatting without widget tests
- **Consistent** - Same format everywhere in app
- **Maintainable** - Change format in one place