import 'package:flutter/material.dart';
import 'package:time_capsule_app/blocs/bloc_provider.dart';
import 'package:time_capsule_app/blocs/daily_memories_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Capsule App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<DayEntryBloc>(
        bloc: DayEntryBloc(),
        child: MyHomePage(title: '20/01/2019'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textFieldController1 = TextEditingController();
  final textFieldController2 = TextEditingController();
  final textFieldController3 = TextEditingController();

  @override
  void dispose() {
    textFieldController1.dispose();
    textFieldController2.dispose();
    textFieldController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DayEntryBloc bloc = BlocProvider.of<DayEntryBloc>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          SafeArea(
            child: StreamBuilder(
                stream: bloc.outDayEntry,
                initialData: DayEntry('20/01/2019', 'Message 1', 'Message 2', 'Message 3'),
                builder: (BuildContext buildContext,
                    AsyncSnapshot<DayEntry> snapshot) {
                  return Text(snapshot.data.theDate);
                }),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        bloc.inDateChange.add(DateChangeDecrement());
                      },
                    ),
                    StreamBuilder(
                        stream: bloc.outDayEntry,
                        initialData:
                            DayEntry('20/01/2019', 'Message 1', 'Message 2', 'Message 3'),
                        builder: (BuildContext buildContext,
                            AsyncSnapshot<DayEntry> snapshot) {
                          if (snapshot.hasData) {
                            textFieldController1.text = snapshot.data.entry1;
                            textFieldController2.text = snapshot.data.entry2;
                            textFieldController3.text = snapshot.data.entry3;
                            return Expanded(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                          helperText: "Memory 1"),
                                      style: Theme.of(context).textTheme.body1,
                                      controller: textFieldController1,
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                          helperText: "Memory 2"),
                                      style: Theme.of(context).textTheme.body1,
                                      controller: textFieldController2,
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                          helperText: "Memory 3"),
                                      style: Theme.of(context).textTheme.body1,
                                      controller: textFieldController3,
                                    ),
                                    flex: 1,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        bloc.inDateChange.add(DateChangeIncrement());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.inAddDayEntry.add(textFieldController1.text +
              ' ' +
              textFieldController2.text +
              ' ' +
              textFieldController3.text);
        },
        tooltip: 'Save Memories',
        child: Icon(Icons.save_alt),
      ),
    );
  }
}
