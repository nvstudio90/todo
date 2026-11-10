import 'package:flutter/material.dart';

import '../../domain/models/models.dart';
import '../../widgets/app_header.dart';
import '../../widgets/tab_page.dart';
import 'week_table.dart';

class WeekTab extends StatelessWidget {
  const WeekTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabPage(
      children: [
        AppHeader(),
        WeekTable(type: TaskType.mustDo),
        WeekTable(type: TaskType.optional),
      ],
    );
  }
}
