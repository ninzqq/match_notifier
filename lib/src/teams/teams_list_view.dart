import 'package:flutter/material.dart';
import 'package:hltv_match_notifier/src/teams/teams.dart';

import '../settings/settings_view.dart';
import 'team_item.dart';
import 'team_item_details_view.dart';

/// Displays a list of SampleItems.
class TeamListView extends StatelessWidget {
  const TeamListView({
    super.key,
    this.teams = Teams.teams,
  });

  static const routeName = '/';

  final List<TeamItem> teams;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'teamListView',
        itemCount: teams.length,
        itemBuilder: (BuildContext context, int index) {
          final team = teams[index];

          return ListTile(
              title: Text(team.name),
              leading: CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: NetworkImage(team.icon, scale: 5),
              ),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(
                  context,
                  TeamDetailsView.routeName,
                  arguments: {'team': team.name, 'address': team.address},
                );
              });
        },
      ),
    );
  }
}
