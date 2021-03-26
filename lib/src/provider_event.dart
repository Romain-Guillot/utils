import 'package:flutter/foundation.dart';


class ProviderEvent<T> {
  ProviderEvent();
  ProviderEvent.fromEvent(this.event);
  T? event;

  void addEvent(T event) => this.event = event;
  bool get hasEvent => event != null;
  T? consumeEvent() {
    final T? result = event;
    event = null;
    return result;
  }
}



enum EventType {
  success,
  error,
}


@immutable
class Event {
  const Event({
    required this.type,
    this.error
  });

  const Event.success() : this(type: EventType.success, error: null);
  const Event.error(dynamic e) : this(type: EventType.error, error: e);

  final EventType type;
  final dynamic? error;
}