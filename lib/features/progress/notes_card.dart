import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout/layout_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/providers.dart';
import '../../data/repositories/note_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/seed_text.dart';
import '../../widgets/section_card.dart';
import '../home/home_state.dart';

class NotesCard extends ConsumerWidget {
  const NotesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final config = LayoutConfig.of(context);
    final kid = ref.watch(currentKidProvider);
    final week = ref.watch(selectedWeekProvider);

    return AppCard(
      color: c.notesBg,
      borderColor: c.notesBg,
      padding: EdgeInsets.all(config.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(emoji: '✏️', title: l10n.notes),
          const SizedBox(height: AppSpacing.sm),
          if (kid != null)
            _NoteEditor(
              // A new editor per kid and week keeps drafts from leaking across.
              key: ValueKey((kid.id, week)),
              repository: ref.read(noteRepositoryProvider),
              kidId: kid.id,
              weekStart: week,
              hint: l10n.notesHint(kid.displayName(l10n)),
            ),
        ],
      ),
    );
  }
}

class _NoteEditor extends StatefulWidget {
  const _NoteEditor({
    super.key,
    required this.repository,
    required this.kidId,
    required this.weekStart,
    required this.hint,
  });

  final NoteRepository repository;
  final int kidId;
  final DateTime weekStart;
  final String hint;

  @override
  State<_NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<_NoteEditor> {
  final _controller = TextEditingController();
  Timer? _debounce;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final note = await widget.repository.load(widget.kidId, widget.weekStart);
    if (!mounted || _dirty || note == null) return;
    _controller.text = note.body;
  }

  void _onChanged(String _) {
    _dirty = true;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _save);
  }

  Future<void> _save() async {
    _debounce?.cancel();
    if (!_dirty) return;
    _dirty = false;
    await widget.repository.save(
      widget.kidId,
      widget.weekStart,
      _controller.text,
    );
  }

  @override
  void dispose() {
    // Flush a pending edit, e.g. when a fold switches layouts mid-typing.
    unawaited(_save());
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final style = AppTypography.bodyMedium.copyWith(color: c.textPrimary);
    final lineHeight = MediaQuery.textScalerOf(context).scale(14) * 20 / 14;
    return CustomPaint(
      painter: _RuledLines(
        color: c.textPrimary.withValues(alpha: 0.15),
        spacing: lineHeight,
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        minLines: 4,
        maxLines: 10,
        style: style,
        decoration: InputDecoration(
          hintText: widget.hint,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isCollapsed: true,
        ),
      ),
    );
  }
}

/// Notebook lines under the text, one per text line.
class _RuledLines extends CustomPainter {
  _RuledLines({required this.color, required this.spacing});

  final Color color;
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (var y = spacing; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_RuledLines old) =>
      old.color != color || old.spacing != spacing;
}
