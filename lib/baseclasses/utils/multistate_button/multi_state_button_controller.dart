import 'package:flutter/material.dart';

class MultiStateButtonController {
  /// Pass the [ButtonState.stateName] to set the initialState.
  MultiStateButtonController({String initialStateName = ""})
      : _buttonStateName = ValueNotifier(initialStateName);

  final ValueNotifier<String> _buttonStateName;
  ValueNotifier<String> get buttonStateName => _buttonStateName;

  /// Pass the [ButtonState.stateName] to set the current button state.
  set setButtonState(String stateName) => _buttonStateName.value = stateName;
}