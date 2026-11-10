import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'language/app_language.dart';
import 'widgets/celebration.dart';

class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageControllerProvider);
    final router = ref.watch(routerProvider);
    return ListenableBuilder(
      listenable: language,
      builder: (context, _) => MaterialApp.router(
        routerConfig: router,
        locale: language.value.locale,
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        builder: (context, child) =>
            CelebrationOverlay(child: child ?? const SizedBox()),
      ),
    );
  }
}
