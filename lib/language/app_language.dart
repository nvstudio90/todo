import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  system(null),
  english(Locale('en')),
  vietnamese(Locale('vi'));

  const AppLanguage(this.locale);

  /// `null` lets Flutter resolve the locale from the device settings.
  final Locale? locale;
}

class AppLanguageController extends ValueNotifier<AppLanguage> {
  AppLanguageController._(this._prefs, super.value);

  // Stores the language code, not the enum name, so renaming values keeps saved choices.
  static const _prefsKey = 'app_language';

  final SharedPreferencesWithCache _prefs;

  static Future<AppLanguageController> load() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {_prefsKey},
      ),
    );
    final saved = prefs.getString(_prefsKey);
    final language = AppLanguage.values.firstWhere(
      (language) => language.locale?.languageCode == saved,
      orElse: () => AppLanguage.system,
    );
    return AppLanguageController._(prefs, language);
  }

  Future<void> select(AppLanguage language) async {
    value = language;
    final code = language.locale?.languageCode;
    if (code == null) {
      await _prefs.remove(_prefsKey);
    } else {
      await _prefs.setString(_prefsKey, code);
    }
  }
}
