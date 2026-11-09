import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'app_language.dart';

class LanguageMenuButton extends StatelessWidget {
  const LanguageMenuButton({super.key, required this.controller});

  final AppLanguageController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<AppLanguage>(
      icon: const Icon(Icons.translate),
      tooltip: l10n.languageMenuTooltip,
      initialValue: controller.value,
      onSelected: controller.select,
      itemBuilder: (context) => [
        for (final language in AppLanguage.values)
          CheckedPopupMenuItem(
            value: language,
            checked: language == controller.value,
            child: Text(_label(language, l10n)),
          ),
      ],
    );
  }

  String _label(AppLanguage language, AppLocalizations l10n) =>
      switch (language) {
        AppLanguage.system => l10n.languageSystem,
        // Language names stay in their own language so users can find theirs from any locale.
        AppLanguage.english => 'English',
        AppLanguage.vietnamese => 'Tiếng Việt',
      };
}
