import '../domain/models/models.dart';
import '../domain/scoring/levels.dart';
import 'app_localizations.dart';

/// Text for rows the app seeded, in the current app language.
String seedText(AppLocalizations l10n, String key) => switch (key) {
  'kid1' => l10n.seedKid1,
  'kid2' => l10n.seedKid2,
  'makeBed' => l10n.seedTaskMakeBed,
  'brushTeeth' => l10n.seedTaskBrushTeeth,
  'getDressed' => l10n.seedTaskGetDressed,
  'packBag' => l10n.seedTaskPackBag,
  'eatNeatly' => l10n.seedTaskEatNeatly,
  'tidyToys' => l10n.seedTaskTidyToys,
  'homework' => l10n.seedTaskHomework,
  'bedtime' => l10n.seedTaskBedtime,
  'reading' => l10n.seedTaskReading,
  'chore' => l10n.seedTaskChore,
  'foldClothes' => l10n.seedTaskFoldClothes,
  'plants' => l10n.seedTaskPlants,
  'creative' => l10n.seedTaskCreative,
  'outdoor' => l10n.seedTaskOutdoor,
  'english' => l10n.seedTaskEnglish,
  'learnNew' => l10n.seedTaskLearnNew,
  'goodDeed' => l10n.seedTaskGoodDeed,
  'dessert' => l10n.seedRewardDessert,
  'movie' => l10n.seedRewardMovie,
  'game' => l10n.seedRewardGame,
  'outing' => l10n.seedRewardOuting,
  'treat' => l10n.seedRewardTreat,
  'experience' => l10n.seedRewardExperience,
  'level1' => l10n.seedLevel1,
  'level2' => l10n.seedLevel2,
  'level3' => l10n.seedLevel3,
  'level4' => l10n.seedLevel4,
  _ => key,
};

String _text(AppLocalizations l10n, String? custom, String? seedKey) =>
    custom ?? (seedKey == null ? '' : seedText(l10n, seedKey));

extension KidText on Kid {
  String displayName(AppLocalizations l10n) => _text(l10n, name, seedKey);
}

extension TaskText on TaskItem {
  String displayTitle(AppLocalizations l10n) => _text(l10n, title, seedKey);
}

extension RewardText on Reward {
  String displayTitle(AppLocalizations l10n) => _text(l10n, title, seedKey);
}

extension LevelText on LevelInfo {
  String displayName(AppLocalizations l10n) => seedText(l10n, seedKey);
}

const _weekdayKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

extension WeekdayText on AppLocalizations {
  /// [day] is any date; only its weekday matters.
  String weekdayOf(DateTime day) =>
      weekdayShort(_weekdayKeys[day.weekday - DateTime.monday]);
}
