import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'My To-Do List'**
  String get appTitle;

  /// No description provided for @slogan.
  ///
  /// In en, this message translates to:
  /// **'Be kind • Try your best • Have fun!'**
  String get slogan;

  /// No description provided for @languageMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageMenuTooltip;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @tabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// No description provided for @tabWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get tabWeek;

  /// No description provided for @tabRewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get tabRewards;

  /// No description provided for @tabProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get tabProgress;

  /// No description provided for @weekdayShort.
  ///
  /// In en, this message translates to:
  /// **'{day, select, mon{Mon} tue{Tue} wed{Wed} thu{Thu} fri{Fri} sat{Sat} sun{Sun} other{}}'**
  String weekdayShort(String day);

  /// No description provided for @previousWeek.
  ///
  /// In en, this message translates to:
  /// **'Previous week'**
  String get previousWeek;

  /// No description provided for @nextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get nextWeek;

  /// No description provided for @backToThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Back to this week'**
  String get backToThisWeek;

  /// No description provided for @mustDoTasks.
  ///
  /// In en, this message translates to:
  /// **'Must-Do Tasks'**
  String get mustDoTasks;

  /// No description provided for @optionalTasks.
  ///
  /// In en, this message translates to:
  /// **'Optional Tasks'**
  String get optionalTasks;

  /// No description provided for @columnPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get columnPoints;

  /// No description provided for @columnTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get columnTotal;

  /// No description provided for @dailyTotal.
  ///
  /// In en, this message translates to:
  /// **'Daily total'**
  String get dailyTotal;

  /// No description provided for @dayTotal.
  ///
  /// In en, this message translates to:
  /// **'Points for the day'**
  String get dayTotal;

  /// No description provided for @futureDayHint.
  ///
  /// In en, this message translates to:
  /// **'Stars unlock on that day.'**
  String get futureDayHint;

  /// No description provided for @noTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet. Add some in Edit lists.'**
  String get noTasks;

  /// No description provided for @starDone.
  ///
  /// In en, this message translates to:
  /// **'{task}, {day}: done'**
  String starDone(String task, String day);

  /// No description provided for @starNotDone.
  ///
  /// In en, this message translates to:
  /// **'{task}, {day}: not done'**
  String starNotDone(String task, String day);

  /// No description provided for @starLocked.
  ///
  /// In en, this message translates to:
  /// **'{task}, {day}: not yet'**
  String starLocked(String task, String day);

  /// No description provided for @pointsToday.
  ///
  /// In en, this message translates to:
  /// **'My Points Today'**
  String get pointsToday;

  /// No description provided for @pointsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get pointsThisWeek;

  /// No description provided for @pointsTotalEarned.
  ///
  /// In en, this message translates to:
  /// **'Total earned'**
  String get pointsTotalEarned;

  /// No description provided for @pointsLeftToSpend.
  ///
  /// In en, this message translates to:
  /// **'Left to spend'**
  String get pointsLeftToSpend;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @pointsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 point left} other{{count} points left}}'**
  String pointsLeft(int count);

  /// No description provided for @needMore.
  ///
  /// In en, this message translates to:
  /// **'Need {count} more'**
  String needMore(int count);

  /// No description provided for @redeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get redeem;

  /// No description provided for @redeemConfirm.
  ///
  /// In en, this message translates to:
  /// **'Spend {cost} ⭐ on \"{reward}\"?'**
  String redeemConfirm(int cost, String reward);

  /// No description provided for @redeemDone.
  ///
  /// In en, this message translates to:
  /// **'{kid} got \"{reward}\"!'**
  String redeemDone(String kid, String reward);

  /// No description provided for @redeemedHistory.
  ///
  /// In en, this message translates to:
  /// **'Redeemed'**
  String get redeemedHistory;

  /// No description provided for @noRedemptions.
  ///
  /// In en, this message translates to:
  /// **'Nothing redeemed yet.'**
  String get noRedemptions;

  /// No description provided for @myLevels.
  ///
  /// In en, this message translates to:
  /// **'My Levels'**
  String get myLevels;

  /// No description provided for @levelNumber.
  ///
  /// In en, this message translates to:
  /// **'Level {number}'**
  String levelNumber(int number);

  /// No description provided for @levelRange.
  ///
  /// In en, this message translates to:
  /// **'({min}–{max} pts)'**
  String levelRange(int min, int max);

  /// No description provided for @levelRangeOpen.
  ///
  /// In en, this message translates to:
  /// **'({min}+ pts)'**
  String levelRangeOpen(int min);

  /// No description provided for @levelProgress.
  ///
  /// In en, this message translates to:
  /// **'{kid} has {points, plural, =1{1 point} other{{points} points}}. {missing} more to reach Level {number} ({level}).'**
  String levelProgress(
    String kid,
    int points,
    int missing,
    int number,
    String level,
  );

  /// No description provided for @levelTop.
  ///
  /// In en, this message translates to:
  /// **'{kid} has {points} points and reached the top level!'**
  String levelTop(String kid, int points);

  /// No description provided for @streakTitle.
  ///
  /// In en, this message translates to:
  /// **'7-Day Streak Bonus'**
  String get streakTitle;

  /// No description provided for @streakDescription.
  ///
  /// In en, this message translates to:
  /// **'Finish all must-do tasks every day from Mon to Sun →'**
  String get streakDescription;

  /// No description provided for @streakReward.
  ///
  /// In en, this message translates to:
  /// **'+{bonus} points!'**
  String streakReward(int bonus);

  /// No description provided for @streakProgress.
  ///
  /// In en, this message translates to:
  /// **'{done}/7 days with every must-do task done.'**
  String streakProgress(int done);

  /// No description provided for @streakEarned.
  ///
  /// In en, this message translates to:
  /// **'7/7! The +{bonus} bonus is added.'**
  String streakEarned(int bonus);

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Parent notes for {kid} this week...'**
  String notesHint(String kid);

  /// No description provided for @dataBanner.
  ///
  /// In en, this message translates to:
  /// **'Data is stored on this device.'**
  String get dataBanner;

  /// No description provided for @editLists.
  ///
  /// In en, this message translates to:
  /// **'Edit lists'**
  String get editLists;

  /// No description provided for @footerHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a star when a task is done. Each kid has their own stars and points.'**
  String get footerHint;

  /// No description provided for @pinEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter parent PIN'**
  String get pinEnterTitle;

  /// No description provided for @pinSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN'**
  String get pinSetTitle;

  /// No description provided for @pinConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the PIN again'**
  String get pinConfirmTitle;

  /// No description provided for @pinSetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'4 digits, asked for when redeeming rewards and editing lists.'**
  String get pinSetSubtitle;

  /// No description provided for @pinWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN'**
  String get pinWrong;

  /// No description provided for @pinMismatch.
  ///
  /// In en, this message translates to:
  /// **'The two PINs don\'t match. Try again.'**
  String get pinMismatch;

  /// No description provided for @pinForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get pinForgot;

  /// No description provided for @pinQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is {a} × {b}?'**
  String pinQuestion(int a, int b);

  /// No description provided for @pinQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'Answer this to set a new PIN.'**
  String get pinQuestionHint;

  /// No description provided for @pinAnswer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get pinAnswer;

  /// No description provided for @pinAnswerWrong.
  ///
  /// In en, this message translates to:
  /// **'Not quite. Here is another one.'**
  String get pinAnswerWrong;

  /// No description provided for @pinCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get pinCheck;

  /// No description provided for @pinFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'PIN, {count} of 4 digits entered'**
  String pinFieldLabel(int count);

  /// No description provided for @pinChanged.
  ///
  /// In en, this message translates to:
  /// **'PIN changed'**
  String get pinChanged;

  /// No description provided for @manageMustDo.
  ///
  /// In en, this message translates to:
  /// **'Must-do'**
  String get manageMustDo;

  /// No description provided for @manageOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get manageOptional;

  /// No description provided for @manageRewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get manageRewards;

  /// No description provided for @manageKids.
  ///
  /// In en, this message translates to:
  /// **'Kids'**
  String get manageKids;

  /// No description provided for @managePin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get managePin;

  /// No description provided for @reorderHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the handle to reorder.'**
  String get reorderHint;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get addTask;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get editTask;

  /// No description provided for @taskName.
  ///
  /// In en, this message translates to:
  /// **'Task name'**
  String get taskName;

  /// No description provided for @taskPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get taskPoints;

  /// No description provided for @deleteTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{task}\"?'**
  String deleteTaskTitle(String task);

  /// No description provided for @deleteTaskBody.
  ///
  /// In en, this message translates to:
  /// **'Points already earned from this task are kept.'**
  String get deleteTaskBody;

  /// No description provided for @addReward.
  ///
  /// In en, this message translates to:
  /// **'Add reward'**
  String get addReward;

  /// No description provided for @editReward.
  ///
  /// In en, this message translates to:
  /// **'Edit reward'**
  String get editReward;

  /// No description provided for @rewardName.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get rewardName;

  /// No description provided for @rewardCost.
  ///
  /// In en, this message translates to:
  /// **'Cost (⭐)'**
  String get rewardCost;

  /// No description provided for @deleteRewardTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{reward}\"?'**
  String deleteRewardTitle(String reward);

  /// No description provided for @deleteRewardBody.
  ///
  /// In en, this message translates to:
  /// **'Past redemptions stay in the history.'**
  String get deleteRewardBody;

  /// No description provided for @addKid.
  ///
  /// In en, this message translates to:
  /// **'Add kid'**
  String get addKid;

  /// No description provided for @renameKid.
  ///
  /// In en, this message translates to:
  /// **'Rename kid'**
  String get renameKid;

  /// No description provided for @kidName.
  ///
  /// In en, this message translates to:
  /// **'Kid\'s name'**
  String get kidName;

  /// No description provided for @deleteKidTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {kid}?'**
  String deleteKidTitle(String kid);

  /// No description provided for @deleteKidBody.
  ///
  /// In en, this message translates to:
  /// **'All of {kid}\'s stars, points, redeemed rewards and notes will be deleted. This can\'t be undone.'**
  String deleteKidBody(String kid);

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @pinSectionBody.
  ///
  /// In en, this message translates to:
  /// **'The PIN is asked for when redeeming rewards and when opening this screen.'**
  String get pinSectionBody;

  /// No description provided for @emojiLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get emojiLabel;

  /// No description provided for @emojiCustomHint.
  ///
  /// In en, this message translates to:
  /// **'Or type any emoji'**
  String get emojiCustomHint;

  /// No description provided for @pointsValue.
  ///
  /// In en, this message translates to:
  /// **'+{points}'**
  String pointsValue(int points);

  /// No description provided for @costValue.
  ///
  /// In en, this message translates to:
  /// **'{cost} ⭐'**
  String costValue(int cost);

  /// No description provided for @decrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get decrease;

  /// No description provided for @increase.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get increase;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @seedKid1.
  ///
  /// In en, this message translates to:
  /// **'Kid 1'**
  String get seedKid1;

  /// No description provided for @seedKid2.
  ///
  /// In en, this message translates to:
  /// **'Kid 2'**
  String get seedKid2;

  /// No description provided for @seedTaskMakeBed.
  ///
  /// In en, this message translates to:
  /// **'Make the bed after waking up'**
  String get seedTaskMakeBed;

  /// No description provided for @seedTaskBrushTeeth.
  ///
  /// In en, this message translates to:
  /// **'Brush teeth morning + night'**
  String get seedTaskBrushTeeth;

  /// No description provided for @seedTaskGetDressed.
  ///
  /// In en, this message translates to:
  /// **'Get dressed and put dirty clothes in the basket'**
  String get seedTaskGetDressed;

  /// No description provided for @seedTaskPackBag.
  ///
  /// In en, this message translates to:
  /// **'Pack the school bag'**
  String get seedTaskPackBag;

  /// No description provided for @seedTaskEatNeatly.
  ///
  /// In en, this message translates to:
  /// **'Eat neatly without many reminders'**
  String get seedTaskEatNeatly;

  /// No description provided for @seedTaskTidyToys.
  ///
  /// In en, this message translates to:
  /// **'Put toys away after playing'**
  String get seedTaskTidyToys;

  /// No description provided for @seedTaskHomework.
  ///
  /// In en, this message translates to:
  /// **'Finish today\'s homework'**
  String get seedTaskHomework;

  /// No description provided for @seedTaskBedtime.
  ///
  /// In en, this message translates to:
  /// **'Bath, pajamas, ready for bed'**
  String get seedTaskBedtime;

  /// No description provided for @seedTaskReading.
  ///
  /// In en, this message translates to:
  /// **'Read for 15–20 minutes'**
  String get seedTaskReading;

  /// No description provided for @seedTaskChore.
  ///
  /// In en, this message translates to:
  /// **'Offer to help with a chore'**
  String get seedTaskChore;

  /// No description provided for @seedTaskFoldClothes.
  ///
  /// In en, this message translates to:
  /// **'Fold or put away clothes'**
  String get seedTaskFoldClothes;

  /// No description provided for @seedTaskPlants.
  ///
  /// In en, this message translates to:
  /// **'Water or care for the plants'**
  String get seedTaskPlants;

  /// No description provided for @seedTaskCreative.
  ///
  /// In en, this message translates to:
  /// **'Draw, craft or make something'**
  String get seedTaskCreative;

  /// No description provided for @seedTaskOutdoor.
  ///
  /// In en, this message translates to:
  /// **'Play outside for 30+ minutes'**
  String get seedTaskOutdoor;

  /// No description provided for @seedTaskEnglish.
  ///
  /// In en, this message translates to:
  /// **'15 extra minutes of English'**
  String get seedTaskEnglish;

  /// No description provided for @seedTaskLearnNew.
  ///
  /// In en, this message translates to:
  /// **'Learn something new and tell Mom or Dad'**
  String get seedTaskLearnNew;

  /// No description provided for @seedTaskGoodDeed.
  ///
  /// In en, this message translates to:
  /// **'Do a good deed without being asked'**
  String get seedTaskGoodDeed;

  /// No description provided for @seedRewardDessert.
  ///
  /// In en, this message translates to:
  /// **'Pick a favorite dessert'**
  String get seedRewardDessert;

  /// No description provided for @seedRewardMovie.
  ///
  /// In en, this message translates to:
  /// **'Pick the family movie'**
  String get seedRewardMovie;

  /// No description provided for @seedRewardGame.
  ///
  /// In en, this message translates to:
  /// **'Pick the family game'**
  String get seedRewardGame;

  /// No description provided for @seedRewardOuting.
  ///
  /// In en, this message translates to:
  /// **'Choose the weekend outing'**
  String get seedRewardOuting;

  /// No description provided for @seedRewardTreat.
  ///
  /// In en, this message translates to:
  /// **'A small treat of your choice'**
  String get seedRewardTreat;

  /// No description provided for @seedRewardExperience.
  ///
  /// In en, this message translates to:
  /// **'A special experience: a trip, a workshop, a theme park…'**
  String get seedRewardExperience;

  /// No description provided for @seedLevel1.
  ///
  /// In en, this message translates to:
  /// **'Little Helper'**
  String get seedLevel1;

  /// No description provided for @seedLevel2.
  ///
  /// In en, this message translates to:
  /// **'Super Helper'**
  String get seedLevel2;

  /// No description provided for @seedLevel3.
  ///
  /// In en, this message translates to:
  /// **'Family Hero'**
  String get seedLevel3;

  /// No description provided for @seedLevel4.
  ///
  /// In en, this message translates to:
  /// **'Independent Kid'**
  String get seedLevel4;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
