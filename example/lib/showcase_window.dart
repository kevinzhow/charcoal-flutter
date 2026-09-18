import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Reserves the native caption while allowing the page background behind it.
///
/// The macOS runner owns traffic lights, dragging, zoom and fullscreen. Other
/// hosts retain their native frame and do not install a channel handler.
final class ShowcaseWindow extends StatefulWidget {
  const ShowcaseWindow({
    required this.child,
    required this.brightness,
    super.key,
  });

  final Widget child;
  final Brightness brightness;

  @override
  State<ShowcaseWindow> createState() => _ShowcaseWindowState();
}

final class _ShowcaseWindowState extends State<ShowcaseWindow> {
  static const _channel = MethodChannel('dev.charcoal.showcase/window');
  bool get _supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
  double _captionHeight = 0;

  @override
  void initState() {
    super.initState();
    if (_supported) {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'metrics') _updateMetrics(call.arguments);
      });
      _initialize();
    }
  }

  Future<void> _initialize() async {
    try {
      _updateMetrics(await _channel.invokeMethod<Object?>('getMetrics'));
      await _updateAppearance();
    } on MissingPluginException {
      // Widget tests and previews do not install the native runner.
    }
  }

  void _updateMetrics(Object? metrics) {
    if (!mounted || metrics is! Map || metrics['captionHeight'] is! num) return;
    final height = (metrics['captionHeight'] as num).toDouble();
    if (height != _captionHeight) setState(() => _captionHeight = height);
  }

  Future<void> _updateAppearance() async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod<void>(
        'setBrightness',
        widget.brightness.name,
      );
    } on MissingPluginException {
      // This widget also runs without a native host in widget tests.
    }
  }

  @override
  void didUpdateWidget(ShowcaseWindow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.brightness != widget.brightness) _updateAppearance();
  }

  @override
  void dispose() {
    if (_supported) _channel.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(
        padding: media.padding.copyWith(
          top: _captionHeight > media.padding.top
              ? _captionHeight
              : media.padding.top,
        ),
        viewPadding: media.viewPadding.copyWith(
          top: _captionHeight > media.viewPadding.top
              ? _captionHeight
              : media.viewPadding.top,
        ),
      ),
      child: widget.child,
    );
  }
}
