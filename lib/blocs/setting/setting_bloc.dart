import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:darka/blocs/setting/setting_event.dart';

class SettingBloc extends Bloc<SettingEvent, bool> {
  @override
  bool get initialState => false;

  @override
  Stream<bool> mapEventToState(
    event,
  ) async* {
    if (event is ToggleDarkMode) {
      yield event.isEnable;
    }
  }
}
