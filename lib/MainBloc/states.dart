abstract class MainBlocState{
  bool busy;
  MainBlocState({this.busy = false});

  copy(bool busy) {
    return null;
  }
}

class AppStarting extends MainBlocState {
  AppStarting({bool busy = false}) : super(busy: busy);

  @override
  copy(bool busy) {
    return AppStarting(busy: busy);
  }
}

class IsLogged extends MainBlocState {
  IsLogged({bool busy = false}) : super(busy: busy);

  @override
  copy(bool busy) {
    return IsLogged(busy: busy);
  }
}

class IsLoggedOnStart extends MainBlocState {
  IsLoggedOnStart({bool busy = false}) : super(busy: busy);

  @override
  copy(bool busy) {
    return IsLoggedOnStart(busy: busy);
  }
}

class IsNotLogged extends MainBlocState {
  bool _passwordNotValid = false;
  bool get passwordNotValid => _passwordNotValid;
  bool _loginNotValid = false;
  bool get loginNotValid => _loginNotValid;

  IsNotLogged(
      {bool loginNotValid = false,
        bool passwordNotValid = false,
        bool busy = false})
      : super(busy: busy) {
    this._loginNotValid = loginNotValid ?? false;
    this._passwordNotValid = passwordNotValid ?? false;
  }

  @override
  copy(bool busy) {
    return IsNotLogged(busy: busy);
  }
}

