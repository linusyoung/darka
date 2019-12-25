// import 'package:darka/locale/locales.dart';
import 'package:darka/model/models.dart';
import 'package:flutter/material.dart';

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            tab == AppTab.tasks ? Icons.chat : Icons.history,
          ),
          title: Text(tab == AppTab.tasks ? 'Task' : 'Summary'),
        );
      }).toList(),
    );
  }
}
