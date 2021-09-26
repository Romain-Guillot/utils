
import 'package:flutter/material.dart';

class GridColumn<T> {
  const GridColumn({
    required this.label,
    required this.renderer,
    this.onSort,
    this.weight = 1
  });

  final Widget label;
  final Widget Function(T) renderer;
  final VoidCallback? onSort;
  final int weight;
}


class GridHeaderStyle {
  const GridHeaderStyle({
    this.background,
    this.textStyle,
    this.verticalSpacing
  });

  final Color? background;
  final TextStyle? textStyle;
  final double? verticalSpacing;
}


class GridRowStyle {
  const GridRowStyle({
    this.padding = EdgeInsets.zero
  });

  final EdgeInsets padding;
}


class DataGridTheme {
  const DataGridTheme({
    this.headerStyle,
    this.rowStyle
  });

  final GridHeaderStyle? headerStyle;
  final GridRowStyle? rowStyle;
}


class DataGrid<T> extends StatelessWidget {
  const DataGrid({
    Key? key,
    required this.columns,
    required this.values,
    this.theme,
    this.onClick,
  }) : super(key: key);

  final List<GridColumn<T>> columns;
  final List<T> values;
  final Function(T)? onClick;
  final DataGridTheme? theme;

  Widget buildHeader(BuildContext context) {
    Widget header = DefaultTextStyle(
      style: theme?.headerStyle?.textStyle??Theme.of(context).textTheme.bodyText1!,
      child: Builder(builder: (BuildContext context) => Row(
      children: columns.map((GridColumn<T> column) => Expanded(
          flex: column.weight,
          child: column.label,
        ),
      ).toList(),
      )
    ));

    header = Container(
      padding: EdgeInsets.symmetric(
        vertical: theme?.headerStyle?.verticalSpacing??0.0,
        horizontal: (theme?.rowStyle?.padding.horizontal??0) / 2
      ),
      child: header,
    );


    if (theme?.headerStyle?.background != null) {
      header = Material(
        color: theme?.headerStyle?.background,
        child: header,
      );
    }


    return header;
  }

  @override
  Widget build(BuildContext context) {
    final Widget header = buildHeader(context);
    return Column(
      children: <Widget>[
        header,
        Expanded(
          child: ListView.separated(
            itemCount: values.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (BuildContext context, int index) {
              final T item = values[index];
              Widget child = Container(
                padding: theme?.rowStyle?.padding??EdgeInsets.zero,
                child: Row(
                  children: columns.map((GridColumn<T> column) => Expanded(
                    flex: column.weight,
                    child: column.renderer(item)
                  )).toList(),
                ),
              );
              if (onClick != null) {
                child = InkWell(
                  onTap: () => onClick!.call(item),
                  child: child,
                );
              }
              return child;
            },
          )
        )
      ],
    );
  }
}



