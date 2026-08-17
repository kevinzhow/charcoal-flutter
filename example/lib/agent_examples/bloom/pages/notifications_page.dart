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
    final space = CharcoalTheme.of(context).dimensions.space;
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
              SizedBox(height: space.component20),
              _notificationList(unread, space),
            ],
            if (earlier.isNotEmpty) ...<Widget>[
              if (unread.isNotEmpty) SizedBox(height: space.component30),
              const _BloomSectionTitle(title: 'Earlier'),
              SizedBox(height: space.component20),
              _notificationList(earlier, space),
            ],
          ],
        ],
      ),
    );
  }

  Widget _notificationList(
    List<BloomNotification> notifications,
    CharcoalSpaceTokens space,
  ) => Column(
    children: <Widget>[
      for (var index = 0; index < notifications.length; index++) ...<Widget>[
        _BloomNotificationTile(
          notification: notifications[index],
          onPressed: () => viewModel.openNotification(notifications[index]),
        ),
        if (index + 1 < notifications.length)
          SizedBox(height: space.component20),
      ],
    ],
  );
}
