import 'package:flutter/material.dart';

class Word {
  String name_de;
  String name_rm;
  String url_de;
  String url_rm;
  String genus_de;
  String genus_rm;

  Word();

  Widget _column(String title, String genus, double fontSize, bool showGenus){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child :Row(
          children: <Widget>[
            Expanded(child: Text(title, style: TextStyle(fontSize: fontSize)),),
            showGenus ? (genus == "m,f" ? this.get_colorMF(fontSize) : this.get_colorString(genus, fontSize)): Container(),
          ],
        ),
      ),
    );
  }

  Card getWordCard({double fontSize = 14, bool showGenus}){
    return Card(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  _column(this.name_de, this.genus_de, fontSize, showGenus),
                  VerticalDivider(color: Colors.black45, thickness:1, indent: 3, endIndent: 3,width: 1,),
                  _column(this.name_rm, this.genus_rm, fontSize, showGenus),
                ],
              ),
            ),
          ),
    );}

  Text get_colorString(String genus, double fontSize) {
    if (genus == ""){return Text(genus, style: TextStyle(color: Colors.transparent),);}
    if (genus == "m" || genus == "m,mpl" || genus == "mpl"){
      return Text(genus , style: TextStyle(color: Colors.lightBlue, fontSize: fontSize-4));
    }
    if (genus == "f" || genus == "f,fpl" || genus == "fpl"){
      return Text(genus, style: TextStyle(color: Colors.pinkAccent, fontSize: fontSize-4));
    }
    if (genus == "n" || genus == "n,npl" || genus == "npl"){
      return Text(genus, style: TextStyle(color: Colors.green, fontSize: fontSize-4));
    }
    if (genus == "m,f" || genus == "f,m"){
      return Text("", style: TextStyle(color: Colors.transparent),);
    }
    return Text("", style: TextStyle(color: Colors.transparent),);
  }

  Row get_colorMF(double fontSize){
    return Row(children: <Widget>[
      Text("m", style: TextStyle(color: Colors.lightBlue, fontSize: fontSize-4)),
      Text("/", style: TextStyle(fontSize: fontSize-4)),
      Text("f", style: TextStyle(color: Colors.pinkAccent, fontSize: fontSize-4)),
    ],);
  }

  BoxDecoration get_boxDecoration(String genus) {
    if (genus == ""){return BoxDecoration(color: Colors.transparent);}
    if (genus == "m" || genus == "m,mpl" || genus == "mpl"){
      return BoxDecoration(
        color: Colors.lightBlue.withOpacity(0.5),
        borderRadius: new BorderRadius.all(Radius.circular(7)),);
    }
    if (genus == "f" || genus == "f,fpl" || genus == "fpl"){
      return BoxDecoration(
        color: Colors.pinkAccent.withOpacity(0.5),
        borderRadius: new BorderRadius.all(Radius.circular(7)),);
    }
    if (genus == "n" || genus == "n,npl" || genus == "npl"){
      return BoxDecoration(
        color: Colors.green.withOpacity(0.5),
        borderRadius: new BorderRadius.all(Radius.circular(7)),);
    }
    if (genus == "m,f" || genus == "f,m"){
      return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [ Colors.pinkAccent.withOpacity(0.5), Colors.lightBlue.withOpacity(0.5)]),
        borderRadius: new BorderRadius.all(Radius.circular(7)),);
    }
    return BoxDecoration(color: Colors.transparent);
  }
}