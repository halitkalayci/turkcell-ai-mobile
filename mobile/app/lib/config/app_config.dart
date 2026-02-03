/// Application environment configuration.
/// Manages environment-specific settings (dev, staging, prod).
///
/// Source: AGENTS.md Section 5.6
enum AppEnvironment {
  development,
  staging,
  production,
}

class AppConfig {
  /// Current application environment
  static const AppEnvironment currentEnvironment = AppEnvironment.development;

  /// Get base URL based on environment
  static String get baseUrl {
    switch (currentEnvironment) {
      case AppEnvironment.development:
        return 'http://localhost:8080';
      case AppEnvironment.staging:
        return 'https://staging.turkcell-ai-mobile.com'; // Placeholder
      case AppEnvironment.production:
        return 'https://api.turkcell-ai-mobile.com'; // Placeholder
    }
  }

  /// Check if running in development mode
  static bool get isDevelopment => currentEnvironment == AppEnvironment.development;

  /// Check if running in production mode
  static bool get isProduction => currentEnvironment == AppEnvironment.production;

  /// Application name
  static const String appName = 'Turkcell AI Mobile';

  /// Application version
  static const String appVersion = '1.0.0';
}
