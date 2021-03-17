import 'package:flutter/material.dart';


enum _TimerRunningEnum {
  playing,
  paused,
  finished,
}


class TimerState extends ChangeNotifier {

  double current = 0;
  _TimerRunningEnum running = _TimerRunningEnum.playing;

  bool get isPlaying => running == _TimerRunningEnum.playing;
  bool get isPaused => running == _TimerRunningEnum.paused;
  bool get isFinished => running == _TimerRunningEnum.finished;

  void pause() {
    running = _TimerRunningEnum.paused;
    notifyListeners();
  }

  void play() {
    running = _TimerRunningEnum.playing;
    notifyListeners();
  }

  void finished() {
    running = _TimerRunningEnum.finished;
    notifyListeners();
  }
}


class TimerScope extends StatelessWidget {
  const TimerScope({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }

  static Map<Key, TimerState> _states = {};
  static TimerState of(Key? key) {
    if (key == null) {
      return TimerState();
    } else if (!_states.containsKey(key)) {
      _states[key] = TimerState();
    }
    return _states[key]!;
  }

  static TimerState state(Key key) {
    return of(key);
  }
}

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
  late VoidCallback animListener;
  late VoidCallback stateListener;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: widget.duration
    );
    final TimerState state = TimerScope.of(widget.key);
    if (state.isPlaying) {
      animController.forward(from: state.current);
    }

    stateListener = () {
      if (state.isPlaying) {
        animController.forward(from: state.current);
      } else if (state.isPaused) {
        animController.stop();
      }
    };
    state.addListener(stateListener);

    animListener = () {
      if (animController.status == AnimationStatus.completed && !state.isFinished) {
        state.finished();
        widget.onFinished();
      }
      state.current = animController.value;
    };
    animController.addListener(animListener);
  }

  @override
  void dispose() {
    TimerScope.of(widget.key).removeListener(stateListener);
    animController.removeListener(animListener);
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


