import 'package:flutter/material.dart';

import '../widgets/action_button.dart';

class HomeController extends ChangeNotifier {
  int _currentIndex = 0;
  bool _open = false;

  int get currentIndex => _currentIndex;
  bool get open => _open;

  void onCurrentIndexChange(int currentIndex) {
    _currentIndex = currentIndex;
    notifyListeners();
  }

  void onOpenChange(bool open) {
    _open = open;
    notifyListeners();
  }

  List<Widget> get actionButtonList {
    return [
      ActionButton(
        onPressed: () {},
        icon: const Icon(Icons.format_size),
      ),
      ActionButton(
        onPressed: () {},
        icon: const Icon(Icons.insert_photo),
      ),
      ActionButton(
        onPressed: () {},
        icon: const Icon(Icons.videocam),
      )
    ];
  }
}
