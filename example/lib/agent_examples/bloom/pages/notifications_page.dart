part of '../bloom.dart';

final class _BloomNotificationsPage extends StatelessWidget {
  const _BloomNotificationsPage({required this.viewModel, super.key});

  final BloomViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    final unread = state.data.notifications
        .where((notification) => notification.unread)
        .toList(growable: false);
    final earlier = state.data.notifications
        .where((notification) => !notification.unread)
        .toList(growable: false);
    return _bloomPagePadding(
      context,
      Column(
        key: const ValueKey<String>('agent-social-notifications-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (state.data.notifications.isEmpty)
            const _BloomEmptyState(
              description: 'Likes, follows, and replies will appear here.',
              icon: CharcoalIcons.bell,
              title: 'No activity yet',
            )
          else ...<Widget>[
            if (unread.isNotEmpty) ...<Widget>[
              const _BloomSectionTitle(title: 'New'),
              const CharcoalGap(CharcoalSpace.sm),
              _notificationList(unread),
            ],
            if (earlier.isNotEmpty) ...<Widget>[
              if (unread.isNotEmpty) const CharcoalGap(CharcoalSpace.lg),
              const _BloomSectionTitle(title: 'Earlier'),
              const CharcoalGap(CharcoalSpace.sm),
              _notificationList(earlier),
            ],
          ],
        ],
      ),
    );
  }

  Widget _notificationList(List<BloomNotification> notifications) => Column(
    children: <Widget>[
      for (var index = 0; index < notifications.length; index++) ...<Widget>[
        _BloomNotificationTile(
          notification: notifications[index],
          onPressed: () => viewModel.openNotification(notifications[index]),
        ),
        if (index + 1 < notifications.length)
          const CharcoalGap(CharcoalSpace.sm),
      ],
    ],
  );
}
