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