import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class Word {
  String name_de;
  String name_rm;
  String url_de;
  String url_rm;

  Word();
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Dicziunari Rumantsch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  TextEditingController _urlController;
  bool _pending = false;
  List<Word> words = [];
  String _search_name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._urlController = TextEditingController()..text = 'test';
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: this._urlController,
                decoration: InputDecoration(
                  labelText: 'Begriff / Nom',
                  border: OutlineInputBorder()
                ),
            ),
          ),
          RaisedButton(
            child: Text('Go'),
            onPressed: _pending ? null : () =>  this._httpGet(_urlController.text),
          ),

          words.isNotEmpty ? Expanded(
            child: Container(
              child: ListView(
                children: new List.generate(words.length, (index) => new ListTile(
                  title: Text(words[index].name_de + " - " + words[index].name_rm),
                )),
              ),
            ),
          ): SizedBox(height: 1,),
        ],
      ),
//      body: Center(
//        // Center is a layout widget. It takes a single child and positions it
//        // in the middle of the parent.
//        child: Column(
//          // Column is also a layout widget. It takes a list of children and
//          // arranges them vertically. By default, it sizes itself to fit its
//          // children horizontally, and tries to be as tall as its parent.
//          //
//          // Invoke "debug painting" (press "p" in the console, choose the
//          // "Toggle Debug Paint" action from the Flutter Inspector in Android
//          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//          // to see the wireframe for each widget.
//          //
//          // Column has various properties to control how it sizes itself and
//          // how it positions its children. Here we use mainAxisAlignment to
//          // center the children vertically; the main axis here is the vertical
//          // axis because Columns are vertical (the cross axis would be
//          // horizontal).
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.headline4,
//            ),
//          ],
//        ),
//      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<Null> _httpGet(String searchString) async {
    setState(() => this._pending = true);

    this.words = [];
    var rows, table, document;

    try {

      final http.Response response_de = await http.get('http://www.udg.ch/dicziunari/vallader/idx_nor_de/q:' + searchString);
      document = parse(response_de.body);
      table = document.getElementsByClassName('source').first.parent.parent.parent;
      rows = table.getElementsByTagName('tr');

    } catch(e) {print(e);}

    for (var i = 2; i < rows.length; i++) {
      try {

        //this.words.add(new Word());
        Word word = Word();
        var row = rows[i];

        word.name_de = row.getElementsByClassName('source').first.firstChild.firstChild.text;
        word.url_de = row.getElementsByClassName('source').first.firstChild.attributes['href'];

        word.name_rm = row.getElementsByClassName('target').first.firstChild.firstChild.text;
        word.url_rm = row.getElementsByClassName('target').first.firstChild.attributes['href'];

       if (word.name_de != null && word.name_rm != null) {
          this.words.add(word);
        }

      } catch(e) {print(e);}
    }

      // Search Rumantsch

    try {

      final http.Response response_de = await http.get('http://www.udg.ch/dicziunari/vallader/idx_nor_rm/q:'+searchString);
      document = parse(response_de.body);
      table = document.getElementsByClassName('source').first.parent.parent.parent;
      rows = table.getElementsByTagName('tr');

    } catch(e) {print(e);}

    for (var i = 2; i < rows.length; i++) {
      try {

        //this.words.add(new Word());
        Word word = Word();
        var row = rows[i];

        word.name_rm = row.getElementsByClassName('source').first.firstChild.firstChild.text;
        word.url_rm = row.getElementsByClassName('source').first.firstChild.attributes['href'];

        word.name_de = row.getElementsByClassName('target').first.firstChild.firstChild.text;
        word.url_de = row.getElementsByClassName('target').first.firstChild.attributes['href'];

        if (word.name_de != null && word.name_rm != null) {
          this.words.add(word);
        }

      } catch(e) {print(e);}
    }

    setState(() => this._pending = false);
  }
}
