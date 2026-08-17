import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../shared/demo_components.dart';
import '../lumen_view_model.dart';

final class LumenReceivePage extends StatelessWidget {
  const LumenReceivePage({required this.viewModel, super.key});

  final LumenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return AgentDemoPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'PAYMENT LINK',
            title: 'Receive without sharing account details',
            description: 'Anyone with this link can send money to Mina in the simulation.',
          ),
          SizedBox(height: space.component30),
          const AgentDemoStatus(
            icon: CharcoalIcons.link,
            message: 'lumen.me/mina · Payments arrive in your Lumen balance',
          ),
          SizedBox(height: space.component30),
          CharcoalButton(
            fullWidth: true,
            leading: const CharcoalIcon(CharcoalIcons.copy),
            onPressed: viewModel.copyPaymentLink,
            variant: CharcoalButtonVariant.primary,
            child: Text(
              viewModel.linkCopied
                  ? 'Payment link copied'
                  : 'Copy payment link',
            ),
          ),
        ],
      ),
    );
  }
}

final class LumenSendEditPage extends StatelessWidget {
  const LumenSendEditPage({
    required this.amountController,
    required this.recipientController,
    required this.viewModel,
    super.key,
  });

  final TextEditingController amountController;
  final TextEditingController recipientController;
  final LumenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-wallet-send-edit'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AgentDemoPageHeading(
            eyebrow: 'NEW TRANSFER',
            title: 'Who are you sending to?',
            description:
                '${formatYen(viewModel.balance)} is available. You will review before sending.',
          ),
          SizedBox(height: space.component30),
          CharcoalTextField(
            key: const ValueKey<String>('agent-wallet-recipient'),
            assistiveText: viewModel.recipientError,
            controller: recipientController,
            invalid: viewModel.recipientError != null,
            label: 'Recipient',
            onChanged: viewModel.updateRecipient,
            placeholder: 'Name or handle',
            showLabel: true,
          ),
          SizedBox(height: space.component25),
          CharcoalTextField(
            key: const ValueKey<String>('agent-wallet-amount'),
            assistiveText: viewModel.sendAmountError,
            controller: amountController,
            invalid: viewModel.sendAmountError != null,
            keyboardType: TextInputType.number,
            label: 'Amount',
            onChanged: viewModel.updateSendAmount,
            placeholder: '8000',
            prefix: const Text('¥'),
            showLabel: true,
          ),
          SizedBox(height: space.component30),
          CharcoalButton(
            key: const ValueKey<String>('agent-wallet-review-transfer'),
            fullWidth: true,
            onPressed: viewModel.reviewSend,
            variant: CharcoalButtonVariant.primary,
            child: const Text('Review transfer'),
          ),
        ],
      ),
    );
  }
}

final class LumenSendReviewPage extends StatelessWidget {
  const LumenSendReviewPage({required this.viewModel, super.key});

  final LumenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    final amount = viewModel.parsedSendAmount!;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-wallet-send-review'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'REVIEW',
            title: 'Check the transfer once more',
            description: 'This local simulation completes immediately after confirmation.',
          ),
          SizedBox(height: space.component30),
          AgentDemoSurface(
            color: theme.colors.containerSecondaryDefault,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _ReviewRow(label: 'To', value: viewModel.recipient.trim()),
                SizedBox(height: space.component20),
                _ReviewRow(label: 'Amount', value: formatYen(amount)),
                SizedBox(height: space.component20),
                _ReviewRow(
                  label: 'Balance after',
                  value: formatYen(viewModel.balance - amount),
                ),
              ],
            ),
          ),
          SizedBox(height: space.component30),
          CharcoalButton(
            key: const ValueKey<String>('agent-wallet-confirm-transfer'),
            fullWidth: true,
            onPressed: viewModel.confirmSend,
            variant: CharcoalButtonVariant.primary,
            child: Text('Send ${formatYen(amount)}'),
          ),
        ],
      ),
    );
  }
}

final class LumenSendConfirmedPage extends StatelessWidget {
  const LumenSendConfirmedPage({
    required this.onDone,
    required this.onViewActivity,
    required this.viewModel,
    super.key,
  });

  final VoidCallback onDone;
  final VoidCallback onViewActivity;
  final LumenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    final amount = viewModel.parsedSendAmount!;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-wallet-send-confirmed'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'RECEIPT LM-817',
            title: 'Transfer sent',
            description:
                'The balance and activity now contain the same durable result.',
          ),
          SizedBox(height: space.component30),
          AgentDemoStatus(
            positive: true,
            message:
                '${formatYen(amount)} was sent to ${viewModel.recipient.trim()}.',
          ),
          SizedBox(height: space.component30),
          CharcoalButton(
            fullWidth: true,
            onPressed: onViewActivity,
            variant: CharcoalButtonVariant.primary,
            child: const Text('View activity'),
          ),
          SizedBox(height: space.component20),
          CharcoalButton(
            fullWidth: true,
            onPressed: onDone,
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

final class LumenTopUpPage extends StatelessWidget {
  const LumenTopUpPage({required this.viewModel, super.key});

  final LumenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-wallet-top-up'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'LINKED BANK',
            title: 'Add to your Lumen balance',
            description:
                'Choose an amount from the verified account ending in 2418.',
          ),
          SizedBox(height: space.component30),
          CharcoalSegmentedControl<int>(
            fullWidth: true,
            onChanged: viewModel.setTopUpAmount,
            segments: const <CharcoalSegment<int>>[
              CharcoalSegment(value: 5000, child: Text('¥5k')),
              CharcoalSegment(value: 10000, child: Text('¥10k')),
              CharcoalSegment(value: 20000, child: Text('¥20k')),
            ],
            semanticLabel: 'Top up amount',
            value: viewModel.topUpAmount,
          ),
          SizedBox(height: space.component30),
          CharcoalButton(
            key: const ValueKey<String>('agent-wallet-confirm-top-up'),
            fullWidth: true,
            onPressed: viewModel.confirmTopUp,
            variant: CharcoalButtonVariant.primary,
            child: Text('Add ${formatYen(viewModel.topUpAmount)}'),
          ),
        ],
      ),
    );
  }
}

final class LumenTopUpConfirmedPage extends StatelessWidget {
  const LumenTopUpConfirmedPage({
    required this.onDone,
    required this.viewModel,
    super.key,
  });

  final VoidCallback onDone;
  final LumenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return AgentDemoPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'TOP UP COMPLETE',
            title: 'Your balance is updated',
            description: 'The linked-bank top up also appears in Activity.',
          ),
          SizedBox(height: space.component30),
          AgentDemoStatus(
            positive: true,
            message:
                '${formatYen(viewModel.topUpAmount)} was added. New balance: ${formatYen(viewModel.balance)}.',
          ),
          SizedBox(height: space.component30),
          CharcoalButton(
            fullWidth: true,
            onPressed: onDone,
            variant: CharcoalButtonVariant.primary,
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

final class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textStyles.captionMediumBold.copyWith(
            color: theme.colors.textDefault,
          ),
        ),
      ],
    );
  }
}
