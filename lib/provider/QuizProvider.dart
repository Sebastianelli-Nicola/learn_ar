import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../auth.dart';
import '../database/ChapterModel.dart';
import '../database/DbFireBaseConnect.dart';
import '../database/QuestionModel.dart';
import '../database/StatisticModel.dart';

class QuizProvider extends ChangeNotifier{
  var db = DBconnect();

  late Map<String, dynamic> _data = <String, dynamic>{};
  Map<String, dynamic> get item => _data;



  //return a list of questions data for a specific chapter
  Future<List<Question>> getDataQuestion(String name) async{
    return db.fetchQuestion(name);
  }

  //return statistic data
  Future<Statistic> getDataStats()async{
    var emailWithoutComma = Auth().currentUser!.email.toString()/*.replaceAll('.', '')*/;
    return db.fetchStatistic(emailWithoutComma);
  }

  //return a list of chapters data
  Future<List<Chapter>> getDataChapter() async{
    return db.fetchChapters();
  }

  //added chapter statistic for auth user
  Future<void> addStats(int score, int index, String chapter) async {
    var emailWithoutComma = Auth().currentUser!.email.toString()/*.replaceAll('.', '')*/;
    log('email -> ${Auth().currentUser!.email.toString()}');
    log('emailWithoutComma -> $emailWithoutComma');
    double p = (score * 1.0 / (index + 1)) * 100;
    int perc = p.round();
    await db.addStatistic(Statistic(id: '1', email: emailWithoutComma , stats: {
      chapter: perc,},));
    notifyListeners();
  }

  //read json contains a list of chapters
  Future<void> readJson() async {
    //final String response = await rootBundle.loadString('assets/chapters.json');
    //_data = json.decode(response) as Map<String, dynamic>;
     _data = await db.readJson() as Map<String, dynamic>;
  }

  /*Future<void> updateJson(String chapter) async {
   // Directory appDocDir = await getApplicationDocumentsDirectory();
    File jsonFile = File("${appDocDir.path}/chapters.json");
    final String response = await rootBundle.loadString('assets/chapters.json');
    _data = json.decode(response) as Map<String, dynamic>;
    List<Chapter> newChapters = [];

    log('datajsoncahpter -> $chapter');
    log('datajson -> $_data');
    _data.forEach((key, value) {
      if (value['name'] == chapter){
        log('qui -> $_data');
        value['isLock'] = false;
        log('qui2 -> $_data');
        _data = json.encode(value['isLock'] = false) as Map<String, dynamic>;
      }
    });


    /*(_data["chapter1"] as List<dynamic>).forEach((item) => item["isLock"] = true);
    log('datajson -> $_data');*/
  }*/

  /*Future setBookmark(int questionId, String isBookmark) async {
    // update the list
    _listQuestions
        .firstWhere((question) => question.id == questionId)
        .bookmark = isBookmark;
    // and write it
    jsonFile.writeAsStringSync(json.encode(_listQuestions));
  }*/
}