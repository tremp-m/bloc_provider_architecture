
import 'package:bloc_provider_architecture/MainBloc/states.dart';

import '../util.dart';
import 'actions.dart';
import 'data_model.dart';

class MainBloc {
  final MainRepo repo = MainRepo();

  MainBlocState _state = AppStarting();
  MainBlocState get state => _state;
  set state(authState) {
    this._state = authState;
    blocStream.eventOut = authState;
  }

  BlocStream<MainBlocState> blocStream = BlocStream();
  MainBloc() {
    mapEventToState(AppStart());
  }

  Future<void> mapEventToState(MainBlocAction event) async {
    state = state.copy(true);

      if (event is AppStart) {
        if (await repo.isLoggedOnAppStart()) {
          state = IsLoggedOnStart();
        } else {
          state = IsNotLogged();
        }
      } else if (event is LogIn) {
        if (await repo.signInWithEmailAndPassword(
            event.email, event.password)) {
          state = IsLogged();
        } else
          state = IsNotLogged();
      } else if (event is Registration) {
        if (await repo.createUserWithEmailAndPassword(
            event.email, event.password)) {
          state = IsLogged();
        } else
          state = IsNotLogged();
      } else if (event is Continue) {
        state = IsLogged();
      } else {
        await repo.signOut();
        state = IsNotLogged();
      }
  }

  void dispose(){

  }
}
