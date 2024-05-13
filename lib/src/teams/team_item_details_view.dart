import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

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
    var matches = fetchMatches();
    return Scaffold(
      appBar: AppBar(
        title: Text('$team matches'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }

  fetchMatches() async {
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

    if (checkForNoMatches != null) {
      print('No upcoming matches');
      return 'No upcoming matches';
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

      print('Event: $upcomingMatchesEventTitle');
      print('Match count: ${upcomingMatchesHrefs.length}');

      for (int i = 0; i < upcomingMatchesHrefs.length; i++) {
        var link = upcomingMatchesHrefs.elementAt(i).split('"');
        var date = upcomingMatchesDates.elementAt(i).split('"');
        var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(date[3]));

        print('Link: ${link[1]} | Date: $dt');
      }
    }
  }
}
