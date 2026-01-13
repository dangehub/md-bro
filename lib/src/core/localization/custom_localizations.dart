import 'package:flutter/material.dart';
import 'locale_service.dart';

/// A custom localizations delegate that supports dynamic custom dictionaries.
///
/// This delegate works alongside Flutter's built-in AppLocalizations to provide
/// translations for user-imported languages.
class CustomLocalizationsDelegate
    extends LocalizationsDelegate<CustomLocalizations> {
  const CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Support all built-in locales and any custom languages
    final localeService = LocaleService.instance;
    return LocaleService.builtInLocales
            .any((l) => l.languageCode == locale.languageCode) ||
        localeService.isCustomLocale(locale);
  }

  @override
  Future<CustomLocalizations> load(Locale locale) async {
    return CustomLocalizations(locale);
  }

  @override
  bool shouldReload(CustomLocalizationsDelegate old) => true;
}

/// Custom localizations class that provides translations from custom dictionaries.
///
/// Use this for custom (user-imported) languages. For built-in languages (en, zh),
/// use the standard AppLocalizations.
class CustomLocalizations {
  final Locale locale;

  CustomLocalizations(this.locale);

  static CustomLocalizations? of(BuildContext context) {
    return Localizations.of<CustomLocalizations>(context, CustomLocalizations);
  }

  /// Get translation for a key.
  ///
  /// First checks custom dictionary, then falls back to the provided default value.
  String translate(String key, String defaultValue) {
    final localeService = LocaleService.instance;
    final customTranslation = localeService.getCustomTranslation(key);
    return customTranslation ?? defaultValue;
  }

  /// Check if current locale is a custom language
  bool get isCustomLocale {
    return LocaleService.instance.isCustomLocale(locale);
  }
}

/// Extension to make it easier to get translations with fallback support
extension CustomLocalizationsExtension on BuildContext {
  /// Get a translation that works with both custom and built-in languages.
  ///
  /// [key] - The translation key
  /// [builtInValue] - The value to use for built-in languages (from AppLocalizations)
  ///
  /// For custom languages, this will look up the key in the custom dictionary.
  /// For built-in languages, it returns the builtInValue directly.
  String tr(String key, String builtInValue) {
    final customLocalizations = CustomLocalizations.of(this);
    if (customLocalizations != null && customLocalizations.isCustomLocale) {
      return customLocalizations.translate(key, builtInValue);
    }
    return builtInValue;
  }
}
