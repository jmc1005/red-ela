import 'package:flutter/foundation.dart';

abstract class StateNotifier<State> extends ChangeNotifier {
  StateNotifier(this._state) : _oldstate = _state;

  State _state, _oldstate;
  bool _mounted = true;

  State get state => _state;
  State get oldstate => _oldstate;
  bool get mounted => _mounted;

  set state(State newState) {
    _update(newState);
  }

  void onlyUpdate(State newState) {
    _update(newState, notify: false);
  }

  void _update(
    State newState, {
    bool notify = true,
  }) {
    if (state != newState) {
      _oldstate = _state;
      _state = newState;

      if (notify) {
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
