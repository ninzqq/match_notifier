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
        title: Text('$team details'),
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

    final upcomingMatchesTable = html
        .querySelectorAll(
            '.standard-headline + table > tbody > tr > td.matchpage-button-cell')
        .map((e) => e.innerHtml.trim());

    //final upcomingMatches = upcomingMatchesTable
    //    .querySelectorAll('.standard-headline + table > tbody > tr > td ')
    //    .map((e) => e.innerHtml.trim());

    print(upcomingMatchesTable.length);

    for (final match in upcomingMatchesTable) {
      print(match);
    }
  }
}
