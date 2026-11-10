import 'package:flutter/material.dart';

import '../../core/layout/layout_config.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_header.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/tab_page.dart';
import 'level_track.dart';
import 'notes_card.dart';
import 'streak_card.dart';

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    final config = LayoutConfig.of(context);
    return TabPage(
      children: [
        const AppHeader(),
        LevelTrack(twoRows: !config.isLandscape),
        if (config.isLandscape)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: StreakCard()),
              SizedBox(width: config.cardGap),
              const Expanded(child: NotesCard()),
            ],
          )
        else ...const [StreakCard(), NotesCard()],
        InfoBanner(text: AppLocalizations.of(context).dataBanner),
      ],
    );
  }
}
