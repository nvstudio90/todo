import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../data/providers.dart';
import '../features/home/home_state.dart';
import '../l10n/app_localizations.dart';
import '../l10n/seed_text.dart';

/// One row of kid chips that scrolls sideways when there are many kids.
class KidChipBar extends ConsumerStatefulWidget {
  const KidChipBar({super.key});

  @override
  ConsumerState<KidChipBar> createState() => _KidChipBarState();
}

class _KidChipBarState extends ConsumerState<KidChipBar> {
  final _keys = <int, GlobalKey>{};
  final _scroll = ScrollController();
  int? _shownKidId;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Scrolls only this row: Scrollable.ensureVisible would also move the page
  /// every time the header is rebuilt.
  void _revealSelected(int kidId) {
    if (_shownKidId == kidId) return;
    _shownKidId = kidId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chip = _keys[kidId]?.currentContext?.findRenderObject();
      if (chip == null || !_scroll.hasClients) return;
      final target = RenderAbstractViewport.of(chip)
          .getOffsetToReveal(chip, 0.5)
          .offset
          .clamp(0.0, _scroll.position.maxScrollExtent);
      unawaited(
        _scroll.animateTo(
          target,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kids = ref.watch(kidsProvider).value ?? const [];
    final current = ref.watch(currentKidProvider);
    if (current != null) _revealSelected(current.id);

    return SingleChildScrollView(
      controller: _scroll,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (i, kid) in kids.indexed) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            KidChip(
              key: _keys.putIfAbsent(kid.id, GlobalKey.new),
              label: kid.displayName(l10n),
              selected: kid.id == current?.id,
              onTap: () =>
                  ref.read(selectedKidIdProvider.notifier).select(kid.id),
            ),
          ],
        ],
      ),
    );
  }
}

class KidChip extends StatelessWidget {
  const KidChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Semantics(
      selected: selected,
      button: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40, maxWidth: 160),
        child: Material(
          color: selected ? c.primary : c.chipIdle,
          shape: StadiumBorder(
            side: selected ? BorderSide.none : BorderSide(color: c.border),
          ),
          child: InkWell(
            onTap: onTap,
            customBorder: const StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.sm,
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTypography.labelLarge.copyWith(
                  color: selected ? c.onPrimary : c.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
