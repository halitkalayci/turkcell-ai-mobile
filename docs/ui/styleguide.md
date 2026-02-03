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

---

## 5) FORM COMPONENTS (STRICT)

### 5.1 Input Field Height

All form inputs (TextField, Dropdown, etc.) MUST use consistent heights.

| Component | Height | Token |
|-----------|--------|-------|
| TextField | 56px | `AppColors.inputHeight` |
| Dropdown | 56px | `AppColors.inputHeight` |
| Switch Container | Auto | Min height 56px |

**Why fixed heights?**
- Horizontal alignment when inputs are side-by-side
- Visual consistency across all forms
- Predictable layout behavior

### 5.2 Switch/Toggle Colors

All switches MUST use the same active color across the app.

| State | Token | Color |
|-------|-------|-------|
| Active | `AppColors.switchActiveColor` | Black |
| Inactive | Default Material | Grey |

```dart
// ✅ CORRECT
Switch(
  value: _isActive,
  onChanged: (v) => setState(() => _isActive = v),
  activeColor: AppColors.switchActiveColor,
)

// ❌ WRONG - Using theme.colorScheme.primary or hardcoded colors
Switch(
  activeColor: theme.colorScheme.primary,  // FORBIDDEN - inconsistent
)
```

### 5.3 Input Text Colors

All input fields MUST use explicit text colors for entered text.

| Element | Token | Color |
|---------|-------|-------|
| User-entered text | `AppColors.inputTextColor` | Black |
| Placeholder/hint | `AppColors.textHint` | Grey[500] |

```dart
// ✅ CORRECT - Explicit input text color
TextFormField(
  style: const TextStyle(color: AppColors.inputTextColor),
  decoration: InputDecoration(
    hintStyle: TextStyle(color: AppColors.textHint),
  ),
)

// ❌ WRONG - Relying on theme default (may be low contrast)
TextFormField(
  decoration: InputDecoration(...),  // No style property
)
```

### 5.4 Dropdown Styling

All dropdowns MUST use explicit colors for background and text.

| Element | Property/Token | Value |
|---------|----------------|-------|
| Menu background | `dropdownColor` | `AppColors.cardBackground` (white) |
| Selected value text | `AppColors.textPrimary` | Black |
| Placeholder/hint | `AppColors.textHint` | Grey |
| Dropdown item text | `AppColors.textPrimary` | Black |
| Icon | `AppColors.iconInactive` | Grey |

```dart
// ✅ CORRECT - Explicit dropdown background and text colors
DropdownButton<String>(
  dropdownColor: AppColors.cardBackground,  // WHITE background for menu
  items: items.map((item) => DropdownMenuItem(
    child: Text(item, style: TextStyle(color: AppColors.textPrimary)),
  )).toList(),
)

// ❌ WRONG - Relying on theme (menu background may be dark)
DropdownButton<String>(
  items: items.map((item) => DropdownMenuItem(
    child: Text(item),  // No dropdownColor = unreadable on dark themes
  )).toList(),
)
```

### 5.5 Text Contrast Requirements

All text MUST meet WCAG AA contrast requirements (4.5:1 for normal text).

| Token | Minimum Contrast | Usage |
|-------|------------------|-------|
| `textPrimary` | 7:1+ | Headings, prices, labels |
| `textSecondary` | 4.5:1+ | Descriptions, subtitles |
| `textHint` | 3:1+ | Placeholders (relaxed for hints) |

**Forbidden:**
- Using `grey[400]` or lighter for readable text
- Using opacity < 0.6 on text that should be read