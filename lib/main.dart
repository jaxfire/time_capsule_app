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
  @override
  Widget build(BuildContext context) {
    final DayEntryBloc bloc = BlocProvider.of<DayEntryBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () { bloc.inDateChange.add(DateChangeDecrement()); },
              ),
              StreamBuilder(
                  stream: bloc.outDayEntry,
                  initialData: "Intitial data",
                  builder: (BuildContext buildContext,
                      AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Enter Memory 1 ' + snapshot.data,
                          ),
                          Text(
                            'Enter Memory 2 ' + snapshot.data,
                          ),
                          Text(
                            'Enter Memory 3 ' + snapshot.data,
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () { bloc.inDateChange.add(DateChangeIncrement()); },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.inAddDayEntry.add('TEST INPUT DATA');
        },
        tooltip: 'Save Memories',
        child: Icon(Icons.save_alt),
      ),
    );
  }
}
