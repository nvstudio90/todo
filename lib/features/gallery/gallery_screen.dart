import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/utils/dates.dart';
import '../../domain/models/models.dart';
import '../../domain/scoring/levels.dart';
import '../../widgets/app_title.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/kid_chips.dart';
import '../../widgets/points_card.dart';
import '../../widgets/star_toggle.dart';
import '../progress/level_track.dart';
import '../progress/streak_card.dart';
import '../rewards/rewards_section.dart';

/// Debug-only page showing components in their states, without real data.
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  bool _star = false;
  int _kid = 0;

  @override
  Widget build(BuildContext context) {
    final week = Dates.weekStartOf(DateTime.now());
    const reward = Reward(
      id: 1,
      emoji: '🍦',
      title: 'Ice cream',
      cost: 20,
      sortOrder: 0,
    );
    Widget section(String name, Widget child) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(name, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          section(
            'AppTitle / Slogan',
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [AppTitle(fontSize: 36), Slogan()],
            ),
          ),
          section(
            'KidChip',
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final (i, name) in [
                  'Bé 1',
                  'Bé 2',
                  'A very long kid name',
                ].indexed)
                  KidChip(
                    label: name,
                    selected: _kid == i,
                    onTap: () => setState(() => _kid = i),
                  ),
              ],
            ),
          ),
          section(
            'StarToggle: off / on / locked / big',
            Row(
              children: [
                StarToggle(
                  done: _star,
                  locked: false,
                  points: 2,
                  semanticLabel: 'star',
                  onToggle: () => setState(() => _star = !_star),
                ),
                StarToggle(
                  done: true,
                  locked: false,
                  points: 2,
                  semanticLabel: 'star',
                  onToggle: () {},
                ),
                StarToggle(
                  done: false,
                  locked: true,
                  points: 2,
                  semanticLabel: 'star',
                  onToggle: () {},
                ),
                StarToggle(
                  done: _star,
                  locked: false,
                  points: 3,
                  size: 36,
                  semanticLabel: 'star',
                  onToggle: () => setState(() => _star = !_star),
                ),
              ],
            ),
          ),
          section(
            'PointsCard',
            const PointsCardView(
              summary: PointsSummary(
                today: 7,
                week: 12,
                total: 58,
                available: 38,
              ),
            ),
          ),
          section(
            'RewardCard: locked / redeemable',
            Row(
              children: [
                Expanded(
                  child: RewardCard(
                    reward: reward,
                    available: 12,
                    onRedeem: () {},
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: RewardCard(
                    reward: reward,
                    available: 30,
                    onRedeem: () {},
                  ),
                ),
              ],
            ),
          ),
          section(
            'LevelTrack',
            LevelTrackView(
              kidName: 'Bé 1',
              progress: LevelProgress.forPoints(62),
            ),
          ),
          section(
            'StreakCard',
            StreakCardView(
              weekStart: week,
              doneDays: const [true, true, true, false, false, false, false],
            ),
          ),
          section(
            'InfoBanner',
            const InfoBanner(text: 'Data is stored on this device.'),
          ),
        ],
      ),
    );
  }
}
