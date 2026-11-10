import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/models/models.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/seed_text.dart';
import '../../widgets/celebration.dart';
import '../../widgets/dialogs.dart';
import '../home/home_state.dart';
import '../pin/pin_dialog.dart';

/// Confirm, then parent PIN, then spend the points.
Future<void> redeemReward(
  BuildContext context,
  WidgetRef ref,
  Reward reward,
) async {
  final l10n = AppLocalizations.of(context);
  final kid = ref.read(currentKidProvider);
  if (kid == null) return;
  final title = reward.displayTitle(l10n);

  final confirmed = await showConfirmDialog(
    context,
    title: l10n.redeemConfirm(reward.cost, title),
    confirmLabel: l10n.redeem,
  );
  if (!confirmed || !context.mounted) return;
  if (!await requestParentPin(context, ref)) return;

  // Points may have changed while the dialogs were open.
  final available = ref.read(scoringProvider(kid.id))?.available ?? 0;
  if (available < reward.cost) return;
  await ref
      .read(rewardRepositoryProvider)
      .redeem(kidId: kid.id, reward: reward);
  ref.read(celebrationProvider).play();
  if (!context.mounted) return;
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(content: Text(l10n.redeemDone(kid.displayName(l10n), title))),
  );
}
