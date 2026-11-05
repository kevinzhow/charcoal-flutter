part of '../bloom.dart';

final class _BloomMessagesPage extends StatelessWidget {
  const _BloomMessagesPage({required this.viewModel});

  final BloomViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    final conversations = <BloomConversation>[...state.data.conversations]
      ..sort((left, right) {
        if (left.unread == right.unread) return 0;
        return left.unread ? -1 : 1;
      });
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return _bloomPagePadding(
      context,
      Column(
        key: const ValueKey<String>('agent-social-messages-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Pick up the conversations that need you first.',
                  style: theme
                      .style(CharcoalTextRole.captionMedium)
                      .copyWith(color: theme.colors.textSecondary),
                ),
              ),
              if (state.unreadConversationCount > 0) ...<Widget>[
                SizedBox(width: space.sm),
                _BloomCountBadge(count: state.unreadConversationCount),
              ],
            ],
          ),
          SizedBox(height: space.lg),
          for (
            var index = 0;
            index < conversations.length;
            index++
          ) ...<Widget>[
            _BloomConversationTile(
              key: ValueKey<String>(
                'agent-social-conversation-${conversations[index].id}',
              ),
              conversation: conversations[index],
              creator: state.data.creator(conversations[index].creatorId),
              onPressed: () =>
                  viewModel.openConversation(conversations[index].id),
            ),
            if (index + 1 < conversations.length) SizedBox(height: space.sm),
          ],
        ],
      ),
    );
  }
}

final class _BloomConversationPage extends StatefulWidget {
  const _BloomConversationPage({
    required this.conversationId,
    required this.viewModel,
    super.key,
  });

  final String conversationId;
  final BloomViewModel viewModel;

  @override
  State<_BloomConversationPage> createState() => _BloomConversationPageState();
}

final class _BloomConversationPageState extends State<_BloomConversationPage> {
  final ScrollController _scrollController = ScrollController();
  var _lastMessageCount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.viewModel.state;
    final conversation = state.data.conversation(widget.conversationId);
    final creator = state.data.creator(conversation.creatorId);
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    if (_lastMessageCount != conversation.messages.length) {
      _lastMessageCount = conversation.messages.length;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scrollController.hasClients) return;
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: CharcoalTheme.of(context)
              .duration(context, const Duration(milliseconds: 220)),
          curve: CharcoalTheme.of(context).motion.curve,
        );
      });
    }
    return Column(
      key: const ValueKey<String>('agent-social-conversation'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(
              space.lg,
              space.md,
              space.lg,
              space.lg,
            ),
            children: <Widget>[
              Center(
                child: Text(
                  'Today',
                  style: theme
                      .style(CharcoalTextRole.caption)
                      .copyWith(color: theme.colors.textTertiary),
                ),
              ),
              SizedBox(height: space.lg),
              for (
                var index = 0;
                index < conversation.messages.length;
                index++
              ) ...<Widget>[
                _BloomMessageBubble(
                  conversationId: conversation.id,
                  creatorName: creator.name.split(' ').first,
                  message: conversation.messages[index],
                  onRetry: () => widget.viewModel.retryMessage(
                    conversation.id,
                    conversation.messages[index].id,
                  ),
                ),
                if (index + 1 < conversation.messages.length)
                  SizedBox(height: space.sm),
              ],
            ],
          ),
        ),
        _BloomReplyBar(
          fieldKey: const ValueKey<String>('agent-social-message-field'),
          fieldSemanticLabel: 'Message ${creator.name}',
          onSend: _send,
          placeholder: 'Message ${creator.name.split(' ').first}',
          sendKey: const ValueKey<String>('agent-social-send-message'),
          sendSemanticLabel: 'Send message',
        ),
      ],
    );
  }

  void _send(String message) {
    widget.viewModel.sendMessage(widget.conversationId, message);
  }
}

final class _BloomMessageBubble extends StatelessWidget {
  const _BloomMessageBubble({
    required this.conversationId,
    required this.creatorName,
    required this.message,
    required this.onRetry,
  });

  final String conversationId;
  final String creatorName;
  final BloomMessage message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return Align(
      alignment: message.own
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 260),
        child: Column(
          crossAxisAlignment: message.own
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            if (!message.own) ...<Widget>[
              Text(
                creatorName,
                style: theme
                    .style(CharcoalTextRole.caption)
                    .copyWith(color: theme.colors.textTertiary),
              ),
              SizedBox(height: space.xs),
            ],
            DecoratedBox(
              decoration: BoxDecoration(
                border: message.own
                    ? null
                    : Border.all(color: theme.colors.borderSubtle),
                borderRadius: BorderRadius.circular(theme.radius.md),
                color: message.own
                    ? theme.colors.primary
                    : theme.colors.background,
              ),
              child: Padding(
                padding: EdgeInsets.all(space.sm),
                child: Text(
                  message.text,
                  style: theme
                      .style(CharcoalTextRole.captionMedium)
                      .copyWith(
                        color: message.own
                            ? theme.colors.textOnPrimary
                            : theme.colors.text,
                      ),
                ),
              ),
            ),
            if (message.own) ...<Widget>[
              SizedBox(height: space.xs),
              _BloomDeliveryStatus(message: message, onRetry: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}

final class _BloomDeliveryStatus extends StatelessWidget {
  const _BloomDeliveryStatus({required this.message, required this.onRetry});

  final BloomMessage message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final textStyle = theme
        .style(CharcoalTextRole.caption)
        .copyWith(
          color: message.delivery == BloomMessageDelivery.failed
              ? theme.colors.textNegative
              : theme.colors.textTertiary,
          fontSize: 10,
        );
    return switch (message.delivery) {
      BloomMessageDelivery.sending => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CharcoalLoadingSpinner(
            color: theme.colors.iconTertiary,
            padding: 0,
            semanticLabel: 'Sending message',
            size: 8,
            transparent: true,
          ),
          SizedBox(width: theme.space.xs),
          Text('Sending…', style: textStyle),
        ],
      ),
      BloomMessageDelivery.sent => Text('Sent', style: textStyle),
      BloomMessageDelivery.failed => CharcoalButton(
        onPressed: onRetry,
        size: CharcoalButtonSize.small,
        variant: CharcoalButtonVariant.danger,
        child: const Text('Failed · Retry'),
      ),
      BloomMessageDelivery.received => const SizedBox.shrink(),
    };
  }
}
