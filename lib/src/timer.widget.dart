import 'package:flutter/material.dart';

/// Used to launch a count-down timer of [duration] and give an UI feedback
///
/// It will launch a timer of [duration] and call the [onFinished] function
/// when the timer reach 0.
/// 
/// The UI feedback is a "progress bar" made with a [Container]. At the 
/// beginning the progress bar take all available width until reach 0px when the
/// timer reaches 0.
/// The background color can be animated or not. To enable the color animation 
/// you need set the [animatedColor] flag to true and to provide a 
/// [colorSequence] that will be used to animate the color. If the timer widget
/// is not animated the default color [ThemeData.colorScheme.surface] will be
/// used.
/// 
/// Note: Make sure to rebuild this widget with a new key if you want to restart
///       a timer when you rebuild the tree
/// 
/// The timer management is deleguate to the [AnimationController] that handle
/// the animation from the [duration] to 0. When the animation ends, the function
/// [onFinished] is called.
/// The animation is started in the initState and disposes in the dispose 
/// method.
class TimerWidget extends StatefulWidget {



  const TimerWidget({
    Key? key,
    required this.onFinished,
    required this.colorSequence,
    required this.duration,
  }) : super(key: key);

  final Function onFinished;
  final TweenSequence<Color?> colorSequence;
  final Duration duration;
  
  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> with SingleTickerProviderStateMixin {

  late AnimationController animController;


  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: widget.duration
    )..forward().then((_) { // when the animation ends
      widget.onFinished();
    });
  }

  @override
  void dispose() {
    animController.dispose(); // cancel the animation to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => AnimatedBuilder(
          animation: animController,
          builder: (BuildContext context, _) {
            final double screenWidth = constraints.maxWidth;
            final double timerWidth = screenWidth- (screenWidth * animController.value);
            return Container(
              width: timerWidth,
              height: 10,
              decoration: BoxDecoration(
                color: evaluateColor(),
                borderRadius: BorderRadius.circular(999)
              ),
            );
          }
        ),
      ),
    );
  }



  /// Returns the color according to the progress of the animation if the 
  /// animation color is enable.
  /// Returns the default color [Theme.of(context).colorScheme.surface] if
  /// the color animation is disable.
  Color evaluateColor() => widget.colorSequence.evaluate(AlwaysStoppedAnimation(animController.value))!;
}


