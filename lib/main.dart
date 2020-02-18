import 'package:bloc_provider_architecture/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'InfoScreen/screen.dart';
import 'MainBloc/bloc.dart';
import 'PhonebookScreen/screen.dart';
import 'auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => MainBloc(),
        dispose: (context, value) => value.dispose(),
        child: MaterialApp(
          routes: menuRoutes,
        ));
  }
}
