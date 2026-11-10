import 'package:flutter/material.dart';

import '../core/layout/layout_config.dart';
import '../core/theme/app_spacing.dart';
import '../l10n/app_localizations.dart';

/// Insets that make a dialog span the phone and cap its width on tablets.
EdgeInsets dialogInsets(BuildContext context) {
  final config = LayoutConfig.of(context);
  final maxWidth = config.dialogMaxWidth;
  final width = MediaQuery.sizeOf(context).width;
  final horizontal = maxWidth == null
      ? AppSpacing.lg
      : ((width - maxWidth) / 2).clamp(AppSpacing.lg, double.infinity);
  return EdgeInsets.symmetric(horizontal: horizontal, vertical: AppSpacing.xxl);
}

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  String? body,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      final scheme = Theme.of(context).colorScheme;
      return AlertDialog(
        insetPadding: dialogInsets(context),
        scrollable: true,
        title: Text(title),
        content: body == null ? null : Text(body),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: destructive
                ? FilledButton.styleFrom(
                    backgroundColor: scheme.error,
                    foregroundColor: scheme.onError,
                  )
                : null,
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

/// Bottom sheet on phones, width-capped dialog from tablets up.
Future<T?> showAdaptiveForm<T>(BuildContext context, WidgetBuilder builder) {
  if (LayoutConfig.of(context).isCompact) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            0,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: builder(context),
        ),
      ),
    );
  }
  return showDialog<T>(
    context: context,
    builder: (context) => Dialog(
      insetPadding: dialogInsets(context),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: builder(context),
      ),
    ),
  );
}
