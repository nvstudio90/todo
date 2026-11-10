import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/providers.dart';
import '../../data/repositories/pin_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/dialogs.dart';

/// Asks for the parent PIN, or has the parent create one if none exists yet.
/// With [changePin] it goes straight to setting a new PIN.
Future<bool> requestParentPin(
  BuildContext context,
  WidgetRef ref, {
  bool changePin = false,
}) async {
  final repo = ref.read(pinRepositoryProvider);
  final hasPin = await repo.hasPin();
  if (!context.mounted) return false;
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => PinDialog(
      repository: repo,
      initialStep: hasPin && !changePin ? PinStep.verify : PinStep.create,
    ),
  );
  return ok ?? false;
}

enum PinStep { verify, create, confirm, forgot }

class PinDialog extends StatefulWidget {
  const PinDialog({
    super.key,
    required this.repository,
    required this.initialStep,
    this.random,
  });

  final PinRepository repository;
  final PinStep initialStep;

  /// Injectable so tests can predict the forgot-PIN question.
  final Random? random;

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  late PinStep _step = widget.initialStep;
  late final Random _random = widget.random ?? Random();
  final _pinController = TextEditingController();
  final _answerController = TextEditingController();
  String? _firstPin;
  String? _error;
  int _shakes = 0;
  bool _busy = false;
  late (int, int) _question = _newQuestion();

  (int, int) _newQuestion() =>
      (11 + _random.nextInt(9), 11 + _random.nextInt(9));

  @override
  void dispose() {
    _pinController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _fail(String message) {
    setState(() {
      _error = message;
      _shakes++;
      _pinController.clear();
    });
    unawaited(HapticFeedback.mediumImpact());
  }

  Future<void> _onPinComplete(String pin) async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context);
    switch (_step) {
      case PinStep.verify:
        setState(() => _busy = true);
        final ok = await widget.repository.verify(pin);
        if (!mounted) return;
        setState(() => _busy = false);
        if (ok) {
          Navigator.pop(context, true);
        } else {
          _fail(l10n.pinWrong);
        }
      case PinStep.create:
        setState(() {
          _firstPin = pin;
          _step = PinStep.confirm;
          _error = null;
          _pinController.clear();
        });
      case PinStep.confirm:
        if (pin != _firstPin) {
          _fail(l10n.pinMismatch);
          setState(() => _step = PinStep.create);
          return;
        }
        setState(() => _busy = true);
        await widget.repository.setPin(pin);
        if (mounted) Navigator.pop(context, true);
      case PinStep.forgot:
        break;
    }
  }

  void _checkAnswer() {
    final (a, b) = _question;
    if (int.tryParse(_answerController.text.trim()) == a * b) {
      setState(() {
        _step = PinStep.create;
        _error = null;
        _pinController.clear();
      });
      return;
    }
    setState(() {
      _question = _newQuestion();
      _answerController.clear();
      _error = AppLocalizations.of(context).pinAnswerWrong;
      _shakes++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final title = switch (_step) {
      PinStep.verify => l10n.pinEnterTitle,
      PinStep.create => l10n.pinSetTitle,
      PinStep.confirm => l10n.pinConfirmTitle,
      PinStep.forgot => l10n.pinForgot,
    };

    return AlertDialog(
      insetPadding: dialogInsets(context),
      scrollable: true,
      title: Text(title),
      content:
          Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_step == PinStep.create || _step == PinStep.confirm)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: Text(
                        l10n.pinSetSubtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                    ),
                  if (_step == PinStep.forgot)
                    _ForgotQuestion(
                      question: l10n.pinQuestion(_question.$1, _question.$2),
                      controller: _answerController,
                      onSubmit: _checkAnswer,
                    )
                  else
                    PinField(
                      key: ValueKey(_step),
                      controller: _pinController,
                      onCompleted: _onPinComplete,
                    ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.md),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              )
              .animate(key: ValueKey(_shakes), autoPlay: _shakes > 0)
              .shakeX(hz: 5, amount: 6),
      actionsOverflowButtonSpacing: AppSpacing.sm,
      actions: [
        if (_step == PinStep.verify)
          TextButton(
            onPressed: () => setState(() {
              _step = PinStep.forgot;
              _error = null;
            }),
            child: Text(l10n.pinForgot),
          ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        if (_step == PinStep.forgot)
          FilledButton(onPressed: _checkAnswer, child: Text(l10n.pinCheck)),
      ],
    );
  }
}

class _ForgotQuestion extends StatelessWidget {
  const _ForgotQuestion({
    required this.question,
    required this.controller,
    required this.onSubmit,
  });

  final String question;
  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.pinQuestionHint,
          style: AppTypography.bodyMedium.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(question, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: InputDecoration(labelText: l10n.pinAnswer),
          onSubmitted: (_) => onSubmit(),
        ),
      ],
    );
  }
}

/// Four boxes over an invisible text field so the system number pad is used.
class PinField extends StatefulWidget {
  const PinField({
    super.key,
    required this.controller,
    required this.onCompleted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onCompleted;

  @override
  State<PinField> createState() => _PinFieldState();
}

class _PinFieldState extends State<PinField> with WidgetsBindingObserver {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _focus.addListener(_redraw);
    WidgetsBinding.instance.addObserver(this);
  }

  void _redraw() => setState(() {});

  /// On short landscape screens the keyboard can cover the boxes; keep them
  /// in view as it slides up.
  @override
  void didChangeMetrics() {
    if (!_focus.hasFocus) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(Scrollable.ensureVisible(context, alignment: 0.5));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.removeListener(_onChanged);
    _focus.dispose();
    super.dispose();
  }

  void _onChanged() {
    setState(() {});
    final text = widget.controller.text;
    if (text.length == 4) widget.onCompleted(text);
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    final length = widget.controller.text.length;
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < 4; i++)
              Container(
                width: 48,
                height: 56,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.surfaceInset,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: i == length && _focus.hasFocus
                        ? c.primary
                        : c.border,
                    width: i == length && _focus.hasFocus ? 2 : 1,
                  ),
                ),
                child: Text(
                  i < length ? '●' : '',
                  style: AppTypography.titleMedium.copyWith(
                    color: c.textPrimary,
                  ),
                ),
              ),
          ],
        ),
        Positioned.fill(
          child: Semantics(
            label: l10n.pinFieldLabel(length),
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: widget.controller,
                focusNode: _focus,
                autofocus: true,
                keyboardType: TextInputType.number,
                obscureText: true,
                showCursor: false,
                enableInteractiveSelection: false,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: false,
                  counterText: '',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
