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
                child: CharcoalText(
                  'Pick up the conversations that need you first.',
                  role: CharcoalTextRole.captionMedium,
                  tone: CharcoalTextTone.secondary,
                ),
              ),
              if (state.unreadConversationCount > 0) ...<Widget>[
                const CharcoalGap(CharcoalSpace.sm),
                CharcoalBadge('${state.unreadConversationCount} unread'),
              ],
            ],
          ),
          const CharcoalGap(CharcoalSpace.lg),
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
            if (index + 1 < conversations.length)
              const CharcoalGap(CharcoalSpace.sm),
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
    if (_lastMessageCount != conversation.messages.length) {
      _lastMessageCount = conversation.messages.length;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scrollController.hasClients) return;
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: CharcoalMotion.standard.resolve(context),
          curve: CharcoalMotion.curveOf(context),
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
            padding: _bloomPageInset.resolve(context),
            children: <Widget>[
              Center(
                child: CharcoalText(
                  'Today',
                  role: CharcoalTextRole.caption,
                  tone: CharcoalTextTone.tertiary,
                ),
              ),
              const CharcoalGap(CharcoalSpace.lg),
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
                  const CharcoalGap(CharcoalSpace.sm),
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
    return Align(
      alignment: message.own
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: message.own
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          if (!message.own) ...<Widget>[
            CharcoalText(
              creatorName,
              role: CharcoalTextRole.caption,
              tone: CharcoalTextTone.tertiary,
            ),
            const CharcoalGap(CharcoalSpace.xs),
          ],
          CharcoalMessageBubble(message.text, outgoing: message.own),
          if (message.own) ...<Widget>[
            const CharcoalGap(CharcoalSpace.xs),
            _BloomDeliveryStatus(message: message, onRetry: onRetry),
          ],
        ],
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
    return switch (message.delivery) {
      BloomMessageDelivery.sending => const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CharcoalLoadingSpinner.inline(semanticLabel: 'Sending message'),
          CharcoalGap(CharcoalSpace.xs),
          CharcoalText(
            'Sending…',
            role: CharcoalTextRole.size10,
            tone: CharcoalTextTone.tertiary,
          ),
        ],
      ),
      BloomMessageDelivery.sent => const CharcoalText(
        'Sent',
        role: CharcoalTextRole.size10,
        tone: CharcoalTextTone.tertiary,
      ),
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
