import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(name: 'Pagination · Wide', size: Size(640, 140))
Widget charcoalWidePaginationPreview() => const _PaginationPreview();

@CharcoalComponentPreview(name: 'Pagination · Compact', size: Size(320, 140))
Widget charcoalCompactPaginationPreview() => const _PaginationPreview();

final class _PaginationPreview extends StatefulWidget {
  const _PaginationPreview();

  @override
  State<_PaginationPreview> createState() => _PaginationPreviewState();
}

final class _PaginationPreviewState extends State<_PaginationPreview> {
  int page = 8;

  @override
  Widget build(BuildContext context) => CharcoalPagination(
    currentPage: page,
    pageCount: 20,
    onPageChanged: (value) => setState(() => page = value),
    semanticLabel: 'Preview pages',
  );
}
