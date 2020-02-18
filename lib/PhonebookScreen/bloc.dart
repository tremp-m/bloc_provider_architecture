import 'package:bloc_provider_architecture/PhonebookScreen/actions.dart';
import 'package:bloc_provider_architecture/PhonebookScreen/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../util.dart';

class PhonebookData {

  List<dynamic> list = [];

}

class PhonebookRepository{

  PhonebookRepository._constructor();

  static final PhonebookRepository instance =
  PhonebookRepository._constructor();

  DocumentSnapshot _lDoc;

  @override
  final PhonebookData data = PhonebookData();

  addItemsInList() async {
    data.list.addAll(await getSomeNewItems());
  }

  Future<List<DocumentSnapshot>> getSomeNewItems() async {
    Query queryCatalogList = Firestore.instance
        .collection('phonebook')
        .orderBy("name");
    queryCatalogList = _lDoc != null
        ? queryCatalogList.startAfterDocument(_lDoc)
        : queryCatalogList;
    queryCatalogList =
        queryCatalogList.limit(50);
    QuerySnapshot _snapshot = await queryCatalogList.getDocuments();
    if (_snapshot.documents.length > 0) {
      _lDoc = _snapshot.documents[_snapshot.documents.length - 1];
    }

    return _snapshot.documents;
  }

}


class PhonebookBloc {
  final PhonebookRepository repo = PhonebookRepository.instance;

  PhonebookState _state = PhonebookListOpened();
  PhonebookState get state => _state;
  set state(state) {
    this._state = state;
    blocStream.eventOut = state;
  }

  PhonebookState _scrollState = PhonebookListScrolled();
  PhonebookState get scrollState => _scrollState;

  set scrollState(state) {
    this._scrollState = state;
    scrollStream.eventOut = state;
  }

  BlocStream<PhonebookState> blocStream = BlocStream();

  BlocStream<PhonebookState> scrollStream = BlocStream();

  PhonebookBloc() {
    mapEventToState(ScrollPhonebook());
  }

  Future<void> mapEventToState(PhonebookAction event) async {

    if (event is ScrollPhonebook) {
      if (scrollState.busy) return;
      _scrollState = scrollState.copy(true);
    } else {
      state = state.copy(true);
    }

    if (event is OpenPhonebook) {
      state = PhonebookListOpened();
    } else if (event is ScrollPhonebook) {
      await repo.addItemsInList();
      scrollState = PhonebookListScrolled();
    }
  }

  void dispose(){
  }
}
