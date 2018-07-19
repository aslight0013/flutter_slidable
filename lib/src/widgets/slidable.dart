import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const double _kActionsExtentRatio = 0.3;
const double _kFastThreshold = 2500.0;

/// A handle to various properties useful while calling [SlidableDelegate.buildActions].
///
/// See also:
///
///  * [SlidableState], which create this object.
///  * [SlidableDelegate] and other delegates inheriting it, which uses this object in [SlidableDelegate.buildActions].
class SlidableDelegateContext {
  const SlidableDelegateContext(
    this.slidable,
    this.showLeftActions,
    this.dragExtent,
    this.controller,
  );

  final Slidable slidable;

  /// The current actions that have to be shown.
  List<Widget> get actions =>
      showLeftActions ? slidable.leftActions : slidable.rightActions;

  /// Whether the left actions have to be shown.
  final bool showLeftActions;

  final double dragExtent;

  /// The animation controller which value depends on  `dragExtent`.
  final AnimationController controller;
}

/// A delegate that controls how the slide actions are displayed.
///
/// See also:
///
///  * [SlidableStrechDelegate], which creates slide actions that stretched
///  while the item is sliding.
///  * [SlidableBehindDelegate], which creates slide actions that stay behind the item
///  while is sliding.
///  * [SlidableScrollDelegate], which creates slide actions that follow the item
///  while is sliding.
///  * [SlidableDrawerDelegate], which creates slide actions that are displayed like drawers
///  while the item is sliding.
abstract class SlidableDelegate {
  const SlidableDelegate({
    double fastThreshold,
  })  : fastThreshold = fastThreshold ?? _kFastThreshold,
        assert(fastThreshold == null || fastThreshold >= .0,
            'fastThreshold must be greater than 0.0');

  /// The threshold used to know if a movement was fast and request to open/close the actions.
  final double fastThreshold;

  Widget buildActions(BuildContext context, SlidableDelegateContext ctx);
}

abstract class SlidableStackDelegate extends SlidableDelegate {
  const SlidableStackDelegate({
    double actionsExtentRatio,
    double fastThreshold,
  })  : assert(
            fastThreshold == null ||
                actionsExtentRatio >= .0 && actionsExtentRatio <= 1.0,
            'actionsExtentRatio must be between 0.0 and 1.0'),
        actionsExtentRatio = actionsExtentRatio ?? _kActionsExtentRatio,
        super(fastThreshold: fastThreshold);

  final double actionsExtentRatio;

  @override
  Widget buildActions(BuildContext context, SlidableDelegateContext ctx) {
    final animation = new Tween(
      begin: Offset.zero,
      end: new Offset(actionsExtentRatio * ctx.dragExtent.sign, 0.0),
    ).animate(ctx.controller);

    if (ctx.controller.value != .0 && ctx.dragExtent != .0) {
      return new Container(
        child: new Stack(
          children: <Widget>[
            buildStackActions(
              context,
              ctx,
            ),
            new SlideTransition(
              position: animation,
              child: ctx.slidable.child,
            ),
          ],
        ),
      );
    } else {
      return ctx.slidable.child;
    }
  }

  Widget buildStackActions(BuildContext context, SlidableDelegateContext ctx);
}

/// A delegate that creates slide actions which stretch while the item is sliding.
class SlidableStrechDelegate extends SlidableStackDelegate {
  const SlidableStrechDelegate({
    double actionsExtentRatio,
    double fastThreshold,
  }) : super(
          actionsExtentRatio: actionsExtentRatio,
          fastThreshold: fastThreshold,
        );

  @override
  Widget buildStackActions(BuildContext context, SlidableDelegateContext ctx) {
    final animation = new Tween(
      begin: Offset.zero,
      end: new Offset(actionsExtentRatio * ctx.dragExtent.sign, 0.0),
    ).animate(ctx.controller);

    return new Positioned.fill(
      child: new LayoutBuilder(builder: (context, constraints) {
        return new AnimatedBuilder(
            animation: ctx.controller,
            builder: (context, child) {
              return new Stack(
                children: <Widget>[
                  new Positioned(
                    left: ctx.showLeftActions ? .0 : null,
                    right: ctx.showLeftActions ? null : .0,
                    top: .0,
                    bottom: .0,
                    width: constraints.maxWidth * animation.value.dx.abs(),
                    child: new Row(
                      children:
                          ctx.actions.map((a) => Expanded(child: a)).toList(),
                    ),
                  )
                ],
              );
            });
      }),
    );
  }
}

