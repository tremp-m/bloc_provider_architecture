abstract class MainBlocAction{
  String get password => null;

  String get email => null;
}

class AppStart extends MainBlocAction {
}

class LogIn extends MainBlocAction {
  LogIn(this._email, this._password);

  final String _email;
  String get email => _email;
  final String _password;
  String get password => _password;
}

class LogOut extends MainBlocAction {
}

class Continue extends MainBlocAction {
}

class Registration extends MainBlocAction {
  Registration(this._email, this._password);

  final String _email;
  String get email => _email;
  final String _password;
  String get password => _password;
}