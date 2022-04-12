import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utils/src/padding.dart';
import 'package:utils/src/theme_extension.dart';

class ProviderValue<T, K> {
  ProviderValue();
  
  ProviderValue.fromValue(T? value) {
    this.value = value;
  }

  T? _value;
  set value(T? value) {
    _value = value;
    _initialized = true;
    _error = null;
  }
  T? get value => _value;
  bool get hasData {
    if (value is Iterable) {
      return value != null && (value as Iterable<dynamic>).isNotEmpty;
    } else {
      return value != null;
    }
  }


  K? _error;
  set error(K? error) {
    _error = error;
    _initialized = true;
    _value = null;
  }
  K? get error => _error;
  bool get hasError => _error != null;


  bool? _initialized;
  bool get isInitialized => _initialized == true;
  bool get isNotInitialized => !isInitialized;

  void reset() {
    _error = null;
    _value = null;
    _initialized = false;
  }
}



/// [EmptyDataWidget]
/// [ErrorDataWidget]
/// [LoadingDataWidget]
class ProviderValueBuilder<T, K> extends StatelessWidget {
  const ProviderValueBuilder({
    Key? key,
    required this.value,
    required this.dataBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.emptyDataBuilder,
    this.isSliver = false
  }) : super(key: key);

  final ProviderValue<T, K> value;

  final bool isSliver;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, K? error)? errorBuilder;
  final Widget Function(BuildContext context, T? value) dataBuilder;
  final Widget Function(BuildContext context)? emptyDataBuilder;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (value.hasError) {
      child = errorBuilder != null 
        ? errorBuilder!(context, value.error) 
        : DefaultErrorWidget(error: value.error.toString());
    } else if (!value.isInitialized) {
      child =  loadingBuilder != null 
        ? loadingBuilder!(context) 
        : DefaultLoadingWidget();
    } else if (emptyDataBuilder != null && !value.hasData) {
      child = emptyDataBuilder != null 
        ? emptyDataBuilder!.call(context) 
        : DefaultEmptyDataWidget(child: Text('no data'));
    } else {
      return dataBuilder(context, value.value);
    }
    if (isSliver) {
      child  = SliverToBoxAdapter(child: child);
    }
    return child;

  }
}


class DefaultLoadingWidget extends StatelessWidget {
  const DefaultLoadingWidget({
    Key? key,
    this.label
  }) : super(key: key);

  final Widget? label;

  @override
  Widget build(BuildContext context) {
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        if (label != null)
          DefaultTextStyle.merge(
            style: Theme.of(context).textTheme.bodyText1 ?? TextStyle(),
            child: Padding(
              padding: EdgeInsets.only(left: ThemeExtension.of(context).padding),
              child: label
            ),
          )
      ],
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


class DefaultEmptyDataWidget extends StatelessWidget {
  const DefaultEmptyDataWidget({
    Key? key,
    required this.child,
    this.refreshButtonLabel,
    this.onRefresh,
  }) : super(key: key);

  final Widget child;
  final String? refreshButtonLabel;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DefaultTextStyle.merge(
            style: Theme.of(context).textTheme.caption,
            child: child
          ),
          PaddingSpacer(),
          if (onRefresh != null)
            TextButton.icon(
              onPressed: onRefresh,
              icon: Icon(Icons.refresh), 
              label: Text(refreshButtonLabel??'Refresh'),
            )
        ],
      ),
    );
  }
}