/// A delegate that creates slide actions which stay behind the item while is sliding.
class SlidableBehindDelegate extends SlidableStackDelegate {
  const SlidableBehindDelegate({
    double actionsExtentRatio,
    double fastThreshold,
  }) : super(
          actionsExtentRatio: actionsExtentRatio,
          fastThreshold: fastThreshold,
        );

  @override
  Widget buildStackActions(BuildContext context, SlidableDelegateContext ctx) {
    return new Positioned.fill(
      child: new LayoutBuilder(builder: (context, constraints) {
        return new Stack(
          children: <Widget>[
            new Positioned(
              left: ctx.showLeftActions ? .0 : null,
              right: ctx.showLeftActions ? null : .0,
              top: .0,
              bottom: .0,
              width: constraints.maxWidth * actionsExtentRatio,
              child: new Row(
                children: ctx.actions.map((a) => Expanded(child: a)).toList(),
              ),
            )
          ],
        );
      }),
    );
  }
}

/// A delegate that creates slide actions which follow the item while is sliding.
class SlidableScrollDelegate extends SlidableStackDelegate {
  const SlidableScrollDelegate({
    double actionsExtentRatio,
    double fastThreshold,
  }) : super(
          actionsExtentRatio: actionsExtentRatio,
          fastThreshold: fastThreshold,
        );

  @override
  Widget buildStackActions(BuildContext context, SlidableDelegateContext ctx) {
    return new Positioned.fill(
      child: new LayoutBuilder(builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth * actionsExtentRatio;

        final animation = new Tween(
          begin: new Offset(-totalWidth, 0.0),
          end: Offset.zero,
        ).animate(ctx.controller);

        return new AnimatedBuilder(
            animation: ctx.controller,
            builder: (context, child) {
              return new Stack(
                children: <Widget>[
                  new Positioned(
                    left: ctx.showLeftActions ? animation.value.dx : null,
                    right: ctx.showLeftActions ? null : animation.value.dx,
                    top: .0,
                    bottom: .0,
                    width: totalWidth,
                    child: new Row(
                      children:
                          ctx.actions.map((a) => Expanded(child: a)).toList(),
                    ),
                  )
                ],
              );
            });
      }),
    );
  }
}

/// A delegate that creates slide actions which animate like drawers while the item is sliding.
class SlidableDrawerDelegate extends SlidableStackDelegate {
  const SlidableDrawerDelegate({
    double actionsExtentRatio,
    double fastThreshold,
  }) : super(
          actionsExtentRatio: actionsExtentRatio,
          fastThreshold: fastThreshold,
        );

  @override
  Widget buildStackActions(BuildContext context, SlidableDelegateContext ctx) {
    return new Positioned.fill(
      child: new LayoutBuilder(builder: (context, constraints) {
        final count = ctx.actions.length;
        final double width = constraints.maxWidth;
        final double totalWidth = width * actionsExtentRatio;
        final double actionWidth = totalWidth / ctx.actions.length;

        final animations = Iterable.generate(count).map((index) {
          return new Tween(
            begin: new Offset(-actionWidth, 0.0),
            end: new Offset((count - index - 1) * actionWidth, 0.0),
          ).animate(ctx.controller);
        }).toList();

        return new AnimatedBuilder(
            animation: ctx.controller,
            builder: (context, child) {
              // For the left items we have to reverse the order if we want the last item at the bottom of the stack.
              final Iterable<Widget> actions =
                  ctx.showLeftActions ? ctx.actions.reversed : ctx.actions;

              return new Stack(
                children: _map(
                    actions,
                    (action, index) => new Positioned(
                          left: ctx.showLeftActions
                              ? animations[index].value.dx
                              : null,
                          right: ctx.showLeftActions
                              ? null
                              : animations[index].value.dx,
                          top: .0,
                          bottom: .0,
                          width: actionWidth,
                          child: action,
                        )).toList(),
              );
            });
      }),
    );
  }

