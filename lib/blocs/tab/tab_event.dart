import 'package:darka/model/app_tab.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TabEvent {}

class UpdateTab extends TabEvent {
  final AppTab tab;

  UpdateTab(this.tab);

  @override
  String toString() => 'UpdateTab { tab : $tab }';
}
