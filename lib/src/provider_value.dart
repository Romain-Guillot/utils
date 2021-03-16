import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderValue<T> {

  T? _data;
  T? get data => _data;
  set data(T? data) {
    _initialized = true;
    _data = data;
    _error = null;
  }

  String? _error;
  String? get error => _error;
  set error(String? error) {
    _initialized = true;
    _error = error;
    _data = null;
  }

  bool get hasError => _error != null;

  bool get isEmpty => data == null || (data is Iterable && (data! as Iterable<dynamic>).isEmpty) || (data is Map && (data! as Map<dynamic, dynamic>).isEmpty); 
  
  bool get isInitialized => _initialized  == true;
  bool? _initialized;
}


class ProviderValueBuilder<T> extends StatelessWidget {
  const ProviderValueBuilder({
    Key? key,
    required this.value,
    required this.dataBuilder,
    this.emptyDataBuilder,
    this.loadingBuilder,
    this.errorBuilder,
  }) : super(key: key);

  final ProviderValue<T> value;
  final Widget Function(BuildContext context, T? data) dataBuilder;
  final Widget Function(BuildContext context)? emptyDataBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, String? error)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    if (!value.isInitialized) {
      return loadingBuilder?.call(context)??DefaultLoadingWidget();
    } else if (value.hasError) {
      return errorBuilder?.call(context, value.error)??DefaultErrorWidget(error: value.error,);
    } else if (emptyDataBuilder != null && value.isEmpty) {
      return emptyDataBuilder!.call(context);
    } else {
      return dataBuilder.call(context, value.data);
    }
  }
}


class DefaultLoadingWidget extends StatelessWidget {
  const DefaultLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}


class DefaultErrorWidget extends StatelessWidget {
  const DefaultErrorWidget({
    Key? key,
    required this.error
  }) : super(key: key);

  final String? error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error!),
    );
  }
}