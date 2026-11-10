import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'language/app_language.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(_fontLicenses);
  final languageController = await AppLanguageController.load();
  runApp(
    ProviderScope(
      overrides: [
        appLanguageControllerProvider.overrideWithValue(languageController),
      ],
      child: const TodoApp(),
    ),
  );
}

Stream<LicenseEntry> _fontLicenses() async* {
  for (final (family, file) in [
    ('Baloo 2', 'OFL-Baloo2.txt'),
    ('Be Vietnam Pro', 'OFL-BeVietnamPro.txt'),
  ]) {
    final text = await rootBundle.loadString('assets/fonts/$file');
    yield LicenseEntryWithLineBreaks([family], text);
  }
}
