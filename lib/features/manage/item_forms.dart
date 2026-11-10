import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

typedef ItemFormResult = ({String emoji, String title, int value});

const _emojiChoices = [
  '🛏️',
  '🪥',
  '👕',
  '🎒',
  '🍴',
  '🧸',
  '📚',
  '🚿',
  '📖',
  '🧹',
  '🧺',
  '🪴',
  '🎨',
  '👟',
  '🇬🇧',
  '💡',
  '❤️',
  '🧦',
  '🍽️',
  '🐶',
  '🎹',
  '⚽',
  '🚲',
  '🧩',
  '✏️',
  '🧼',
  '🥦',
  '💧',
  '😴',
  '🙏',
  '🍦',
  '🎬',
  '🎲',
  '🚗',
  '🎁',
  '🎡',
  '🍕',
  '🎮',
  '📱',
  '🏊',
  '🎈',
  '⭐',
];

/// Emoji + name + number form shared by tasks and rewards.
class ItemForm extends StatefulWidget {
  const ItemForm({
    super.key,
    required this.title,
    required this.nameLabel,
    required this.valueLabel,
    required this.initialEmoji,
    required this.initialName,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.submitLabel,
  });

  final String title;
  final String nameLabel;
  final String valueLabel;
  final String initialEmoji;
  final String initialName;
  final int initialValue;
  final int minValue;
  final int maxValue;
  final String submitLabel;

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  late String _emoji = widget.initialEmoji;
  late final _name = TextEditingController(text: widget.initialName);
  late final _value = TextEditingController(text: '${widget.initialValue}');
  final _customEmoji = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _value.dispose();
    _customEmoji.dispose();
    super.dispose();
  }

  int? get _parsedValue {
    final v = int.tryParse(_value.text);
    return v == null || v < widget.minValue || v > widget.maxValue ? null : v;
  }

  bool get _valid => _name.text.trim().isNotEmpty && _parsedValue != null;

  void _step(int delta) {
    final v = (_parsedValue ?? widget.initialValue) + delta;
    setState(
      () => _value.text = '${v.clamp(widget.minValue, widget.maxValue)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.title, style: textTheme.titleLarge),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.emojiLabel, style: textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final e in {_emoji, ..._emojiChoices})
              _EmojiChoice(
                emoji: e,
                selected: e == _emoji,
                onTap: () => setState(() => _emoji = e),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _customEmoji,
          decoration: InputDecoration(hintText: l10n.emojiCustomHint),
          onChanged: (text) {
            final first = text.trim().characters.firstOrNull;
            if (first != null) setState(() => _emoji = first);
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: widget.nameLabel),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: Text(widget.valueLabel, style: textTheme.labelLarge),
            ),
            IconButton.outlined(
              tooltip: l10n.decrease,
              onPressed: () => _step(-1),
              icon: const Icon(Icons.remove),
            ),
            SizedBox(
              width: 72,
              child: TextField(
                controller: _value,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                onChanged: (_) => setState(() {}),
              ),
            ),
            IconButton.outlined(
              tooltip: l10n.increase,
              onPressed: () => _step(1),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            const SizedBox(width: AppSpacing.sm),
            FilledButton(
              onPressed: _valid
                  ? () => Navigator.pop<ItemFormResult>(context, (
                      emoji: _emoji,
                      title: _name.text.trim(),
                      value: _parsedValue!,
                    ))
                  : null,
              child: Text(widget.submitLabel),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmojiChoice extends StatelessWidget {
  const _EmojiChoice({
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Semantics(
      selected: selected,
      button: true,
      label: emoji,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? c.primarySoft : c.surfaceInset,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: selected ? c.primary : c.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 22)),
        ),
      ),
    );
  }
}

/// Single required name field, used to add or rename a kid.
class NameForm extends StatefulWidget {
  const NameForm({
    super.key,
    required this.title,
    required this.label,
    required this.initialName,
    required this.submitLabel,
  });

  final String title;
  final String label;
  final String initialName;
  final String submitLabel;

  @override
  State<NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  late final _name = TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isNotEmpty) Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final empty = _name.text.trim().isEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _name,
          autofocus: true,
          maxLength: 30,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: widget.label),
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            const SizedBox(width: AppSpacing.sm),
            FilledButton(
              onPressed: empty ? null : _submit,
              child: Text(widget.submitLabel),
            ),
          ],
        ),
      ],
    );
  }
}
