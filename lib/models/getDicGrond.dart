import 'package:dicrumantsch/models/word.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'dart:convert';

class getDicGrondData{

  String searchString;
  List<Word> words = [];
  String errors;
  String idiom;
  bool _pending = false;



  getDicGrondData(this.idiom);

  Future<bool> httpGet(String searchString) async {

    final uri = 'http://www.pledarigrond.ch/rumantschgrischun/de.uni_koeln.spinfo.maalr.user/rpc/lookup';
    var bodyMap = new Map<String, dynamic>();
    bodyMap['searchPhrase'] = 'test';
    String bodyStr = '7|0|9|http://www.pledarigrond.ch/rumantschgrischun/de.uni_koeln.spinfo.maalr.user/|C5ECA3F2CD4B5B478162A26509FA4D8A|de.uni_koeln.spinfo.maalr.services.user.shared.SearchService|search|de.uni_koeln.spinfo.maalr.lucene.query.MaalrQuery/485216971|java.util.TreeMap/1493889780|java.lang.String/2004016611|searchPhrase|test|1|2|3|4|1|5|5|6|0|1|7|8|7|9|';

    var headerMap = new Map<String, String>();
    headerMap['Host'] = 'www.pledarigrond.ch';
    headerMap['Connection'] = 'keep-alive';
    headerMap['Content-Length'] = '17';
    headerMap['X-GWT-Module-Base'] = 'http://www.pledarigrond.ch/rumantschgrischun/de.uni_koeln.spinfo.maalr.user/';
    headerMap['X-GWT-Permutation'] = '8BDE135C0CC21ED129C9793FC74BEBD4';
    headerMap['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36 Edg/87.0.664.57';
//    headerMap['Content-Type'] = 'text/x-gwt-rpc; charset=UTF-8';
    headerMap['Accept'] = '*/*';
    headerMap['Origin'] = 'http://www.pledarigrond.ch';
    headerMap['Referer'] = 'http://www.pledarigrond.ch/rumantschgrischun/';
    headerMap['Accept-Encoding'] = 'gzip, deflate';
    headerMap['Accept-Language'] = 'de,de-DE;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6';
    headerMap['Cookie'] = 'JSESSIONID=w5am8ol1lkbgtb6yjrvya33c';

    this.errors = "";
    this.words = [];
    var rows, table, document;


    try {
//      final http.Response response_de = await http.get(
//          'http://www.pledarigrond.ch/rumantschgrischun/translate.html#searchPhrase=' +
//              searchString);
        final http.Response response_de = await http.post('http://www.pledarigrond.ch/rumantschgrischun/' , body: {'searchPhrase': 'test'});
    document = parse(Utf8Codec().decode(response_de.bodyBytes));
      var response = Utf8Codec().decode(response_de.bodyBytes);
      table = document
          .getElementsByClassName('source')
          .first
          .parent
          .parent
          .parent;
      rows = table.getElementsByTagName('tr');
    } catch (e) {
      print(e);
      this.errors = e.toString();
    }
  }

}