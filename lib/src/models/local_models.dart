import 'package:flutter/material.dart';

class AppFlags with ChangeNotifier {
  bool matchesFetchedRecently;

  AppFlags({
    this.matchesFetchedRecently = false,
  });

  void setMatchesFetched(bool b) {
    matchesFetchedRecently = b;
    notifyListeners();
  }
}
