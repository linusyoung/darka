import 'package:meta/meta.dart';

@immutable
abstract class SettingEvent {}

class ToggleDarkMode extends SettingEvent {
  final bool isEnable;

  ToggleDarkMode(this.isEnable);

  @override
  String toString() => 'ToggleDarkMode { isEnable : $isEnable }';
}
