// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My To-Do List';

  @override
  String get slogan => 'Be kind • Try your best • Have fun!';

  @override
  String get languageMenuTooltip => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get tabToday => 'Today';

  @override
  String get tabWeek => 'This Week';

  @override
  String get tabRewards => 'Rewards';

  @override
  String get tabProgress => 'Progress';

  @override
  String weekdayShort(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'mon': 'Mon',
      'tue': 'Tue',
      'wed': 'Wed',
      'thu': 'Thu',
      'fri': 'Fri',
      'sat': 'Sat',
      'sun': 'Sun',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get previousWeek => 'Previous week';

  @override
  String get nextWeek => 'Next week';

  @override
  String get backToThisWeek => 'Back to this week';

  @override
  String get mustDoTasks => 'Must-Do Tasks';

  @override
  String get optionalTasks => 'Optional Tasks';

  @override
  String get columnPoints => 'Points';

  @override
  String get columnTotal => 'Total';

  @override
  String get dailyTotal => 'Daily total';

  @override
  String get dayTotal => 'Points for the day';

  @override
  String get futureDayHint => 'Stars unlock on that day.';

  @override
  String get noTasks => 'No tasks yet. Add some in Edit lists.';

  @override
  String starDone(String task, String day) {
    return '$task, $day: done';
  }

  @override
  String starNotDone(String task, String day) {
    return '$task, $day: not done';
  }

  @override
  String starLocked(String task, String day) {
    return '$task, $day: not yet';
  }

  @override
  String get pointsToday => 'My Points Today';

  @override
  String get pointsThisWeek => 'This week';

  @override
  String get pointsTotalEarned => 'Total earned';

  @override
  String get pointsLeftToSpend => 'Left to spend';

  @override
  String get rewards => 'Rewards';

  @override
  String pointsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points left',
      one: '1 point left',
    );
    return '$_temp0';
  }

  @override
  String needMore(int count) {
    return 'Need $count more';
  }

  @override
  String get redeem => 'Redeem';

  @override
  String redeemConfirm(int cost, String reward) {
    return 'Spend $cost ⭐ on \"$reward\"?';
  }

  @override
  String redeemDone(String kid, String reward) {
    return '$kid got \"$reward\"!';
  }

  @override
  String get redeemedHistory => 'Redeemed';

  @override
  String get noRedemptions => 'Nothing redeemed yet.';

  @override
  String get myLevels => 'My Levels';

  @override
  String levelNumber(int number) {
    return 'Level $number';
  }

  @override
  String levelRange(int min, int max) {
    return '($min–$max pts)';
  }

  @override
  String levelRangeOpen(int min) {
    return '($min+ pts)';
  }

  @override
  String levelProgress(
    String kid,
    int points,
    int missing,
    int number,
    String level,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points points',
      one: '1 point',
    );
    return '$kid has $_temp0. $missing more to reach Level $number ($level).';
  }

  @override
  String levelTop(String kid, int points) {
    return '$kid has $points points and reached the top level!';
  }

  @override
  String get streakTitle => '7-Day Streak Bonus';

  @override
  String get streakDescription =>
      'Finish all must-do tasks every day from Mon to Sun →';

  @override
  String streakReward(int bonus) {
    return '+$bonus points!';
  }

  @override
  String streakProgress(int done) {
    return '$done/7 days with every must-do task done.';
  }

  @override
  String streakEarned(int bonus) {
    return '7/7! The +$bonus bonus is added.';
  }

  @override
  String get notes => 'Notes';

  @override
  String notesHint(String kid) {
    return 'Parent notes for $kid this week...';
  }

  @override
  String get dataBanner => 'Data is stored on this device.';

  @override
  String get editLists => 'Edit lists';

  @override
  String get footerHint =>
      'Tap a star when a task is done. Each kid has their own stars and points.';

  @override
  String get pinEnterTitle => 'Enter parent PIN';

  @override
  String get pinSetTitle => 'Set a PIN';

  @override
  String get pinConfirmTitle => 'Enter the PIN again';

  @override
  String get pinSetSubtitle =>
      '4 digits, asked for when redeeming rewards and editing lists.';

  @override
  String get pinWrong => 'Wrong PIN';

  @override
  String get pinMismatch => 'The two PINs don\'t match. Try again.';

  @override
  String get pinForgot => 'Forgot PIN?';

  @override
  String pinQuestion(int a, int b) {
    return 'What is $a × $b?';
  }

  @override
  String get pinQuestionHint => 'Answer this to set a new PIN.';

  @override
  String get pinAnswer => 'Answer';

  @override
  String get pinAnswerWrong => 'Not quite. Here is another one.';

  @override
  String get pinCheck => 'Check';

  @override
  String pinFieldLabel(int count) {
    return 'PIN, $count of 4 digits entered';
  }

  @override
  String get pinChanged => 'PIN changed';

  @override
  String get manageMustDo => 'Must-do';

  @override
  String get manageOptional => 'Optional';

  @override
  String get manageRewards => 'Rewards';

  @override
  String get manageKids => 'Kids';

  @override
  String get managePin => 'PIN';

  @override
  String get reorderHint => 'Drag the handle to reorder.';

  @override
  String get addTask => 'Add task';

  @override
  String get editTask => 'Edit task';

  @override
  String get taskName => 'Task name';

  @override
  String get taskPoints => 'Points';

  @override
  String deleteTaskTitle(String task) {
    return 'Remove \"$task\"?';
  }

  @override
  String get deleteTaskBody => 'Points already earned from this task are kept.';

  @override
  String get addReward => 'Add reward';

  @override
  String get editReward => 'Edit reward';

  @override
  String get rewardName => 'Reward';

  @override
  String get rewardCost => 'Cost (⭐)';

  @override
  String deleteRewardTitle(String reward) {
    return 'Remove \"$reward\"?';
  }

  @override
  String get deleteRewardBody => 'Past redemptions stay in the history.';

  @override
  String get addKid => 'Add kid';

  @override
  String get renameKid => 'Rename kid';

  @override
  String get kidName => 'Kid\'s name';

  @override
  String deleteKidTitle(String kid) {
    return 'Delete $kid?';
  }

  @override
  String deleteKidBody(String kid) {
    return 'All of $kid\'s stars, points, redeemed rewards and notes will be deleted. This can\'t be undone.';
  }

  @override
  String get changePin => 'Change PIN';

  @override
  String get pinSectionBody =>
      'The PIN is asked for when redeeming rewards and when opening this screen.';

  @override
  String get emojiLabel => 'Icon';

  @override
  String get emojiCustomHint => 'Or type any emoji';

  @override
  String pointsValue(int points) {
    return '+$points';
  }

  @override
  String costValue(int cost) {
    return '$cost ⭐';
  }

  @override
  String get decrease => 'Decrease';

  @override
  String get increase => 'Increase';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get remove => 'Remove';

  @override
  String get edit => 'Edit';

  @override
  String get seedKid1 => 'Kid 1';

  @override
  String get seedKid2 => 'Kid 2';

  @override
  String get seedTaskMakeBed => 'Make the bed after waking up';

  @override
  String get seedTaskBrushTeeth => 'Brush teeth morning + night';

  @override
  String get seedTaskGetDressed =>
      'Get dressed and put dirty clothes in the basket';

  @override
  String get seedTaskPackBag => 'Pack the school bag';

  @override
  String get seedTaskEatNeatly => 'Eat neatly without many reminders';

  @override
  String get seedTaskTidyToys => 'Put toys away after playing';

  @override
  String get seedTaskHomework => 'Finish today\'s homework';

  @override
  String get seedTaskBedtime => 'Bath, pajamas, ready for bed';

  @override
  String get seedTaskReading => 'Read for 15–20 minutes';

  @override
  String get seedTaskChore => 'Offer to help with a chore';

  @override
  String get seedTaskFoldClothes => 'Fold or put away clothes';

  @override
  String get seedTaskPlants => 'Water or care for the plants';

  @override
  String get seedTaskCreative => 'Draw, craft or make something';

  @override
  String get seedTaskOutdoor => 'Play outside for 30+ minutes';

  @override
  String get seedTaskEnglish => '15 extra minutes of English';

  @override
  String get seedTaskLearnNew => 'Learn something new and tell Mom or Dad';

  @override
  String get seedTaskGoodDeed => 'Do a good deed without being asked';

  @override
  String get seedRewardDessert => 'Pick a favorite dessert';

  @override
  String get seedRewardMovie => 'Pick the family movie';

  @override
  String get seedRewardGame => 'Pick the family game';

  @override
  String get seedRewardOuting => 'Choose the weekend outing';

  @override
  String get seedRewardTreat => 'A small treat of your choice';

  @override
  String get seedRewardExperience =>
      'A special experience: a trip, a workshop, a theme park…';

  @override
  String get seedLevel1 => 'Little Helper';

  @override
  String get seedLevel2 => 'Super Helper';

  @override
  String get seedLevel3 => 'Family Hero';

  @override
  String get seedLevel4 => 'Independent Kid';
}
