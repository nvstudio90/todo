import 'package:flutter/material.dart';

import '../../widgets/app_header.dart';
import '../../widgets/tab_page.dart';
import 'rewards_section.dart';

class RewardsTab extends StatelessWidget {
  const RewardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabPage(children: [AppHeader(), RewardsSection()]);
  }
}
