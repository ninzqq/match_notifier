import 'package:chaleno/chaleno.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

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
    String hltv = 'https://www.hltv.org/team/';
    String teamPage = '$hltv$address';
    var parser = await Chaleno().load(teamPage);
    List<Result> results = parser!.getElementsByClassName('standard-headline');
    results.map((item) => print(item.innerHTML));
    return results;
  }
}
