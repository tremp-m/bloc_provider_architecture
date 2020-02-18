import 'package:bloc_provider_architecture/PhonebookScreen/actions.dart';
import 'package:bloc_provider_architecture/PhonebookScreen/bloc.dart';
import 'package:bloc_provider_architecture/PhonebookScreen/states.dart';
import 'package:bloc_provider_architecture/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PhonebookScreen extends StatelessWidget {
  static const String nameMenuItem = '/phonebook';

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => PhonebookBloc(),
        dispose: (context, value) => value.dispose(),
        child: PhonebookTopPart());
  }
}

class PhonebookTopPart extends StatelessWidget {

  StatefulWidget caseWidget(PhonebookState state) {
    if (state is PhonebookListOpened) {
      return PhonebookList();
    //} else if (data is PhonebookCardToViewOpened) {
    }else ModalProgressHUD(
      inAsyncCall: true,
      child: Text(''),);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<PhonebookBloc>(context, listen: false);
    return StreamProvider<PhonebookState>(
        create: (context) => bloc.blocStream.stream,
        initialData: bloc.state,
        child: Selector<PhonebookState,PhonebookState>(
            selector: (_,state)=>state,
            shouldRebuild: (previous, next){return (previous.runtimeType!=next.runtimeType);},
            builder: (_, state, __) { return ModalProgressHUD(
                inAsyncCall: state.busy,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text("Phones list"),
                  ),
                  drawer: MenuWidget(),
                  body: caseWidget(state),
                ));}
        ));
  }
}

class PhonebookList extends StatefulWidget {
  @override
  _PhonebookListState createState() => _PhonebookListState();
}

class _PhonebookListState extends State<PhonebookList> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<PhonebookBloc>(context, listen: false);
    var list = bloc.repo.data.list;
    return Container(
        child: StreamProvider<PhonebookState>(
            create: (context) => bloc.scrollStream.stream,
            initialData: bloc.scrollState,
            child: Consumer<PhonebookState>(
              builder: (_, state, __) {
                return ListView.builder(
                    controller: _scrollController,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(list[index].data['name']),
                        subtitle: Text(list[index].data['phone']),
                      );
                    });
              },
            )));
  }

  void _scrollListener() {
    double delta = MediaQuery
        .of(context)
        .size
        .height * 3;
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= delta) {
      Provider.of<PhonebookBloc>(context, listen: false)
          .mapEventToState(ScrollPhonebook());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }
}