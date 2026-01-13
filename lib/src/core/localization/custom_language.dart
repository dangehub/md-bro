/// Custom language model for user-imported dictionaries.
///
/// This class represents a language that users can import via JSON files.
/// It contains all the translations for a specific locale.
class CustomLanguage {
  /// Language code (e.g., "ja", "ko", "fr")
  final String locale;

  /// Display name of the language (e.g., "日本語", "한국어", "Français")
  final String name;

  /// Translation map: key -> translated string
  final Map<String, String> translations;

  /// Optional file path where this dictionary was loaded from
  final String? filePath;

  CustomLanguage({
    required this.locale,
    required this.name,
    required this.translations,
    this.filePath,
  });

  /// Create from JSON map
  factory CustomLanguage.fromJson(Map<String, dynamic> json,
      {String? filePath}) {
    return CustomLanguage(
      locale: json['locale'] as String,
      name: json['name'] as String,
      translations: Map<String, String>.from(json['translations'] as Map),
      filePath: filePath,
    );
  }

  /// Convert to JSON map (for persistence)
  Map<String, dynamic> toJson() {
    return {
      'locale': locale,
      'name': name,
      'translations': translations,
      if (filePath != null) 'filePath': filePath,
    };
  }

  /// Get a translation by key, returns null if not found
  String? translate(String key) {
    return translations[key];
  }

  @override
  String toString() => 'CustomLanguage($locale: $name)';
}
