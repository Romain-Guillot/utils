import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:utils/src/padding.dart';
import 'package:utils/src/theme_extension.dart';


class NavigationItem {
  const NavigationItem({
    required this.icon,
    required this.label,
    required this.selectedIcon,
    required this.child,
  });
  
  final Icon icon;
  final Icon selectedIcon;
  final String label;
  final Widget child;
}


class AdaptativeNavigation {
  const AdaptativeNavigation({
    required this.selected,
    required this.items,
    required this.onChange,
    required this.header,
  });

  final int selected;
  final List<NavigationItem> items;
  final void Function(int index) onChange;
  final Widget header;
}


class AdaptativeScaffold extends StatelessWidget {
  const AdaptativeScaffold({
    Key? key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.navigation,
  }) : super(key: key);
  
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final DrawerCallback? onDrawerChanged;
  final Widget? endDrawer;
  final DrawerCallback? onEndDrawerChanged;
  final Color? drawerScrimColor;
  final Color? backgroundColor;
  final Widget? bottomSheet;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final Widget? body;
  final AdaptativeNavigation? navigation;


  Widget? _buildNavigationRail(BuildContext context, AdaptativeNavigation navigation) {
    return LinearNavigationRail(
      header: navigation.header,
      floatingActionButton: floatingActionButton,
      selectedIndex: navigation.selected,
      onDestinationSelected: (int index) => navigation.onChange(index),
      items: navigation.items.map((NavigationItem item) => NavigationRailDestination(
        selectedIcon: item.selectedIcon,
        icon: item.icon,
        label: Text(item.label)
      ),).toList()
    );
  }

  Widget? _buildNavigationBar(BuildContext context, AdaptativeNavigation navigation) {
    return  BottomNavigationBar(
      currentIndex: navigation.selected,
      onTap: (int index) => navigation.onChange(index),
      items: navigation.items.map((NavigationItem page) => BottomNavigationBarItem(
        activeIcon: page.selectedIcon,
        icon: page.icon,
        label: page.label
      ),).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool isLargeLayout = constraints.maxWidth >= ThemeExtension.of(context).mobileScreenMax;
        Widget? navigationRail;
        Widget? bottomNavBar;
        if (navigation != null) {
          if (isLargeLayout) {
            navigationRail = _buildNavigationRail(context, navigation!);
          } else {
            bottomNavBar = _buildNavigationBar(context, navigation!);
          }
        }
        return Scaffold(
          appBar: appBar,
          backgroundColor: backgroundColor,
          bottomNavigationBar: bottomNavBar,
          bottomSheet: bottomSheet,
          drawer: drawer,
          drawerDragStartBehavior: drawerDragStartBehavior,
          drawerEdgeDragWidth: drawerEdgeDragWidth,
          drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
          drawerScrimColor: drawerScrimColor,
          endDrawer: endDrawer,
          endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
          extendBody: extendBody,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          floatingActionButton: isLargeLayout ? null : floatingActionButton,
          floatingActionButtonAnimator: floatingActionButtonAnimator,
          floatingActionButtonLocation: floatingActionButtonLocation,
          onDrawerChanged: onDrawerChanged,
          onEndDrawerChanged: onEndDrawerChanged,
          key: key,
          persistentFooterButtons: persistentFooterButtons,
          primary: primary,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          body:  Row(
            children: [
              navigationRail??Container(),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: double.maxFinite,
                    constraints: BoxConstraints(maxWidth: 1000),
                    child: body
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}



class LinearNavigationRail extends StatelessWidget {
  const LinearNavigationRail({
    Key? key,
    this.header,
    this.bottom,
    this.floatingActionButton,
    required this.items,
    required this.selectedIndex,
    this.onDestinationSelected,
  }) : super(key: key);

  final Widget? header;
  final Widget? bottom;
  final List<NavigationRailDestination> items;
  final int selectedIndex;
  final void Function(int index)? onDestinationSelected;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme!;
    final IconThemeData selectedIconTheme = Theme.of(context).bottomNavigationBarTheme.selectedIconTheme!;
    final TextStyle selectedLabelStyle = Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle!;
    final TextStyle labelStyle = Theme.of(context).bottomNavigationBarTheme.unselectedLabelStyle!;
    return Container(
      width: 225,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (header != null)
            Padding(
              padding: EdgeInsets.all(ThemeExtension.of(context).padding),
              child: header,
            ),
          if (floatingActionButton != null)
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(ThemeExtension.of(context).padding),
              child: floatingActionButton,
            ),
          ...items.asMap().entries.map((MapEntry<int, NavigationRailDestination> item) {
            final bool isSelected = selectedIndex == item.key;
            return InkWell(
              onTap: () => onDestinationSelected?.call(item.key),
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(ThemeExtension.of(context).padding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconTheme(
                      data: isSelected ? selectedIconTheme : iconTheme,
                      child: isSelected ? item.value.selectedIcon : item.value.icon
                    ),
                    PaddingSpacer(type: PaddingType.small),
                    DefaultTextStyle(
                      style: isSelected ? selectedLabelStyle : labelStyle,
                      child: item.value.label!
                    )
                  ],
                ),
              ),
            );
          }).toList()
        ],
      ),
    );
  }
}