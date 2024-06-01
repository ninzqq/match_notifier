import 'package:flutter/material.dart';
import 'package:hltv_match_notifier/src/models/local_models.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'next_match_item.dart';
import 'package:provider/provider.dart';

/// Displays detailed information about a SampleItem.
class TeamDetailsView extends StatelessWidget {
  const TeamDetailsView({
    super.key,
    required this.team,
    required this.address,
  });

  final String team;
  final String address;

  static const routeName = '/team_item';

  @override
  Widget build(BuildContext context) {
    var nextMatch = context.read<NextMatchItem>();

    return Scaffold(
      appBar: AppBar(
          title: Text(
        '$team matches',
      )),
      body: FutureBuilder(
        future: fetchMatches(team, nextMatch),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error...');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error...');
            } else if (snapshot.hasData) {
              checkNextMatchUrgency(nextMatch.date);
              return Center(
                child: nextMatch.nextMatchFound
                    ? Text('Next match for $team:\n${nextMatch.date}')
                    : Text('No upcoming matches for $team'),
              );
            } else {
              return const Text('Some shit? Errors....');
            }
          } else {
            return const Center(
              child: Text('Loading matches... '),
            );
          }
        },
      ),
    );
  }

  Future fetchMatches(team, nextMatch) async {
    const String hltv = 'https://www.hltv.org/team/';
    String teamPage = '$hltv$address';
    final url = Uri.parse(teamPage);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final checkForNoMatches = html
        .querySelector(
            '.standard-headline + div.empty-state + div.section-spacer')
        ?.innerHtml
        .trim();

    final nextUpcomingMatchDate = html
        .querySelector('.standard-headline + table > tbody > tr > td.date-cell')
        ?.innerHtml
        .trim();

    if (checkForNoMatches != null || nextUpcomingMatchDate == null) {
      nextMatch.set(team, DateTime.now(), false, true);
      return 0;
    } else {
      final upcomingMatchesEventTitle = html
          .querySelectorAll(
              '.standard-headline + table > thead > tr > th.text-ellipsis > a + div.')
          .map((e) => e.innerHtml.trim());

      final upcomingMatchesDates = html
          .querySelectorAll(
              '.standard-headline + table > tbody > tr > td.date-cell')
          .map((e) => e.innerHtml.trim());

      final upcomingMatchesHrefs = html
          .querySelectorAll(
              '.standard-headline + table > tbody > tr > td.matchpage-button-cell')
          .map((e) => e.innerHtml.trim());

      print('Event: ${upcomingMatchesEventTitle}');
      print('Match count: ${upcomingMatchesHrefs.length}');
      print('Next match at: $nextUpcomingMatchDate');

      DateTime dt;
      for (int i = 0; i < upcomingMatchesHrefs.length; i++) {
        var link = upcomingMatchesHrefs.elementAt(i).split('"');
        var date = upcomingMatchesDates.elementAt(i).split('"');
        dt = DateTime.fromMillisecondsSinceEpoch(int.parse(date[3]));

        print('Link: ${link[1]} | Date: $dt');
      }
      dt = DateTime.fromMillisecondsSinceEpoch(
          int.parse(nextUpcomingMatchDate.split('"')[3]));
      nextMatch.set(team, dt, true, true);
      return 0;
    }
  }

  checkNextMatchUrgency(DateTime date) {
    var roundedDate = nearestQuarter(date);
    var roundedNow = nearestQuarter(DateTime.now());
    var dayFromNow = roundedNow.add(const Duration(days: 1));
    if (roundedDate.isAtSameMomentAs(roundedNow)) {
      print('No upcoming matches');
    } else if (roundedDate.isBefore(dayFromNow)) {
      print('Less than 1 day away!');
    } else {
      print('Faar away');
    }
  }

  DateTime nearestQuarter(DateTime val) {
    return DateTime(val.year, val.month, val.day, val.hour,
        [0, 15, 30, 45, 60][(val.minute / 15).floor()]);
  }
}
