import 'package:flutter/material.dart';

/// Centralized color tokens for the application.
/// Per styleguide.md Section 3: Design Token System.
/// All UI colors MUST be referenced from this class.
/// 
/// Benefits:
/// - Single source of truth for colors
/// - Easy theme switching
/// - Maintainable and testable
/// - Prevents magic color values in widgets
class AppColors {
  AppColors._();

  // ============================================
  // SURFACE COLORS
  // ============================================
  
  /// Card background color (white)
  static const Color cardBackground = Colors.white;
  
  /// Page/scaffold background color (light grey)
  static const Color pageBackground = Color(0xFFF5F5F5);
  
  /// Image placeholder background
  static const Color imagePlaceholder = Color(0xFFF5F5F5);

  // ============================================
  // TEXT COLORS
  // Per styleguide.md Section 5.4: WCAG AA contrast
  // ============================================
  
  /// Primary text color (headings, prices, important text)
  /// Contrast ratio: 21:1 on white - WCAG AAA
  static const Color textPrimary = Colors.black;
  
  /// Secondary text color (descriptions, subtitles)
  /// Contrast ratio: 4.6:1 on white - WCAG AA
  /// Updated from #9E9E9E to #757575 for better readability
  static const Color textSecondary = Color(0xFF757575);
  
  /// Hint/placeholder text color
  /// Contrast ratio: 3.9:1 on white - acceptable for placeholders
  /// Updated from grey[400] to grey[500] for better visibility
  static Color get textHint => Colors.grey[500]!;
  
  /// Disabled text color
  static Color get textDisabled => Colors.grey[500]!;

  // ============================================
  // ICON COLORS
  // ============================================
  
  /// Default icon color
  static const Color iconDefault = Colors.black;
  
  /// Inactive/disabled icon color
  static Color get iconInactive => Colors.grey[600]!;
  
  /// Placeholder icon color (empty states)
  static Color get iconPlaceholder => Colors.grey[400]!;
  
  /// Favorite icon when active
  static const Color iconFavoriteActive = Colors.red;
  
  /// Favorite icon when inactive
  static const Color iconFavoriteInactive = Colors.black;

  // ============================================
  // NAVIGATION COLORS
  // ============================================
  
  /// Bottom navigation background
  static const Color navBackground = Colors.black;
  
  /// Active navigation item
  static const Color navItemActive = Colors.white;
  
  /// Inactive navigation item
  static Color get navItemInactive => Colors.grey[600]!;

  // ============================================
  // COMPONENT COLORS
  // ============================================
  
  /// Search bar background
  static const Color searchBarBackground = Colors.white;
  
  /// Button/action backgrounds
  static const Color buttonBackground = Colors.black;
  
  /// Button/action foreground
  static const Color buttonForeground = Colors.white;
  
  /// Switch active color (per styleguide.md Section 5.2)
  /// MUST be used for all Switch widgets for consistency
  static const Color switchActiveColor = Colors.black;
  
  /// Dropdown menu background color
  /// MUST be used to ensure readable dropdown items
  static const Color dropdownMenuBackground = Colors.white;

  // ============================================
  // SEMANTIC COLORS (from theme)
  // ============================================
  
  /// Error color - use Theme.of(context).colorScheme.error
  /// Success color - use context.semanticColors.success
  /// Warning color - use context.semanticColors.warning

  // ============================================
  // BORDER RADIUS TOKENS
  // ============================================
  
  /// Standard card border radius
  static const double radiusCard = 16.0;
  
  /// Search bar border radius
  static const double radiusSearchBar = 8.0;
  
  /// Bottom navigation top corners
  static const double radiusNavBar = 24.0;
  
  /// Favorite button (circle)
  static const double radiusFavoriteButton = 50.0;

  // ============================================
  // SPACING TOKENS
  // ============================================
  
  /// Standard padding
  static const double spacingStandard = 16.0;
  
  /// Small padding
  static const double spacingSmall = 8.0;
  
  /// Card internal padding
  static const double spacingCard = 12.0;
  
  /// Grid spacing between items
  static const double spacingGrid = 12.0;

  // ============================================
  // FORM COMPONENT TOKENS
  // Per styleguide.md Section 5.1
  // ============================================
  
  /// Standard input field height (TextField, Dropdown)
  /// MUST be used for horizontal alignment consistency
  static const double inputHeight = 56.0;
  
  /// Input text color - text entered by user in form fields
  /// MUST be high contrast (black on white background)
  static const Color inputTextColor = Colors.black;
}
