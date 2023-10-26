import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:learn_ar/database/ChapterModel.dart';
import 'package:learn_ar/database/QuestionModel.dart';
import 'package:learn_ar/database/StatisticModel.dart';
import 'dart:convert';

import 'InfoModel.dart';

class DBconnect{

  final url = Uri.parse('https://learn-ar-default-rtdb.europe-west1.firebasedatabase.app/book_architettura_calcolatori/chapters/gpu/questions.json');

  final String urlString = 'https://learn-ar-default-rtdb.europe-west1.firebasedatabase.app/chapters_book_architettura_calcolatori.json';

  final String urlStringQuestions = 'https://learn-ar-default-rtdb.europe-west1.firebasedatabase.app/book_architettura_calcolatori/chapters/';

  final String urlStringInfo = 'https://learn-ar-default-rtdb.europe-west1.firebasedatabase.app/book_architettura_calcolatori/chapters/';

  final String urlStringStatistics = 'https://learn-ar-default-rtdb.europe-west1.firebasedatabase.app/statistics_book_architettura_calcolatori.json';

  final storage = firebase_storage.FirebaseStorage.instance;

  // Storage -->

  Future<firebase_storage.ListResult> listFiles() async{
   firebase_storage.ListResult result = await storage.ref().listAll();
   result.items.forEach((firebase_storage.Reference ref) {print("Found file: $ref");});
   return result;
  }

  //For load model 3D in the quiz
  Future<String> downloadURL(String imageName, String chapter) async{
    String downloadurl = await storage.ref('/quiz_$chapter/$imageName').getDownloadURL();
    return downloadurl;
  }


  // Realtime Database -->

  Future<void> addQuestion(Question question) async{
      http.post(url, body: json.encode({
        'title': question.title,
        'options': question.options,
      }
      ));
  }

  //Question for chapter
  Future<List<Question>> fetchQuestion(String name) async{
    var urlQuestions = Uri.parse(urlStringQuestions + name + '/questions.json' );
    return http.get(urlQuestions).then((response){
      var data = json.decode(response.body) as Map<String, dynamic>;
      List<Question> newQuestions = [];

      data.forEach((key, value){
        var newQuestion = Question(id: key, title: value['title'], options: Map.castFrom(value['options']), model3dName: value['model3dName']);
        newQuestions.add(newQuestion);
      });
      return newQuestions;
    });
  }

  /*Future<List<Question>> fetchQuestion() async{
    return http.get(url).then((response){
      var data = json.decode(response.body) as Map<String, dynamic>;
      List<Question> newQuestions = [];

      data.forEach((key, value){
        var newQuestion = Question(id: key, title: value['title'], options: Map.castFrom(value['options']), model3dName: value['model3dName']);
        newQuestions.add(newQuestion);
      });
      return newQuestions;
    });
  }*/


  //Chapters
  Future<List<Chapter>> fetchChapters() async{
    var urlChapters = Uri.parse(urlString);
    return http.get(urlChapters).then((response){
      var data = json.decode(response.body) as Map<String, dynamic>;
      List<Chapter> newChapters = [];

      data.forEach((key, value){
          var newChapter = Chapter(id: key, name: (value['name']));
          newChapters.add(newChapter);
        });
      //}
      return newChapters;
    });
  }

  //Info Ar Model
  Future<List<Info>> fetchInfo() async{
    var urlInfo = Uri.parse(urlStringInfo + 'gpu' + '/info.json' );
    return http.get(urlInfo).then((response){
      var data = json.decode(response.body) as Map<String, dynamic>;
      List<Info> newInfos = [] ;

      data.forEach((key, value){
        var newInfo= Info(id: key, name: value);
        newInfos.add(newInfo);
      });
      return newInfos;
    });
  }

  //qr code filters
  Future<Map<String, dynamic>> readJson() async {
    final String response = await rootBundle.loadString('assets/chapters.json');
    return json.decode(response) as Map<String, dynamic>;
  }

  //Statistics
  Future<Statistic> fetchStatistic(/*String email*/) async{
    log('stats -> 0');
    var urlStatistics = Uri.parse(urlStringStatistics);
    log('stats -> 1');
    return http.get(urlStatistics).then((response){
      log('stats -> 2');
      var data = json.decode(response.body) as Map<String, dynamic>;
      log('stats -> 3 -> $data');
      List<Statistic> newStatistics = [];

      data.forEach((key, value){
        log('stats -> 4');
        var newStatistic = Statistic(id: key, email: value['email'], stats: Map.castFrom(value['stats']));
        log('stats -> 5 -> $newStatistic');
        newStatistics.add(newStatistic);
        log('stats -> 6 -> $newStatistics');
      });
      log('stats -> 7 -> ${newStatistics[0].stats.keys.toList()[0]}');
      log('stats -> 8 -> ${newStatistics[0].stats.keys.toList()[1]}');
      log('stats -> 8 -> ${newStatistics[0].stats.keys.toList().length}');
      return newStatistics[0];
    });
  }


}