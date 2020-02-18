import 'package:bloc_provider_architecture/MainBloc/actions.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'InfoScreen/screen.dart';
import 'MainBloc/bloc.dart';
import 'PhonebookScreen/screen.dart';
import 'auth_screen.dart';

Map<String, Widget Function(BuildContext)> menuRoutes = {
  '/': (context) => AuthScreen(),
  InfoScreen.nameMenuItem: (context) => InfoScreen(),
  PhonebookScreen.nameMenuItem: (context) => PhonebookScreen(),
};

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            key: Key('Info'),
            leading: Icon(Icons.info_outline),
            title: Text('Info'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(InfoScreen.nameMenuItem);
            },
          ),
          ListTile(
            key: Key('Phonebook'),
            leading: Icon(Icons.add_call),
            title: Text('Phonebook'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(PhonebookScreen.nameMenuItem);
            },
          ),
          ListTile(
            key: Key('LogOut'),
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () {
              Provider.of<MainBloc>(context, listen: false).mapEventToState(LogOut());
              Navigator.of(context).pushReplacementNamed(AuthScreen.nameMenuItem);
            },
          ),

        ],
      ),
    );
  }
}
