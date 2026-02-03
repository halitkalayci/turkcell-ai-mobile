import 'package:flutter/material.dart';

/// Semantic color extension for Material 3 theme.
/// Per styleguide.md Section 2.3: Project-defined semantic tokens.
/// Provides success/warning colors not in base Material 3 ColorScheme.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;

  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
  });

  @override
  ThemeExtension<AppSemanticColors> copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
    );
  }

  @override
  ThemeExtension<AppSemanticColors> lerp(
    ThemeExtension<AppSemanticColors>? other,
    double t,
  ) {
    if (other is! AppSemanticColors) {
      return this;
    }
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
    );
  }

  /// Light theme semantic colors
  static const light = AppSemanticColors(
    success: Color(0xFF4CAF50), // Green
    onSuccess: Color(0xFFFFFFFF), // White
    warning: Color(0xFFFF9800), // Orange
    onWarning: Color(0xFF000000), // Black
  );

  /// Dark theme semantic colors
  static const dark = AppSemanticColors(
    success: Color(0xFF66BB6A), // Lighter green
    onSuccess: Color(0xFF000000), // Black
    warning: Color(0xFFFFB74D), // Lighter orange
    onWarning: Color(0xFF000000), // Black
  );
}

/// Extension to access semantic colors from BuildContext
extension SemanticColorsExtension on BuildContext {
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>() ??
      AppSemanticColors.light;
}
