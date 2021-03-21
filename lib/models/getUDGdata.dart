import 'package:dicrumantsch/models/word.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'dart:convert';

class UDGresult{

  String searchString;
  List<Word> words = [];
  String errors;
  String idiom;
  bool _pending = false;

  UDGresult(this.idiom);

  Future<bool> httpGet(String searchString) async {
    this.errors = "";
    this.words = [];
    var rows, table, document;

    try {

      final http.Response response_de = await http.get('http://www.udg.ch/dicziunari/' + this.idiom + '/idx_nor_de/q:' + searchString);
      document = parse(Utf8Codec().decode(response_de.bodyBytes));
      table = document.getElementsByClassName('source').first.parent.parent.parent;
      rows = table.getElementsByTagName('tr');


    } catch(e) {print(e);this.errors = e.toString();}

    if (rows != null) {
      for (var i = 1; i < rows.length; i++) {
        try {

          //this.words.add(new Word());
          Word word = Word();
          var row = rows[i];
          var source = row.getElementsByClassName('source');
          var target = row.getElementsByClassName('target');

          word.name_de = source.first.firstChild.firstChild.text;
          var genus = source.first.parent.getElementsByClassName('genus');
          if (genus.length > 0){word.genus_de = genus.first.text.replaceAll(".", "").replaceAll(" ", "");}
          word.url_de = source.first.firstChild.attributes['href'];

          word.name_rm = target.first.firstChild.firstChild.text;
          genus = target.first.parent.getElementsByClassName('genus');
          if (genus.length > 0){word.genus_rm = genus.first.text.replaceAll(".", "").replaceAll(" ", "");}
          word.url_rm = target.first.firstChild.attributes['href'];

          if (word.name_de != null && word.name_rm != null) {
            this.words.add(word);
          }

        } catch(e) {print(e);}
      }
    }

    // Search Rumantsch

    try {

      final http.Response response_rm = await http.get('http://www.udg.ch/dicziunari/vallader/idx_nor_rm/q:'+searchString);
      document = parse(Utf8Codec().decode(response_rm.bodyBytes));
      table = document.getElementsByClassName('source').first.parent.parent.parent;
      rows = table.getElementsByTagName('tr');

    } catch(e) {print(e); rows = [];this.errors = e.toString();}

    if (rows != null) {
      for (var i = 1; i < rows.length; i++) {
        try {
          //this.words.add(new Word());
          Word word = Word();
          var row = rows[i];
          var source = row.getElementsByClassName('source');
          var target = row.getElementsByClassName('target');

          word.name_rm = source.first.firstChild.firstChild.text;
          var genus = source.first.parent.getElementsByClassName('genus');
          if (genus.length > 0){word.genus_rm = genus.first.text.replaceAll(".", "").replaceAll(" ", "");}
          word.url_rm = source.first.firstChild.attributes['href'];

          word.name_de = target.first.firstChild.firstChild.text;
          genus = target.first.parent.getElementsByClassName('genus');
          if (genus.length > 0){word.genus_de = genus.first.text.replaceAll(".", "").replaceAll(" ", "");}
          word.url_de = target.first.firstChild.attributes['href'];

          if (word.name_de != null && word.name_rm != null) {
            this.words.add(word);
          }
        } catch (e) {
          print(e);
        }
      }
    }
    return false;
  }

}