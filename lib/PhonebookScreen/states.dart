
abstract class PhonebookState{
  final bool busy;
  PhonebookState({this.busy = false});

  copy(bool busy);
}

class PhonebookListOpened extends PhonebookState {
  PhonebookListOpened({bool busy = false}) : super(busy: busy);

  @override
  copy(bool busy) {
    return PhonebookListOpened(busy: busy);
  }
}

class PhonebookListScrolled extends PhonebookState {
  PhonebookListScrolled({bool busy = false}) : super(busy: busy);

  @override
  copy(bool busy) {
    return PhonebookListScrolled(busy: busy);
  }
}