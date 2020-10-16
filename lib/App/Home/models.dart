import 'package:flutter/material.dart';

class HomeModel extends ChangeNotifier {
  int _currentPageIndex;

  int get currentPageIndex {
    return this._currentPageIndex;
  }

  set currentPageIndex(int newPageIndex) {
    if (this._currentPageIndex != newPageIndex) {
      this._currentPageIndex = newPageIndex;
      notifyListeners();
    }
  }

  HomeModel({
    @required int currentPageIndex,
  }) {
    this._currentPageIndex = currentPageIndex;
  }
}
