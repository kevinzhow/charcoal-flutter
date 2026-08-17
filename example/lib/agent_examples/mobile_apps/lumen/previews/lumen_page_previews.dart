import 'package:flutter/widgets.dart';

import '../../../previews/preview_support.dart';
import '../lumen_demo.dart';
import '../lumen_models.dart';
import '../lumen_view_model.dart';

@AgentPagePreview(app: 'Lumen', state: 'Wallet', includeDark: true)
Widget lumenWalletPreview() => const LumenDemo();

@AgentPagePreview(app: 'Lumen', state: 'Wallet balance hidden')
Widget lumenWalletPrivatePreview() =>
    LumenDemo(createViewModel: createLumenWalletPrivatePreviewModel);

@AgentPagePreview(app: 'Lumen', state: 'Activity')
Widget lumenActivityPreview() =>
    LumenDemo(createViewModel: createLumenActivityPreviewModel);

@AgentPagePreview(app: 'Lumen', state: 'Plan')
Widget lumenPlanPreview() =>
    LumenDemo(createViewModel: createLumenPlanPreviewModel);

@AgentPagePreview(app: 'Lumen', state: 'Profile')
Widget lumenProfilePreview() =>
    LumenDemo(createViewModel: createLumenProfilePreviewModel);

@AgentPagePreview(app: 'Lumen', state: 'Profile private')
Widget lumenProfilePrivatePreview() =>
    LumenDemo(createViewModel: createLumenProfilePrivatePreviewModel);

@AgentPagePreview(app: 'Lumen', state: 'Receive link')
Widget lumenReceivePreview() =>
    LumenDemo(createViewModel: createLumenReceivePreviewModel);

@AgentPagePreview(app: 'Lumen', state: 'Receive link copied')
Widget lumenReceiveCopiedPreview() =>
    LumenDemo(createViewModel: createLumenReceiveCopiedPreviewModel);

@AgentPagePreview(app: 'Lumen', state: 'Transfer entry')
Widget lumenTransferEntryPreview() =>
    LumenDemo(createViewModel: createLumenTransferEntryPreviewModel);

@AgentPagePreview(app: 'Lumen', state: 'Transfer validation')
Widget lumenTransferValidationPreview() =>
    LumenDemo(createViewModel: createLumenTransferValidationPreviewModel);

@AgentPagePreview(app: 'Lumen', state: 'Transfer review')
Widget lumenTransferReviewPreview() =>
    LumenDemo(createViewModel: createLumenTransferReviewPreviewModel);

@AgentPagePreview(app: 'Lumen', state: 'Transfer receipt')
Widget lumenTransferReceiptPreview() =>
    LumenDemo(createViewModel: createLumenTransferReceiptPreviewModel);

@AgentPagePreview(app: 'Lumen', state: 'Top up selection')
Widget lumenTopUpPreview() =>
    LumenDemo(createViewModel: createLumenTopUpPreviewModel);

@AgentPagePreview(app: 'Lumen', state: 'Top up receipt')
Widget lumenTopUpReceiptPreview() =>
    LumenDemo(createViewModel: createLumenTopUpReceiptPreviewModel);

LumenViewModel createLumenWalletPrivatePreviewModel() =>
    LumenViewModel()..setBalanceHidden(true);

LumenViewModel createLumenActivityPreviewModel() =>
    LumenViewModel()..selectDestination(LumenDestination.activity);

LumenViewModel createLumenPlanPreviewModel() =>
    LumenViewModel()..selectDestination(LumenDestination.plan);

LumenViewModel createLumenProfilePreviewModel() =>
    LumenViewModel()..selectDestination(LumenDestination.profile);

LumenViewModel createLumenProfilePrivatePreviewModel() =>
    createLumenProfilePreviewModel()..setBalanceHidden(true);

LumenViewModel createLumenReceivePreviewModel() =>
    LumenViewModel()..startReceive();

LumenViewModel createLumenReceiveCopiedPreviewModel() =>
    createLumenReceivePreviewModel()..copyPaymentLink();

LumenViewModel createLumenTransferEntryPreviewModel() =>
    LumenViewModel()..startSend();

LumenViewModel createLumenTransferValidationPreviewModel() => LumenViewModel()
  ..startSend()
  ..updateRecipient('Aya')
  ..updateSendAmount('1500000')
  ..reviewSend();

LumenViewModel createLumenTransferReviewPreviewModel() => LumenViewModel()
  ..startSend()
  ..updateRecipient('Aya')
  ..updateSendAmount('3200')
  ..reviewSend();

LumenViewModel createLumenTransferReceiptPreviewModel() =>
    createLumenTransferReviewPreviewModel()..confirmSend();

LumenViewModel createLumenTopUpPreviewModel() => LumenViewModel()..startTopUp();

LumenViewModel createLumenTopUpReceiptPreviewModel() =>
    createLumenTopUpPreviewModel()..confirmTopUp();
