import 'package:provider/provider.dart';
import 'package:bloc_provider_architecture/MainBloc/bloc.dart';
import 'package:flutter/material.dart';

import '../menu.dart';

class InfoScreen extends StatelessWidget {
  static const String nameMenuItem = "/info";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Info Screen"),
      ),
      drawer: MenuWidget(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Text(Provider.of<MainBloc>(context, listen: false).repo.getEmail())),
    ));
  }
}