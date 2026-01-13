import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_language.dart';

/// Service for managing application localization.
///
/// This service handles:
/// - Current locale preference (persisted to SharedPreferences)
/// - Loading/unloading custom dictionaries
/// - Providing translations for custom languages
class LocaleService extends ChangeNotifier {
  static LocaleService? _instance;
  static final Logger _logger = Logger();

  /// Built-in supported locales
  static const List<Locale> builtInLocales = [
    Locale('en'), // English (default)
    Locale('zh'), // 简体中文
  ];

  /// Built-in locale display names
  static const Map<String, String> builtInLocaleNames = {
    'en': 'English',
    'zh': '简体中文',
  };

  Locale _currentLocale = const Locale('en');
  List<CustomLanguage> _customLanguages = [];
  bool _initialized = false;

  LocaleService._();

  /// Get singleton instance
  static LocaleService get instance {
    _instance ??= LocaleService._();
    return _instance!;
  }

  /// Current locale
  Locale get currentLocale => _currentLocale;

  /// All custom languages
  List<CustomLanguage> get customLanguages =>
      List.unmodifiable(_customLanguages);

  /// All supported locales (built-in + custom)
  List<Locale> get supportedLocales {
    return [
      ...builtInLocales,
      ..._customLanguages.map((lang) => Locale(lang.locale)),
    ];
  }

  /// Check if a locale is a custom language
  bool isCustomLocale(Locale locale) {
    return _customLanguages.any((lang) => lang.locale == locale.languageCode);
  }

  /// Get display name for a locale
  String getLocaleName(Locale locale) {
    // Check built-in first
    if (builtInLocaleNames.containsKey(locale.languageCode)) {
      return builtInLocaleNames[locale.languageCode]!;
    }
    // Check custom languages
    final custom = _customLanguages.firstWhere(
      (lang) => lang.locale == locale.languageCode,
      orElse: () => CustomLanguage(
        locale: locale.languageCode,
        name: locale.languageCode,
        translations: {},
      ),
    );
    return custom.name;
  }

  /// Initialize the service
  Future<void> initialize() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();

    // Load saved locale
    final savedLocale = prefs.getString('app_locale');
    if (savedLocale != null) {
      _currentLocale = Locale(savedLocale);
    }

    // Load custom languages
    await _loadCustomLanguages();

    _initialized = true;
    notifyListeners();
  }

  /// Set current locale
  Future<void> setLocale(Locale locale) async {
    if (_currentLocale == locale) return;

    _currentLocale = locale;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', locale.languageCode);

    notifyListeners();
  }

  /// Import a dictionary from JSON file
  ///
  /// Returns the imported CustomLanguage on success, or throws an exception on failure.
  Future<CustomLanguage> importDictionary(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;

      // Validate required fields
      if (!json.containsKey('locale') ||
          !json.containsKey('name') ||
          !json.containsKey('translations')) {
        throw Exception(
            'Invalid dictionary format. Required fields: locale, name, translations');
      }

      final language = CustomLanguage.fromJson(json, filePath: filePath);

      // Check if language already exists
      final existingIndex = _customLanguages.indexWhere(
        (lang) => lang.locale == language.locale,
      );

      if (existingIndex >= 0) {
        // Update existing
        _customLanguages[existingIndex] = language;
        _logger.i('Updated existing language: ${language.locale}');
      } else {
        // Add new
        _customLanguages.add(language);
        _logger.i('Added new language: ${language.locale}');
      }

      // Copy file to app's documents directory for persistence
      await _copyDictionaryToAppDir(language);

      // Save metadata
      await _saveCustomLanguagesMetadata();

      notifyListeners();
      return language;
    } catch (e) {
      _logger.e('Failed to import dictionary: $e');
      rethrow;
    }
  }

  /// Remove a custom language
  Future<void> removeDictionary(String localeCode) async {
    final index = _customLanguages.indexWhere(
      (lang) => lang.locale == localeCode,
    );

    if (index < 0) {
      throw Exception('Language not found: $localeCode');
    }

    final language = _customLanguages[index];
    _customLanguages.removeAt(index);

    // Delete the dictionary file from app directory
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dictFile = File('${appDir.path}/dictionaries/$localeCode.json');
      if (await dictFile.exists()) {
        await dictFile.delete();
      }
    } catch (e) {
      _logger.w('Failed to delete dictionary file: $e');
    }

    // If current locale is the removed language, switch to English
    if (_currentLocale.languageCode == localeCode) {
      await setLocale(const Locale('en'));
    }

    await _saveCustomLanguagesMetadata();
    notifyListeners();

    _logger.i('Removed language: ${language.locale}');
  }

  /// Get translation for a key in the current custom language
  ///
  /// Returns null if current locale is not a custom language or key not found.
  String? getCustomTranslation(String key) {
    if (!isCustomLocale(_currentLocale)) return null;

    final language = _customLanguages.firstWhere(
      (lang) => lang.locale == _currentLocale.languageCode,
      orElse: () => CustomLanguage(locale: '', name: '', translations: {}),
    );

    return language.translate(key);
  }

  /// Get the current CustomLanguage object if using a custom language
  CustomLanguage? get currentCustomLanguage {
    if (!isCustomLocale(_currentLocale)) return null;

    return _customLanguages.firstWhere(
      (lang) => lang.locale == _currentLocale.languageCode,
      orElse: () => CustomLanguage(locale: '', name: '', translations: {}),
    );
  }

  /// Copy dictionary file to app's documents directory
  Future<void> _copyDictionaryToAppDir(CustomLanguage language) async {
    final appDir = await getApplicationDocumentsDirectory();
    final dictDir = Directory('${appDir.path}/dictionaries');

    if (!await dictDir.exists()) {
      await dictDir.create(recursive: true);
    }

    final dictFile = File('${dictDir.path}/${language.locale}.json');
    await dictFile.writeAsString(jsonEncode(language.toJson()));
  }

  /// Load custom languages from app's documents directory
  Future<void> _loadCustomLanguages() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dictDir = Directory('${appDir.path}/dictionaries');

      if (!await dictDir.exists()) return;

      final files = await dictDir.list().toList();
      for (final file in files) {
        if (file is File && file.path.endsWith('.json')) {
          try {
            final content = await file.readAsString();
            final json = jsonDecode(content) as Map<String, dynamic>;
            final language = CustomLanguage.fromJson(json, filePath: file.path);
            _customLanguages.add(language);
            _logger.i('Loaded custom language: ${language.locale}');
          } catch (e) {
            _logger.w('Failed to load dictionary ${file.path}: $e');
          }
        }
      }
    } catch (e) {
      _logger.e('Failed to load custom languages: $e');
    }
  }

  /// Save metadata about custom languages
  Future<void> _saveCustomLanguagesMetadata() async {
    final prefs = await SharedPreferences.getInstance();
    final metadata = _customLanguages
        .map((lang) => jsonEncode({
              'locale': lang.locale,
              'name': lang.name,
            }))
        .toList();
    await prefs.setStringList('custom_languages', metadata);
  }
}
