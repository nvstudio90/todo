import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../home/home_state.dart';
import '../pin/pin_dialog.dart';

const manageRoute = '/manage';

/// The router locks the screen again when it is left.
Future<void> openManageScreen(BuildContext context, WidgetRef ref) async {
  final ok = await requestParentPin(context, ref);
  if (!ok || !context.mounted) return;
  ref.read(manageUnlockedProvider.notifier).unlock();
  await context.push(manageRoute);
}
