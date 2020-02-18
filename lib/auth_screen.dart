
import 'package:bloc_provider_architecture/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'InfoScreen/screen.dart';
import 'MainBloc/actions.dart';
import 'MainBloc/bloc.dart';
import 'MainBloc/states.dart';

class AuthScreen extends StatefulWidget {

  static const String nameMenuItem = '/';

  AuthScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilderWithListener<MainBlocState>(
        stream: bloc.blocStream.stream,
        listener: (value) {
          //not allowed call navigator push in build
          if (value is IsLogged) {
            Navigator.of(context).pushReplacementNamed(InfoScreen.nameMenuItem);
          }
        },
        initialData: bloc.state,
        builder: (context, snappShot) {
          if (snappShot.data is IsLoggedOnStart) {
            return LoggedWidget();
          } else if (snappShot.data is IsLogged) {
            //not allowed call navigator push in build
            return ModalProgressHUD(
                inAsyncCall: true,
            child: Text(''),);
          } else if (snappShot.data is IsNotLogged) {
            return SignInAndSignUpWidget();
          }
          return Scaffold(body: Text("                Unknown event"));
        });
  }
}

class SignInAndSignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Provider.of<MainBloc>(context, listen: false).state.busy,
      child: Scaffold(
        appBar: AppBar(title: Text("SignIn/SignUp")),
        body: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                flexibleSpace: SafeArea(
                  child: TabBar(
                    tabs: <Widget>[
                      Tab(
                        text: 'enter'
                      ),
                      Tab(
                        text: 'registration'
                      ),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                children: <Widget>[SigInWidget(), SignUpWidget()],
              ),
            )),
      ),
    );
  }
}

class SigInWidget extends StatefulWidget {
  @override
  _SigInWidgetState createState() => _SigInWidgetState();
}

class _SigInWidgetState extends State {
  String _email, _password;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _emailController,
          onSaved: (input) => _email = input,
          decoration: InputDecoration(
              labelText: 'email')
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
        ),
        RaisedButton(
          child: Text('signin'),
          onPressed: () {
            Provider.of<MainBloc>(context, listen: false)
                .mapEventToState(LogIn(_email, _password));
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _email = _emailController.text;
  }

  void _onPasswordChanged() {
    _password = _passwordController.text;
  }
}

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetWidgetState createState() => _SignUpWidgetWidgetState();
}

class _SignUpWidgetWidgetState extends State {
  String _email, _password;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
              labelText: 'email'),
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
              labelText: 'password'),
        ),
        RaisedButton(
            child: Text('sign up'),
            onPressed: () {
              Provider.of<MainBloc>(context, listen: false).mapEventToState(
                  Registration(_email, _password));
            })
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _email = _emailController.text;
  }

  void _onPasswordChanged() {
    _password = _passwordController.text;
  }
}

class LoggedWidget extends StatefulWidget {
  @override
  _LoggedWidgetState createState() => _LoggedWidgetState();
}

class _LoggedWidgetState extends State<LoggedWidget> {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<MainBloc>(context, listen: false);
    return ModalProgressHUD(
      inAsyncCall: bloc.state.busy,
      child: Scaffold(
          appBar: AppBar(title: Text("make a choice")),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                RaisedButton(
                    child: Text('continue'),
                    onPressed: () {
                      bloc.mapEventToState(Continue());
                    }),
                RaisedButton(
                    child: Text('change_user'),
                    onPressed: () {
                      bloc.mapEventToState(LogOut());
                    }),
              ],
            ),
          )),
    );
  }
}