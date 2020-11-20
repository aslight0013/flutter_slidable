import 'package:flutter/material.dart';

import 'controller.dart';

/// Animates the end of a dismiss.
class DismissalTransition extends StatefulWidget {
  const DismissalTransition({
    Key key,
    @required this.axis,
    @required this.child,
    @required this.controller,
  })  : assert(axis != null),
        assert(controller != null),
        assert(child != null),
        super(key: key);

  final Axis axis;
  final Widget child;
  final SlidableController controller;

  @override
  _DismissalTransitionState createState() => _DismissalTransitionState();
}

class _DismissalTransitionState extends State<DismissalTransition>
    with SingleTickerProviderStateMixin {
  bool resized = false;
  AnimationController animationController;
  Animation<double> resizeAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(vsync: this);
    resizeAnimation = animationController.drive(Tween(begin: 1, end: 0));
    widget.controller.addListener(handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant DismissalTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller.animation != widget.controller.animation) {
      oldWidget.controller.removeListener(handleControllerChanged);
      widget.controller.addListener(handleControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(handleControllerChanged);
    animationController.dispose();
    super.dispose();
  }

  void handleControllerChanged() {
    final resizeRequest = widget.controller.resizeRequest;
    if (widget.controller.lastChangedProperty ==
        SlidableControllerProperty.resizeRequest) {
      if (widget.controller.animation.status == AnimationStatus.completed) {
        animationController.duration = resizeRequest.duration;
        animationController.forward(from: 0).then((_) {
          resizeRequest.onDismissed?.call();
        });
        setState(() {
          resized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (resized) {
      assert(() {
        if (resizeAnimation.status != AnimationStatus.forward) {
          assert(resizeAnimation.status == AnimationStatus.completed);
          throw FlutterError.fromParts(
            <DiagnosticsNode>[
              ErrorSummary(
                'A dismissed Slidable widget is still part of the tree.',
              ),
              ErrorHint(
                'Make sure to implement the onDismissed handle of the '
                'ActionPane and to immediately remove the Slidable widget from '
                'the application once that handler has fired.',
              )
            ],
          );
        }
        return true;
      }());
    }

    return SizeTransition(
      sizeFactor: resizeAnimation,
      axis: widget.axis,
      child: widget.child,
    );
  }
}
