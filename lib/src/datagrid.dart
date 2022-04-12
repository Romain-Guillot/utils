import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:collection/collection.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:utils/src/theme_extension.dart';


enum ColumnSortOrder {
  asc,
  desc
}


typedef OnSortColumn = Function(ColumnSortOrder order);
typedef ColumnRenderer<T> = Widget Function(int index, T data);


class GridColumn<T> {
  const GridColumn({
    required this.key,
    this.label,
    this.child,
    required this.renderer,
    this.onSort,
    this.weight = 1,
    this.width,
    this.alignment = Alignment.centerLeft,
    this.isDefaultSortOrder = false
  }) : assert((label != null || child != null) && (label == null || child == null));

  final Key key;
  final Widget? child;
  final String? label;
  final ColumnRenderer<T> renderer;
  final OnSortColumn? onSort;
  final int weight;
  final Alignment alignment;
  final bool isDefaultSortOrder;
  final double? width;

  @override
  bool operator ==(other) {
    if (other is! GridColumn) {
      return false;
    }
    return (other.key == key);
  }

  @override
  int get hashCode => key.hashCode;

}

class GridColumnSpacer<T> extends GridColumn<T> {
  GridColumnSpacer([double? width]) : super(
    key: GlobalKey(),
    width:  width ?? 15.0,
    label: '',
    renderer: (_, __) => Container()
  );
}


class GridHeaderStyle {
  const GridHeaderStyle({
    this.decoration,
    this.textStyle,
    this.verticalSpacing
  });

  final TextStyle? textStyle;
  final double? verticalSpacing;
  final Decoration? decoration;
}


class GridRowStyle {
  const GridRowStyle({
    this.padding = EdgeInsets.zero,
    this.decoration,
    this.minHeight,
  });

  final EdgeInsets padding;
  final Decoration? decoration;
  final double? minHeight;
}


class DataGridTheme {
  const DataGridTheme({
    this.headerStyle,
    this.rowStyle
  });

  final GridHeaderStyle? headerStyle;
  final GridRowStyle? rowStyle;
}

class _Header<T> extends StatefulWidget {
  const _Header({ 
    Key? key,
    required this.theme,
    required this.columns
  }) : super(key: key);

  final DataGridTheme? theme;
  final List<GridColumn<T>> columns;

  @override
  __HeaderState createState() => __HeaderState<T>();
}

class __HeaderState<T> extends State<_Header<T>> {

  GridColumn<T>? sortColumn;
  ColumnSortOrder? sortOrder;

  DataGridTheme? get theme => widget.theme;
  List<GridColumn<T>> get columns => widget.columns;

  @override
  void initState() {
    super.initState();
    sortColumn = columns.firstWhereOrNull((e) => e.isDefaultSortOrder == true);
    if (sortColumn != null) {
      sortOrder = ColumnSortOrder.asc;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget header = DefaultTextStyle.merge(
      style: theme?.headerStyle?.textStyle ?? Theme.of(context).textTheme.subtitle1!,
      child: Builder(builder: (BuildContext context) => Row(
      children: columns.map((GridColumn<T> column) {
        Widget child = column.child != null 
          ? column.child!
          : AutoSizeText(
              column.label!, 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
        if (column.onSort != null) {
          child =  InkWell(
            onTap: () {
              setState(() {
                sortColumn = column;
                if (sortColumn == column) {
                  sortOrder = sortOrder == ColumnSortOrder.asc ? ColumnSortOrder.desc : ColumnSortOrder.asc;
                } else {
                  sortOrder = ColumnSortOrder.asc;
                }
                sortColumn?.onSort?.call(sortOrder!);
              });

            },
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                child,
                Icon(
                  sortColumn == column 
                    ? (sortOrder == ColumnSortOrder.desc ? Icons.arrow_drop_up : Icons.arrow_drop_down)
                    : Icons.arrow_drop_down,
                  color: sortColumn == column 
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).disabledColor
                )
              ],
            ),
          );
        }
        final isFixed = column.width != null;
        child = Align(
          alignment: column.alignment,
          child: child
        );
        if (isFixed) {
          return SizedBox(
            width: column.width,
            child: child
          );
        } else {
          return Expanded(
            flex: column.weight,
            child: child
          );
        }
      },
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


    if (theme?.headerStyle?.decoration != null) {
      header = Container(
        decoration: theme?.headerStyle?.decoration,
        child: Material(
          type: MaterialType.transparency,
          child: header
        ),
      );
    }

    return header;
  }
}

enum GridHeaderBehavior {
  fixed,
  hide,
}

class DataGrid<T> extends StatelessWidget {
  const DataGrid({
    Key? key,
    required this.columns,
    required this.values,
    this.theme,
    this.onClick,
    this.headerBeahavior = GridHeaderBehavior.fixed,
    this.primary = true,
    this.scrollPhysics
  }) : super(key: key);

  final List<GridColumn<T>> columns;
  final List<T> values;
  final Function(T)? onClick;
  final DataGridTheme? theme;
  final GridHeaderBehavior headerBeahavior;
  final bool primary;
  final ScrollPhysics? scrollPhysics;


  @override
  Widget build(BuildContext context) {
    final effectiveTheme = ThemeExtension.of(context).dataGridTheme ?? theme;
    Widget child = MultiSliver(
      children: <Widget>[
        if (headerBeahavior != GridHeaderBehavior.hide)
          SliverPinnedHeader(
            child: _Header(
              theme: effectiveTheme,
              columns: columns,
            )
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final T item = values[index];
              Widget child = Container(
                decoration: effectiveTheme?.rowStyle?.decoration,
                constraints: BoxConstraints(
                  minHeight: effectiveTheme?.rowStyle?.minHeight ?? 0.0
                ),
                padding: effectiveTheme?.rowStyle?.padding ?? EdgeInsets.zero,
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyText1!,
                  child: Row(
                    children: columns.map((GridColumn<T> column) {
                      final isFixed = column.width != null;
                      final child = Align(
                        alignment: column.alignment,
                        child: column.renderer(index, item)
                      );
                      if (isFixed) {
                        return SizedBox(
                          width: column.width,
                          child: child
                        );
                      } else {
                        return Expanded(
                          flex: column.weight,
                          child: child
                        );
                      }
                      
                    }).toList(),
                  ),
                ),
              );
              if (onClick != null) {
                child = InkWell(
                  onTap: () => onClick!.call(item),
                  child: child,
                );
              }
              return Material(
                color: Colors.transparent,
                child: child
              );
            },
            childCount: values.length,
          )
        )
      ],
    );
    if (primary == true) {
      child = CustomScrollView(
        physics: scrollPhysics,
        slivers: [
          child,
        ],
      );
    }

    return child;
  }
}
