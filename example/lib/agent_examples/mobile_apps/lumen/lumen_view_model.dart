import 'package:flutter/foundation.dart';

import 'lumen_models.dart';

final class LumenViewModel extends ChangeNotifier {
  final List<LumenActivity> _activity = <LumenActivity>[
    const LumenActivity(
      amount: -1240,
      kind: LumenActivityKind.card,
      subtitle: 'Today · Card',
      title: 'Morning Market',
    ),
    const LumenActivity(
      amount: 8000,
      kind: LumenActivityKind.received,
      subtitle: 'Yesterday · Transfer',
      title: 'From Hana',
    ),
    const LumenActivity(
      amount: -980,
      kind: LumenActivityKind.card,
      subtitle: 'Aug 15 · Card',
      title: 'Mori Books',
    ),
  ];

  int _balance = 1284600;
  bool _balanceHidden = false;
  bool _linkCopied = false;
  String _recipient = '';
  String? _recipientError;
  bool _roundUps = true;
  String _sendAmount = '';
  String? _sendAmountError;
  LumenDestination _destination = LumenDestination.wallet;
  LumenTask _task = LumenTask.none;
  int _topUpAmount = 10000;

  List<LumenActivity> get activity =>
      List<LumenActivity>.unmodifiable(_activity);
  int get balance => _balance;
  bool get balanceHidden => _balanceHidden;
  LumenDestination get destination => _destination;
  bool get linkCopied => _linkCopied;
  String get recipient => _recipient;
  String? get recipientError => _recipientError;
  bool get roundUps => _roundUps;
  String get sendAmount => _sendAmount;
  String? get sendAmountError => _sendAmountError;
  int get selectedBottomIndex => _destination.index;
  bool get showBottomNavigation => _task == LumenTask.none;
  LumenTask get task => _task;
  int get topUpAmount => _topUpAmount;
  int? get parsedSendAmount =>
      int.tryParse(_sendAmount.replaceAll(RegExp('[^0-9]'), ''));

  String get title => switch (_task) {
    LumenTask.none => switch (_destination) {
      LumenDestination.wallet => 'Lumen',
      LumenDestination.activity => 'Activity',
      LumenDestination.plan => 'Plan',
      LumenDestination.profile => 'Profile',
    },
    LumenTask.receive => 'Receive money',
    LumenTask.sendEdit => 'Send money',
    LumenTask.sendReview => 'Review transfer',
    LumenTask.sendConfirmed => 'Transfer sent',
    LumenTask.topUpEdit => 'Top up',
    LumenTask.topUpConfirmed => 'Balance updated',
  };

  bool get canGoBack => switch (_task) {
    LumenTask.none ||
    LumenTask.sendConfirmed ||
    LumenTask.topUpConfirmed => false,
    _ => true,
  };

  void selectDestination(int index) {
    _destination = LumenDestination.values[index];
    _task = LumenTask.none;
    notifyListeners();
  }

  void toggleBalanceVisibility() {
    _balanceHidden = !_balanceHidden;
    notifyListeners();
  }

  void startReceive() {
    _task = LumenTask.receive;
    _linkCopied = false;
    notifyListeners();
  }

  void copyPaymentLink() {
    _linkCopied = true;
    notifyListeners();
  }

  void startSend() {
    _task = LumenTask.sendEdit;
    _recipient = '';
    _sendAmount = '';
    _recipientError = null;
    _sendAmountError = null;
    notifyListeners();
  }

  void updateRecipient(String value) {
    _recipient = value;
    _recipientError = null;
    notifyListeners();
  }

  void updateSendAmount(String value) {
    _sendAmount = value;
    _sendAmountError = null;
    notifyListeners();
  }

  void reviewSend() {
    final amount = parsedSendAmount;
    _recipientError = _recipient.trim().isEmpty
        ? 'Enter a recipient before continuing.'
        : null;
    _sendAmountError = amount == null || amount <= 0
        ? 'Enter an amount greater than zero.'
        : amount > _balance
        ? 'This exceeds your available balance.'
        : null;
    if (_recipientError != null || _sendAmountError != null) {
      notifyListeners();
      return;
    }
    _task = LumenTask.sendReview;
    notifyListeners();
  }

  void confirmSend() {
    final amount = parsedSendAmount;
    if (amount == null ||
        amount <= 0 ||
        amount > _balance ||
        _recipient.trim().isEmpty) {
      return;
    }
    _balance -= amount;
    _activity.insert(
      0,
      LumenActivity(
        amount: -amount,
        kind: LumenActivityKind.sent,
        subtitle: 'Just now · Transfer',
        title: 'To ${_recipient.trim()}',
      ),
    );
    _task = LumenTask.sendConfirmed;
    notifyListeners();
  }

  void startTopUp() {
    _task = LumenTask.topUpEdit;
    notifyListeners();
  }

  void setTopUpAmount(int value) {
    _topUpAmount = value;
    notifyListeners();
  }

  void confirmTopUp() {
    _balance += _topUpAmount;
    _activity.insert(
      0,
      LumenActivity(
        amount: _topUpAmount,
        kind: LumenActivityKind.topUp,
        subtitle: 'Just now · Linked bank',
        title: 'Bank top up',
      ),
    );
    _task = LumenTask.topUpConfirmed;
    notifyListeners();
  }

  void openProfileOptions() {
    _destination = LumenDestination.profile;
    _task = LumenTask.none;
    notifyListeners();
  }

  void setRoundUps(bool value) {
    _roundUps = value;
    notifyListeners();
  }

  void openActivity() {
    _destination = LumenDestination.activity;
    _task = LumenTask.none;
    _recipient = '';
    _sendAmount = '';
    _recipientError = null;
    _sendAmountError = null;
    notifyListeners();
  }

  void finishTask() {
    _task = LumenTask.none;
    _recipient = '';
    _sendAmount = '';
    _recipientError = null;
    _sendAmountError = null;
    notifyListeners();
  }

  void goBack() {
    _task = switch (_task) {
      LumenTask.sendReview => LumenTask.sendEdit,
      LumenTask.receive ||
      LumenTask.sendEdit ||
      LumenTask.topUpEdit => LumenTask.none,
      _ => _task,
    };
    notifyListeners();
  }
}
