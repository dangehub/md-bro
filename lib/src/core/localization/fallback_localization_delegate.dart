import 'package:flutter/material.dart';

/// A wrapper delegate that falls back to English if the requested locale is not supported
/// by the inner delegate.
class FallbackLocalizationDelegate<T> extends LocalizationsDelegate<T> {
  final LocalizationsDelegate<T> _delegate;
  final Locale fallbackLocale;

  const FallbackLocalizationDelegate(
    this._delegate, {
    this.fallbackLocale = const Locale('en'),
  });

  @override
  bool isSupported(Locale locale) => true; // We support any locale by fallback

  @override
  Future<T> load(Locale locale) async {
    if (_delegate.isSupported(locale)) {
      try {
        return await _delegate.load(locale);
      } catch (e) {
        // Fallback on load error
      }
    }
    // Fallback to default locale
    return _delegate.load(fallbackLocale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<T> old) =>
      _delegate.shouldReload(old);
}
