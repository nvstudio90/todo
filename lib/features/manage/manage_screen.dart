import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout/layout_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/providers.dart';
import '../../domain/models/models.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/seed_text.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/section_card.dart';
import '../home/home_state.dart';
import '../pin/pin_dialog.dart';
import '../today/today_tab.dart';
import 'item_forms.dart';

/// PIN-gated editor for tasks, rewards, kids and the PIN itself.
class ManageScreen extends StatelessWidget {
  const ManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.editLists),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: [
              Tab(text: l10n.manageMustDo),
              Tab(text: l10n.manageOptional),
              Tab(text: l10n.manageRewards),
              Tab(text: l10n.manageKids),
              Tab(text: l10n.managePin),
            ],
          ),
        ),
        body: const SafeArea(
          top: false,
          child: TabBarView(
            children: [
              _TaskEditor(type: TaskType.mustDo),
              _TaskEditor(type: TaskType.optional),
              _RewardEditor(),
              _KidEditor(),
              _PinSettings(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Keeps tablet forms readable instead of stretching across the screen.
class _Constrained extends StatelessWidget {
  const _Constrained({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: child,
      ),
    );
  }
}

/// Drag-to-reorder list that applies the new order at once, before the
/// database stream catches up, so rows do not jump back.
class _ReorderableEditor<T> extends StatefulWidget {
  const _ReorderableEditor({
    required this.items,
    required this.idOf,
    required this.onReorder,
    required this.rowBuilder,
    required this.addLabel,
    required this.onAdd,
  });

  final List<T> items;
  final int Function(T) idOf;
  final ValueChanged<List<int>> onReorder;
  final Widget Function(BuildContext, T, Widget handle) rowBuilder;
  final String addLabel;
  final VoidCallback onAdd;

  @override
  State<_ReorderableEditor<T>> createState() => _ReorderableEditorState<T>();
}

class _ReorderableEditorState<T> extends State<_ReorderableEditor<T>> {
  List<T>? _pending;

  @override
  void didUpdateWidget(_ReorderableEditor<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.items, widget.items)) _pending = null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final items = _pending ?? widget.items;
    final config = LayoutConfig.of(context);
    final hint = Padding(
      padding: EdgeInsets.fromLTRB(
        config.screenMargin,
        AppSpacing.md,
        config.screenMargin,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Icon(Icons.drag_indicator, size: 18, color: c.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              l10n.reorderHint,
              style: AppTypography.bodyMedium.copyWith(color: c.textSecondary),
            ),
          ),
        ],
      ),
    );
    final addButton = Padding(
      padding: EdgeInsets.all(config.screenMargin),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: widget.onAdd,
          icon: const Icon(Icons.add),
          label: Text(widget.addLabel),
        ),
      ),
    );
    // Too short to pin the hint and button (landscape phones and fold
    // covers): they scroll with the list so rows keep the space.
    final short = MediaQuery.sizeOf(context).height < 480;

    return _Constrained(
      child: Column(
        children: [
          if (!short) hint,
          Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              header: short ? hint : null,
              footer: short ? addButton : null,
              padding: EdgeInsets.symmetric(
                horizontal: short ? 0 : config.screenMargin,
                vertical: AppSpacing.sm,
              ),
              itemCount: items.length,
              onReorderItem: (from, to) {
                final next = [...items];
                next.insert(to, next.removeAt(from));
                setState(() => _pending = next);
                widget.onReorder(next.map(widget.idOf).toList());
              },
              itemBuilder: (context, i) {
                final item = items[i];
                return Padding(
                  key: ValueKey(widget.idOf(item)),
                  padding: EdgeInsets.only(
                    bottom: AppSpacing.sm,
                    left: short ? config.screenMargin : 0,
                    right: short ? config.screenMargin : 0,
                  ),
                  child: widget.rowBuilder(
                    context,
                    item,
                    ReorderableDragStartListener(
                      index: i,
                      child: const Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Icon(Icons.drag_indicator),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (!short) addButton,
        ],
      ),
    );
  }
}

class _EditorRow extends StatelessWidget {
  const _EditorRow({
    required this.handle,
    required this.emoji,
    required this.title,
    this.trailing,
    required this.onTap,
    this.onDelete,
    required this.deleteTooltip,
  });

  final Widget handle;
  final String? emoji;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final String deleteTooltip;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: c.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.taskRowMinHeight,
          ),
          child: Row(
            children: [
              handle,
              if (emoji != null) ...[
                Text(emoji!, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyLarge.copyWith(color: c.textPrimary),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ],
              if (onDelete != null)
                IconButton(
                  tooltip: deleteTooltip,
                  onPressed: onDelete,
                  icon: const Icon(Icons.close_rounded),
                )
              else
                const SizedBox(width: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

/// Seeded rows keep following the app language unless the text was changed.
String? _customText(
  String? seedKey,
  String? stored,
  String original,
  String edited,
) => seedKey != null && stored == null && edited == original ? null : edited;

class _TaskEditor extends ConsumerWidget {
  const _TaskEditor({required this.type});

  final TaskType type;

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, [
    TaskItem? task,
  ]) async {
    final l10n = AppLocalizations.of(context);
    final original = task?.displayTitle(l10n) ?? '';
    final result = await showAdaptiveForm<ItemFormResult>(
      context,
      (_) => ItemForm(
        title: task == null ? l10n.addTask : l10n.editTask,
        nameLabel: l10n.taskName,
        valueLabel: l10n.taskPoints,
        initialEmoji: task?.emoji ?? '⭐',
        initialName: original,
        initialValue: task?.points ?? 2,
        minValue: 1,
        maxValue: 20,
        submitLabel: task == null ? l10n.add : l10n.save,
      ),
    );
    if (result == null) return;
    final repo = ref.read(taskRepositoryProvider);
    if (task == null) {
      await repo.add(
        type: type,
        emoji: result.emoji,
        title: result.title,
        points: result.value,
      );
    } else {
      await repo.edit(
        task.id,
        emoji: result.emoji,
        title: _customText(task.seedKey, task.title, original, result.title),
        points: result.value,
      );
    }
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    TaskItem task,
  ) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showConfirmDialog(
      context,
      title: l10n.deleteTaskTitle(task.displayTitle(l10n)),
      body: l10n.deleteTaskBody,
      confirmLabel: l10n.remove,
      destructive: true,
    );
    if (ok) await ref.read(taskRepositoryProvider).archive(task.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = SectionColors.forTask(context, type);
    final tasks = ref.watch(visibleTasksProvider(type)) ?? const [];
    return _ReorderableEditor<TaskItem>(
      items: tasks,
      idOf: (t) => t.id,
      onReorder: ref.read(taskRepositoryProvider).reorder,
      addLabel: l10n.addTask,
      onAdd: () => _openForm(context, ref),
      rowBuilder: (context, task, handle) => _EditorRow(
        handle: handle,
        emoji: task.emoji,
        title: task.displayTitle(l10n),
        trailing: PointsBadge(points: task.points, colors: colors),
        onTap: () => _openForm(context, ref, task),
        onDelete: () => _remove(context, ref, task),
        deleteTooltip: l10n.remove,
      ),
    );
  }
}

class _RewardEditor extends ConsumerWidget {
  const _RewardEditor();

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, [
    Reward? reward,
  ]) async {
    final l10n = AppLocalizations.of(context);
    final original = reward?.displayTitle(l10n) ?? '';
    final result = await showAdaptiveForm<ItemFormResult>(
      context,
      (_) => ItemForm(
        title: reward == null ? l10n.addReward : l10n.editReward,
        nameLabel: l10n.rewardName,
        valueLabel: l10n.rewardCost,
        initialEmoji: reward?.emoji ?? '🎁',
        initialName: original,
        initialValue: reward?.cost ?? 20,
        minValue: 1,
        maxValue: 9999,
        submitLabel: reward == null ? l10n.add : l10n.save,
      ),
    );
    if (result == null) return;
    final repo = ref.read(rewardRepositoryProvider);
    if (reward == null) {
      await repo.add(
        emoji: result.emoji,
        title: result.title,
        cost: result.value,
      );
    } else {
      await repo.edit(
        reward.id,
        emoji: result.emoji,
        title: _customText(
          reward.seedKey,
          reward.title,
          original,
          result.title,
        ),
        cost: result.value,
      );
    }
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    Reward reward,
  ) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showConfirmDialog(
      context,
      title: l10n.deleteRewardTitle(reward.displayTitle(l10n)),
      body: l10n.deleteRewardBody,
      confirmLabel: l10n.remove,
      destructive: true,
    );
    if (ok) await ref.read(rewardRepositoryProvider).archive(reward.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final rewards = ref.watch(activeRewardsProvider) ?? const [];
    return _ReorderableEditor<Reward>(
      items: rewards,
      idOf: (r) => r.id,
      onReorder: ref.read(rewardRepositoryProvider).reorder,
      addLabel: l10n.addReward,
      onAdd: () => _openForm(context, ref),
      rowBuilder: (context, reward, handle) => _EditorRow(
        handle: handle,
        emoji: reward.emoji,
        title: reward.displayTitle(l10n),
        trailing: Text(
          l10n.costValue(reward.cost),
          style: AppTypography.labelLarge.copyWith(color: c.rewardText),
        ),
        onTap: () => _openForm(context, ref, reward),
        onDelete: () => _remove(context, ref, reward),
        deleteTooltip: l10n.remove,
      ),
    );
  }
}

class _KidEditor extends ConsumerWidget {
  const _KidEditor();

  Future<String?> _askName(
    BuildContext context,
    String title,
    String initial,
    String submit,
  ) {
    final l10n = AppLocalizations.of(context);
    return showAdaptiveForm<String>(
      context,
      (_) => NameForm(
        title: title,
        label: l10n.kidName,
        initialName: initial,
        submitLabel: submit,
      ),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final name = await _askName(context, l10n.addKid, '', l10n.add);
    if (name != null) await ref.read(kidRepositoryProvider).add(name);
  }

  Future<void> _rename(BuildContext context, WidgetRef ref, Kid kid) async {
    final l10n = AppLocalizations.of(context);
    final original = kid.displayName(l10n);
    final name = await _askName(context, l10n.renameKid, original, l10n.save);
    if (name == null) return;
    final custom = _customText(kid.seedKey, kid.name, original, name);
    if (custom != null) {
      await ref.read(kidRepositoryProvider).rename(kid.id, custom);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Kid kid) async {
    final l10n = AppLocalizations.of(context);
    final name = kid.displayName(l10n);
    final ok = await showConfirmDialog(
      context,
      title: l10n.deleteKidTitle(name),
      body: l10n.deleteKidBody(name),
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (ok) await ref.read(kidRepositoryProvider).delete(kid.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kids = ref.watch(kidsProvider).value ?? const [];
    final canDelete = kids.length > 1;
    return _ReorderableEditor<Kid>(
      items: kids,
      idOf: (k) => k.id,
      onReorder: ref.read(kidRepositoryProvider).reorder,
      addLabel: l10n.addKid,
      onAdd: () => _add(context, ref),
      rowBuilder: (context, kid, handle) => _EditorRow(
        handle: handle,
        emoji: null,
        title: kid.displayName(l10n),
        trailing: const Icon(Icons.edit_outlined, size: 18),
        onTap: () => _rename(context, ref, kid),
        onDelete: canDelete ? () => _delete(context, ref, kid) : null,
        deleteTooltip: l10n.delete,
      ),
    );
  }
}

class _PinSettings extends ConsumerWidget {
  const _PinSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final config = LayoutConfig.of(context);
    return _Constrained(
      child: ListView(
        padding: EdgeInsets.all(config.screenMargin),
        children: [
          AppCard(
            padding: EdgeInsets.all(config.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardTitle(emoji: '🔒', title: l10n.managePin),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.pinSectionBody,
                  style: AppTypography.bodyMedium.copyWith(
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: () async {
                    final changed = await requestParentPin(
                      context,
                      ref,
                      changePin: true,
                    );
                    if (!changed || !context.mounted) return;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(l10n.pinChanged)));
                  },
                  icon: const Icon(Icons.pin_outlined),
                  label: Text(l10n.changePin),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
