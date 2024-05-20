import 'package:flutter/material.dart';

class NextMatchItem with ChangeNotifier {
  String team;
  DateTime date;
  bool nextMatchFound;
  bool matchesFetched;

  NextMatchItem(
    this.team,
    this.date,
    this.nextMatchFound,
    this.matchesFetched,
  );

  void set(team, date, nextMatchFound, matchesFetched) {
    this.team = team;
    this.date = date;
    this.nextMatchFound = nextMatchFound;
    this.matchesFetched = matchesFetched;
    notifyListeners();
  }
}
