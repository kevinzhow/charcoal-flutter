import 'package:flutter/widgets.dart';

import '../../../previews/preview_support.dart';
import '../lumen_demo.dart';
import '../lumen_view_model.dart';

@AgentPagePreview(app: 'Lumen', state: 'Wallet', includeDark: true)
Widget lumenWalletPreview() => const LumenDemo();

@AgentPagePreview(app: 'Lumen', state: 'Transfer validation')
Widget lumenTransferValidationPreview() =>
    LumenDemo(createViewModel: createLumenTransferValidationPreviewModel);

@AgentPagePreview(app: 'Lumen', state: 'Transfer review')
Widget lumenTransferReviewPreview() =>
    LumenDemo(createViewModel: createLumenTransferReviewPreviewModel);

@AgentPagePreview(app: 'Lumen', state: 'Transfer receipt')
Widget lumenTransferReceiptPreview() =>
    LumenDemo(createViewModel: createLumenTransferReceiptPreviewModel);

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
