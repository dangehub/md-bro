import 'package:flutter/material.dart';
import 'package:obsi/src/core/localization/custom_language.dart';
import 'package:obsi/src/core/localization/locale_service.dart';
import 'package:obsi/src/core/localization/proxy_app_localizations.dart';
import 'package:obsi/src/localization/l10n_gen/app_localizations.dart';

/// A delegate that wraps the standard AppLocalizations delegate to support
/// custom languages via ProxyAppLocalizations.
///
/// If a locale is supported by standard delegate (e.g. en, zh), it loads it.
/// If not (e.g. custom), it loads the fallback (en) and wraps it with Proxy.
/// Even for standard locales, it checks if there's a custom overlap (optional,
/// but current logic prioritizes efficiency).
class ProxyLocalizationDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  final LocalizationsDelegate<AppLocalizations> _delegate;
  final Locale fallbackLocale;

  const ProxyLocalizationDelegate(
    this._delegate, {
    this.fallbackLocale = const Locale('en'),
  });

  @override
  bool isSupported(Locale locale) =>
      true; // Support everything via proxy/fallback

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // 1. Load base localization (either specific or fallback)
    AppLocalizations base;
    if (_delegate.isSupported(locale)) {
      base = await _delegate.load(locale);
    } else {
      base = await _delegate.load(fallbackLocale);
    }

    // 2. Check for custom language definition
    CustomLanguage? customLang;
    try {
      customLang = LocaleService.instance.customLanguages.firstWhere(
        (lang) => lang.locale == locale.languageCode,
      );
    } catch (_) {
      // Not found
    }

    // 3. Return Proxy if custom language found
    if (customLang != null) {
      return ProxyAppLocalizations(base, customLang);
    }

    return base;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => true;
}
