import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

class CustomTabBar extends StatefulWidget {
  final ButtonsTabBar buttonsTabBar;
  final TabBarView tabBarView;
  final int tabLenght;

  const CustomTabBar(
      {super.key,
      required this.buttonsTabBar,
      required this.tabBarView,
      required this.tabLenght});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabLenght,
      child: Column(
        children: <Widget>[
          widget.buttonsTabBar,
          Expanded(
            child: widget.tabBarView,
          ),
        ],
      ),
    );
  }
}
