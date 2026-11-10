// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Bảng việc của bé';

  @override
  String get slogan => 'Tử tế • Cố gắng • Vui vẻ!';

  @override
  String get languageMenuTooltip => 'Ngôn ngữ';

  @override
  String get languageSystem => 'Theo hệ thống';

  @override
  String get tabToday => 'Hôm nay';

  @override
  String get tabWeek => 'Cả tuần';

  @override
  String get tabRewards => 'Đổi thưởng';

  @override
  String get tabProgress => 'Thành tích';

  @override
  String weekdayShort(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'mon': 'T2',
      'tue': 'T3',
      'wed': 'T4',
      'thu': 'T5',
      'fri': 'T6',
      'sat': 'T7',
      'sun': 'CN',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get previousWeek => 'Tuần trước';

  @override
  String get nextWeek => 'Tuần sau';

  @override
  String get backToThisWeek => 'Về tuần này';

  @override
  String get mustDoTasks => 'Việc bắt buộc';

  @override
  String get optionalTasks => 'Việc tự chọn';

  @override
  String get columnPoints => 'Điểm';

  @override
  String get columnTotal => 'Tổng';

  @override
  String get dailyTotal => 'Tổng điểm theo ngày';

  @override
  String get dayTotal => 'Tổng điểm trong ngày';

  @override
  String get futureDayHint => 'Tới ngày đó mới đánh sao được.';

  @override
  String get noTasks => 'Chưa có việc nào. Thêm trong Sửa danh sách.';

  @override
  String starDone(String task, String day) {
    return '$task, $day: đã làm';
  }

  @override
  String starNotDone(String task, String day) {
    return '$task, $day: chưa làm';
  }

  @override
  String starLocked(String task, String day) {
    return '$task, $day: chưa tới ngày';
  }

  @override
  String get pointsToday => 'Điểm hôm nay';

  @override
  String get pointsThisWeek => 'Tuần này';

  @override
  String get pointsTotalEarned => 'Tổng đã tích';

  @override
  String get pointsLeftToSpend => 'Còn lại để đổi';

  @override
  String get rewards => 'Đổi thưởng';

  @override
  String pointsLeft(int count) {
    return 'Còn $count điểm';
  }

  @override
  String needMore(int count) {
    return 'Cần thêm $count điểm';
  }

  @override
  String get redeem => 'Đổi ngay';

  @override
  String redeemConfirm(int cost, String reward) {
    return 'Đổi $cost ⭐ lấy \"$reward\"?';
  }

  @override
  String redeemDone(String kid, String reward) {
    return '$kid đã đổi \"$reward\"!';
  }

  @override
  String get redeemedHistory => 'Đã đổi';

  @override
  String get noRedemptions => 'Chưa đổi phần thưởng nào.';

  @override
  String get myLevels => 'Cấp độ';

  @override
  String levelNumber(int number) {
    return 'Cấp $number';
  }

  @override
  String levelRange(int min, int max) {
    return '($min–$maxđ)';
  }

  @override
  String levelRangeOpen(int min) {
    return '($min+đ)';
  }

  @override
  String levelProgress(
    String kid,
    int points,
    int missing,
    int number,
    String level,
  ) {
    return '$kid có $points điểm. Còn $missing điểm nữa để lên Cấp $number ($level).';
  }

  @override
  String levelTop(String kid, int points) {
    return '$kid có $points điểm và đã đạt cấp cao nhất!';
  }

  @override
  String get streakTitle => 'Thưởng chuỗi 7 ngày';

  @override
  String get streakDescription =>
      'Làm hết việc bắt buộc cả 7 ngày từ T2 đến CN →';

  @override
  String streakReward(int bonus) {
    return '+$bonus điểm!';
  }

  @override
  String streakProgress(int done) {
    return '$done/7 ngày đã xong hết việc bắt buộc.';
  }

  @override
  String streakEarned(int bonus) {
    return 'Đủ 7/7! Đã cộng thưởng +$bonus điểm.';
  }

  @override
  String get notes => 'Ghi chú';

  @override
  String notesHint(String kid) {
    return 'Ghi chú của bố mẹ cho $kid tuần này...';
  }

  @override
  String get dataBanner => 'Dữ liệu được lưu trên máy này.';

  @override
  String get editLists => 'Sửa danh sách';

  @override
  String get footerHint =>
      'Bấm vào ngôi sao khi làm xong một việc. Mỗi bé có bảng sao và điểm riêng.';

  @override
  String get pinEnterTitle => 'Nhập mã PIN của bố mẹ';

  @override
  String get pinSetTitle => 'Đặt mã PIN';

  @override
  String get pinConfirmTitle => 'Nhập lại mã PIN';

  @override
  String get pinSetSubtitle =>
      '4 chữ số, dùng khi đổi thưởng và khi sửa danh sách.';

  @override
  String get pinWrong => 'Sai mã PIN';

  @override
  String get pinMismatch => 'Hai lần nhập không khớp. Nhập lại nhé.';

  @override
  String get pinForgot => 'Quên mã PIN?';

  @override
  String pinQuestion(int a, int b) {
    return '$a × $b bằng bao nhiêu?';
  }

  @override
  String get pinQuestionHint => 'Trả lời đúng để đặt mã PIN mới.';

  @override
  String get pinAnswer => 'Kết quả';

  @override
  String get pinAnswerWrong => 'Chưa đúng. Thử câu khác nhé.';

  @override
  String get pinCheck => 'Kiểm tra';

  @override
  String pinFieldLabel(int count) {
    return 'Mã PIN, đã nhập $count trên 4 số';
  }

  @override
  String get pinChanged => 'Đã đổi mã PIN';

  @override
  String get manageMustDo => 'Bắt buộc';

  @override
  String get manageOptional => 'Tự chọn';

  @override
  String get manageRewards => 'Phần thưởng';

  @override
  String get manageKids => 'Các bé';

  @override
  String get managePin => 'Mã PIN';

  @override
  String get reorderHint => 'Kéo tay nắm để sắp xếp.';

  @override
  String get addTask => 'Thêm việc';

  @override
  String get editTask => 'Sửa việc';

  @override
  String get taskName => 'Tên việc';

  @override
  String get taskPoints => 'Điểm';

  @override
  String deleteTaskTitle(String task) {
    return 'Xoá \"$task\"?';
  }

  @override
  String get deleteTaskBody => 'Điểm đã tích từ việc này vẫn được giữ.';

  @override
  String get addReward => 'Thêm phần thưởng';

  @override
  String get editReward => 'Sửa phần thưởng';

  @override
  String get rewardName => 'Phần thưởng';

  @override
  String get rewardCost => 'Giá (⭐)';

  @override
  String deleteRewardTitle(String reward) {
    return 'Xoá \"$reward\"?';
  }

  @override
  String get deleteRewardBody => 'Lịch sử đổi thưởng cũ vẫn được giữ.';

  @override
  String get addKid => 'Thêm bé';

  @override
  String get renameKid => 'Đổi tên bé';

  @override
  String get kidName => 'Tên bé';

  @override
  String deleteKidTitle(String kid) {
    return 'Xoá $kid?';
  }

  @override
  String deleteKidBody(String kid) {
    return 'Toàn bộ sao, điểm, lịch sử đổi thưởng và ghi chú của $kid sẽ bị xoá và không khôi phục được.';
  }

  @override
  String get changePin => 'Đổi mã PIN';

  @override
  String get pinSectionBody =>
      'Mã PIN được hỏi khi đổi thưởng và khi mở màn này.';

  @override
  String get emojiLabel => 'Biểu tượng';

  @override
  String get emojiCustomHint => 'Hoặc gõ một emoji bất kỳ';

  @override
  String pointsValue(int points) {
    return '+$points';
  }

  @override
  String costValue(int cost) {
    return '$cost ⭐';
  }

  @override
  String get decrease => 'Giảm';

  @override
  String get increase => 'Tăng';

  @override
  String get add => 'Thêm';

  @override
  String get save => 'Lưu';

  @override
  String get cancel => 'Huỷ';

  @override
  String get delete => 'Xoá';

  @override
  String get remove => 'Xoá';

  @override
  String get edit => 'Sửa';

  @override
  String get seedKid1 => 'Bé 1';

  @override
  String get seedKid2 => 'Bé 2';

  @override
  String get seedTaskMakeBed => 'Tự gấp chăn/gọn giường sau khi ngủ dậy';

  @override
  String get seedTaskBrushTeeth => 'Đánh răng sáng + tối';

  @override
  String get seedTaskGetDressed => 'Tự mặc quần áo và bỏ đồ bẩn đúng chỗ';

  @override
  String get seedTaskPackBag => 'Chuẩn bị cặp sách/đồ đi học';

  @override
  String get seedTaskEatNeatly => 'Ăn uống gọn gàng, không cần nhắc nhiều';

  @override
  String get seedTaskTidyToys => 'Dọn đồ chơi sau khi chơi';

  @override
  String get seedTaskHomework => 'Hoàn thành bài tập/việc học trong ngày';

  @override
  String get seedTaskBedtime => 'Tắm rửa, thay đồ, chuẩn bị đi ngủ';

  @override
  String get seedTaskReading => 'Đọc sách 15–20 phút';

  @override
  String get seedTaskChore => 'Chủ động giúp một việc nhà';

  @override
  String get seedTaskFoldClothes => 'Gấp/cất quần áo';

  @override
  String get seedTaskPlants => 'Tưới cây/chăm cây';

  @override
  String get seedTaskCreative => 'Vẽ, làm thủ công hoặc hoạt động sáng tạo';

  @override
  String get seedTaskOutdoor => 'Vận động ngoài trời ≥30 phút';

  @override
  String get seedTaskEnglish => 'Học tiếng Anh thêm 15 phút';

  @override
  String get seedTaskLearnNew => 'Học một điều mới và kể lại cho bố mẹ';

  @override
  String get seedTaskGoodDeed => 'Tự làm một việc tốt mà không cần bố mẹ nhắc';

  @override
  String get seedRewardDessert => 'Chọn món tráng miệng yêu thích';

  @override
  String get seedRewardMovie => 'Chọn phim xem cùng gia đình';

  @override
  String get seedRewardGame => 'Chọn trò chơi gia đình';

  @override
  String get seedRewardOuting => 'Được chọn địa điểm đi chơi cuối tuần';

  @override
  String get seedRewardTreat => 'Một món đồ nhỏ bé thích';

  @override
  String get seedRewardExperience =>
      'Một trải nghiệm đặc biệt: đi chơi, workshop, khu vui chơi…';

  @override
  String get seedLevel1 => 'Trợ thủ nhí';

  @override
  String get seedLevel2 => 'Siêu trợ thủ';

  @override
  String get seedLevel3 => 'Người hùng gia đình';

  @override
  String get seedLevel4 => 'Bé tự lập';
}
