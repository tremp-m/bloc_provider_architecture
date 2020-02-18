import 'package:bloc_provider_architecture/MainBloc/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class MainData {
  static final firebaseInst = FirebaseAuth.instance;
  static MainBlocState _authState = IsNotLogged();
  static MainBlocState get authState => _authState;
  static String _uid;
  static String get uid => _uid;
  static String _email;
  static String get email => _email;

  void setState(MainBlocState newState,
      {String uid = '', String email = ''}) {
    _authState = newState;
    _uid = uid;
    _email = email;
  }
}

class MainRepo{

  final MainData data = MainData();

  FirebaseAuth get firebaseInst => MainData.firebaseInst;

  FirebaseUser _currentUser;

  Future<bool> createUserWithEmailAndPassword(
      String email, String password) async {
    var dataUser;
      try {
        dataUser =
            (await firebaseInst.createUserWithEmailAndPassword(
                email: email, password: password))
                .user;
      } catch (e) {
        print(Error.safeToString(e));
        print(e.code);
        print(e.message);
      }
      if (dataUser == null){
        data.setState(IsNotLogged());
        return false;
      }

      _currentUser = dataUser;
      data.setState(IsLogged(),
          uid: _currentUser.uid,
          email: _currentUser.email);
    return true;
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    var dataUser;

      try {
        dataUser = (await firebaseInst.signInWithEmailAndPassword(
            email: email, password: password))
            .user;
      } catch (e) {
        print(Error.safeToString(e));
        print(e.code);
        print(e.message);
      }
    if (dataUser == null){
      data.setState(IsNotLogged());
      return false;
    }

    _currentUser = dataUser;
    data.setState(IsLogged(),
        uid: _currentUser.uid,
        email: _currentUser.email);

    return true;
  }

  String getEmail() {
    if (data != null) {
      return MainData.email;
    }
    return '';
  }

  String getUid() {
    if (data != null) {
      return MainData.uid;
    }
    return '';
  }

  bool isLogged() {
    if ((data != null) && (MainData.authState is IsLogged)) {
      return true;
    }
    return false;
  }

  Future<bool> isLoggedOnAppStart() async {
    try {
        _currentUser = await firebaseInst.currentUser();

        if (_currentUser != null) {
          data.setState(IsLogged(),
              uid: _currentUser.uid,
              email: _currentUser.email);
        } else {
          data.setState(IsNotLogged());
          return false;
        }
      } catch (e) {
        print(Error.safeToString(e));
        return false;
      }
      return isLogged();
  }

  Future<void> signOut() async {
    if (firebaseInst != null) {
      firebaseInst.signOut();
    }
    data.setState(IsNotLogged());
    return null;
  }
}
