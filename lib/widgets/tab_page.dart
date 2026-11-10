import 'package:flutter/material.dart';

import '../core/layout/layout_config.dart';

/// Scrollable column of cards with the device group's margins and gaps.
class TabPage extends StatelessWidget {
  const TabPage({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final config = LayoutConfig.of(context);
    return ListView.separated(
      padding: EdgeInsets.all(config.screenMargin),
      itemCount: children.length,
      itemBuilder: (context, i) => children[i],
      separatorBuilder: (context, i) => SizedBox(height: config.cardGap),
    );
  }
}