  static Iterable<TResult> _map<T, TResult>(
      Iterable<T> iterable, TResult selector(T item, int index)) {
    int index = 0;
    final List<TResult> result = new List<TResult>();
    for (T item in iterable) {
      result.add(selector(item, index++));
    }
    return result;
  }
}

/// A widget that can be slide to the right or to the left.
/// By sliding in one of these direction, slide actions will appear.
class Slidable extends StatefulWidget {
  /// Creates a widget that can be dismissed.
  ///
  /// The [key] argument must not be null because [Slidable]s are commonly
  /// used in lists and removed from the list when dismissed. Without keys, the
  /// default behavior is to sync widgets based on their index in the list,
  /// which means the item after the dismissed item would be synced with the
  /// state of the dismissed item. Using keys causes the widgets to sync
  /// according to their keys and avoids this pitfall.
  ///
  /// The delegate argument must not be null.
  Slidable({
    @required Key key,
    @required this.child,
    @required this.delegate,
    this.leftActions,
    this.rightActions,
    this.showAllActionsThreshold = 0.5,
    this.movementDuration: const Duration(milliseconds: 200),
  })  : assert(delegate != null),
        super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  final List<Widget> leftActions;

  final List<Widget> rightActions;

  final SlidableDelegate delegate;

  /// The offset threshold the item has to be dragged in order to show all actions
  /// in the slide direction.
  ///
  /// Represented as a fraction, e.g. if it is 0.4 (the default), then the item
  /// has to be dragged at least 40% of the slide actions extent towards one direction to show all actions.
  final double showAllActionsThreshold;

  /// Defines the duration for card to go to final position or to come back to original position if threshold not reached.
  final Duration movementDuration;

  @override
  SlidableState createState() => SlidableState();
}

class SlidableState extends State<Slidable>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<Slidable> {
  @override
  void initState() {
    super.initState();
    _controller =
        new AnimationController(duration: widget.movementDuration, vsync: this)
          ..addStatusListener(_handleShowAllActionsStatusChanged);
  }

  void _handleShowAllActionsStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_dragUnderway && !_opening) {
      _dragExtent = .0;
      setState(() {});
    }
  }

  AnimationController _controller;
  double _dragExtent = 0.0;
  bool _dragUnderway = false;
  bool _opening = false;

  bool get _showLeftActions {
    return _dragExtent > 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    final double overallDragAxisExtent = context.size.width;
    _dragUnderway = true;

    if (_controller.isAnimating) {
      _dragExtent =
          _controller.value * overallDragAxisExtent * _dragExtent.sign;
      _controller.stop();
    } else {
      _controller.value = 0.0;
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final double delta = details.primaryDelta;
    _dragExtent += delta;
    setState(() {
      _controller.value = _dragExtent.abs() / context.size.width;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    _dragUnderway = false;
    final double velocity = details.primaryVelocity;
    final bool open = velocity.sign == _dragExtent.sign;
    final bool fast = velocity.abs() > widget.delegate.fastThreshold;
    if (!open && fast) {
      _opening = false;
      _controller.animateTo(0.0);
    } else if (_controller.value >= widget.showAllActionsThreshold ||
        (open && fast)) {
      _opening = true;
      _controller.animateTo(1.0);
    } else {
      _opening = false;
      _controller.animateTo(0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    if (widget.leftActions == null && widget.rightActions == null) {
      return widget.child;
    }

    Widget content = widget.child;

    if (_showLeftActions && widget.leftActions != null ||
        !_showLeftActions && widget.rightActions != null) {
      content = widget.delegate.buildActions(
        context,
        new SlidableDelegateContext(
          widget,
          _showLeftActions,
          _dragExtent,
          _controller,
        ),
      );
    }

    return new GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }

  @override
  bool get wantKeepAlive => _opening;
}
