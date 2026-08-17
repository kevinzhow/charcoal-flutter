enum LumenDestination { wallet, activity, plan, profile }

enum LumenTask {
  none,
  receive,
  sendEdit,
  sendReview,
  sendConfirmed,
  topUpEdit,
  topUpConfirmed,
}

enum LumenActivityKind { card, received, sent, topUp }

final class LumenActivity {
  const LumenActivity({
    required this.amount,
    required this.kind,
    required this.subtitle,
    required this.title,
  });

  final int amount;
  final LumenActivityKind kind;
  final String subtitle;
  final String title;
}
