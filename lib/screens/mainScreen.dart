//import 'package:dicrumantsch/models/getDicGrond.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:url_launcher/url_launcher.dart';

import 'package:dicrumantsch/models/getUDGdata.dart';


class MainScreen extends StatefulWidget {
  @override
  double fontSize;
  String idiom;
  bool showGenus;
  MainScreen(this.idiom, {this.fontSize = 14, this.showGenus = true});
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  bool _pending = false;
  UDGresult udgResult = new UDGresult("vallader");
  //getDicGrondData DicGrondResult = new getDicGrondData("sutsilvan");
  TextEditingController _urlController;

  Future<void> loadResults() async{
    setState(() => this._pending = true);
    await this.udgResult.httpGet(_urlController.text);
    setState(() {this._pending = false;});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._urlController = TextEditingController()..text = '';
  }

  @override
  Widget build(BuildContext context) {

    if(udgResult.idiom != widget.idiom) {
      udgResult.idiom = widget.idiom;
      if (this._urlController.text != ''){
        loadResults();
      }
    }
    //DicGrondResult.idiom = widget.idiom;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  onSubmitted: _pending ? null : (string) async {
                    loadResults();
                  },
                  controller: this._urlController,
                  decoration: InputDecoration(
                      labelText: 'Begriff / Term',
                      focusColor: Color(0xff294f58),
                      border: OutlineInputBorder()
                  ),
                ),
              ),
            ],
          ),
        ),
        udgResult.words.isNotEmpty ? Expanded(
          child: Container(
            child: ListView(
              children: new List.generate(udgResult.words.length, (index) =>
                udgResult.words[index].getWordCard(fontSize: widget.fontSize, showGenus: widget.showGenus)
              ),
            )
          ),
        ):
        _urlController.text == "" ?
        Container() :
        _pending ?
        Center(
          child: SpinKitThreeBounce(
            color:  Color(0xff48b68d),
            size: 50.0,
          ),
        ):
        Container(
          padding: EdgeInsets.only(top: 20),
          child: Row(
            children: <Widget>[
              Expanded(child: Container(),),
              Icon(Icons.close, color: Colors.red),
              Text("Ingiün resultat."),
              Expanded(child: Container(),),
            ],
          ),
        ),
//          _errors == "" ? Container(): Container(child: Text(_errors),)
      ],
    );
  }
}
