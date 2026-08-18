import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// Controlled paged-result context that remains usable at compact widths.
final class AgentPaginationExample extends StatefulWidget {
  const AgentPaginationExample({super.key});

  @override
  State<AgentPaginationExample> createState() => _AgentPaginationExampleState();
}

final class _AgentPaginationExampleState extends State<AgentPaginationExample> {
  static const _pageCount = 20;
  static const _pageSize = 10;
  static const _resultCount = 194;

  int _currentPage = 8;

  int get _firstResult => (_currentPage - 1) * _pageSize + 1;

  int get _lastResult {
    final candidate = _currentPage * _pageSize;
    return candidate > _resultCount ? _resultCount : candidate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Search results', style: theme.textStyles.headingS),
        SizedBox(height: space.component20),
        Semantics(
          liveRegion: true,
          child: Text(
            'Results $_firstResult–$_lastResult of $_resultCount. '
            'Page $_currentPage of $_pageCount.',
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
        ),
        SizedBox(height: space.layout40),
        CharcoalPagination(
          currentPage: _currentPage,
          nextLabel: 'Next result page',
          onPageChanged: (page) => setState(() => _currentPage = page),
          pageCount: _pageCount,
          previousLabel: 'Previous result page',
          semanticLabel: 'Search result pages',
        ),
      ],
    );
  }
}
