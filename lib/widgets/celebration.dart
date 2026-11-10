import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final celebrationProvider = Provider<ConfettiController>((ref) {
  final controller = ConfettiController(duration: const Duration(seconds: 1));
  ref.onDispose(controller.dispose);
  return controller;
});

/// Confetti layer above every route, fired after a reward is redeemed.
class CelebrationOverlay extends ConsumerWidget {
  const CelebrationOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        child,
        Align(
          alignment: Alignment.topCenter,
          child: IgnorePointer(
            child: ConfettiWidget(
              confettiController: ref.watch(celebrationProvider),
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              gravity: 0.3,
              colors: const [
                Color(0xFFF5B800),
                Color(0xFF7B4FD6),
                Color(0xFFC8406E),
                Color(0xFF3FA36B),
                Color(0xFF3A7BE0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
