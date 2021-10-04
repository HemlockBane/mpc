import 'package:flutter/material.dart';

class ExpandablePageView extends StatefulWidget {
  ExpandablePageView(
      {Key? key,
      required this.itemBuilder,
      required this.itemCount,
      this.controller,
      this.pageSnapping = false,
      this.onPageChanged})
      : super(key: key);

  final int itemCount;
  final Widget Function(BuildContext ctx, int index) itemBuilder;
  final PageController? controller;
  final ValueChanged<int>? onPageChanged;
  final bool pageSnapping;

  @override
  State<StatefulWidget> createState() => _ExpandablePageViewState();
}

class _ExpandablePageViewState extends State<ExpandablePageView> {
  PageController? controller;
  int _currentPage = 0;

  late final List<double> _pageHeights;

  double get _currentPageHeight => _pageHeights[_currentPage];

  @override
  void initState() {
    _pageHeights = List.generate(widget.itemCount, (index) => 0.0);
    super.initState();
    this.controller = widget.controller ?? PageController();
    this.controller?.addListener(() {
      final newPage = controller?.page!.round();
      if (newPage != _currentPage) {
        setState(() => _currentPage = newPage!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOutCubic,
      tween: Tween<double>(begin: _pageHeights.first, end: _currentPageHeight),
      builder: (ctx, value, child) => SizedBox(height: value, child: child),
      child: PageView.builder(
          controller: this.controller,
          pageSnapping: widget.pageSnapping,
          itemCount: widget.itemCount,
          onPageChanged: widget.onPageChanged,
          itemBuilder: (ctx, index) {
            return OverflowBox(
              minHeight: 0,
              maxHeight: double.infinity,
              alignment: Alignment.topCenter,
              child: _MeasureSize(
                  onSizeChanged: (size) =>
                      setState(() => _pageHeights[index] = size.height),
                  child: widget.itemBuilder.call(context, index)),
            );
          }),
    );
  }
}

class _MeasureSize extends StatefulWidget {
  _MeasureSize({Key? key, required this.onSizeChanged, required this.child})
      : super(key: key);

  final ValueChanged<Size> onSizeChanged;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _notifySize());
    return widget.child;
  }

  void _notifySize() {
    final newSize = context.size;
    if (_oldSize != newSize) {
      _oldSize = newSize;
      widget.onSizeChanged.call(_oldSize!);
    }
  }
}
