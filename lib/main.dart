


import 'package:dicrumantsch/screens/mainScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

String softwareVersion = "DV v1.0.0";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//
//        primarySwatch: Colors.blue,
//        visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
      home: MyHomePage(title: 'Dicziunari Viagiond'),
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


  bool isFirstCall = true;
  double _fontSize = 14;
  bool _showGenus = true;
  //static const idioms = <String>["Rumantsch Grischun", "Vallader", "Puter", "Sursilvan", "Surmiran", "Sutsilvan"];
  static const idioms = <String>["Vallader", "Puter"];
  final List<DropdownMenuItem<String>> _idiomItems = idioms.map(
      (String value) => DropdownMenuItem<String>(value: value, child: Text(value))
  ).toList();
  String _idiomSelection = idioms[0];

  void initPreferences() async{
    final prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble("fontSize") ?? 14;
    _showGenus = prefs.getBool("showGenus") ?? true;
    _idiomSelection = prefs.getString("idiom") ?? idioms[0];
    setState((){});
  }

  void setPreferences() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble("fontSize", _fontSize);
    prefs.setBool("showGenus", _showGenus);
    prefs.setString("idiom", _idiomSelection);
  }

  @override
  Widget build(BuildContext context) {
    if(isFirstCall) {initPreferences(); isFirstCall = false;}
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style: TextStyle(color: Color(0xff294f58) ),),
        backgroundColor: Color(0xff48b68d),
      ),
      body: MainScreen(_idiomSelection, fontSize: this._fontSize, showGenus: _showGenus,),
      drawer: Drawer(
          child:ListView(
            children: <Widget>[
              DrawerHeader(
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Color(0xff48b68d),
                ),
                child:  Image(image: AssetImage("assets/profile.png"),),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                        Text("Aa", style: TextStyle(fontSize: 14),),
                        Expanded(
                          child: Slider(
                            value: _fontSize,
                            max: 20,
                            min: 14,
                            divisions: 4,
                            onChanged: (double value){
                              setState(() => _fontSize = value);
                              setPreferences();
                              },
                          ),
                        ),
                        Text("Aa", style: TextStyle(fontSize: 20),),
                    ],),
                    Divider(),
                    Row(children: <Widget>[
                      Text("Genus", style: TextStyle(fontSize: 16),),
                      Expanded(child: Container(),),
                      Switch(onChanged: (bool value){
                        setState(() => _showGenus = value);
                        setPreferences();
                      },
                      value: _showGenus,),


                      ]
                    ),

                    Divider(),
                    Row(children: <Widget>[
                      Text("Idiom", style: TextStyle(fontSize: 16),),
                      Expanded(child: Container(),),
                      DropdownButton<String>(
                        value: _idiomSelection,
                        onChanged: (String value){
                          setState(() =>_idiomSelection = value);
                          setPreferences();
                          },
                        items: _idiomItems,
                      )
                    ],),
                    Divider(),
                    InkWell(
                        child: new Text(softwareVersion, style: TextStyle(fontSize: 14, color: Colors.blue),),
                        onTap: () => launch('https://google.com')
                    ),

                  ],
                ),
              ),
            ],
          ),
      ) ,
    );
  }

}
