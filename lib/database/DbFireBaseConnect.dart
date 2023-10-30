import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:learn_ar/database/ChapterModel.dart';
import 'package:learn_ar/database/QuestionModel.dart';
import 'package:learn_ar/database/StatisticModel.dart';
import 'dart:convert';

import 'InfoModel.dart';
import 'UserModel.dart';

class DBconnect{

  final myRootRef = FirebaseDatabase(databaseURL: 'https://learn-ar-default-rtdb.europe-west1.firebasedatabase.app').ref();

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
    log('qua-> $imageName e $chapter');
    String downloadurl = await storage.ref('/quiz_$chapter/$imageName').getDownloadURL();
    log('qua-> $downloadurl');
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

  /*Future<void> addStatistic(Statistic statistic) async{
    var urlStatistics = Uri.parse(urlStringStatistics );
    http.post(urlStatistics, body: json.encode({

      "user5": {
            "user3": {
              'email': statistic.email,
              'stats': statistic.stats,
            }
          }
        }
    ));
  }*/


  Future<Statistic> fetchStatistic(String email) async{
    var userNameRef =  myRootRef.child('/statistics_book_architettura_calcolatori');
    var urlStatistics = Uri.parse(urlStringStatistics);
    return http.get(urlStatistics).then((response){
      log('stats -> 2');
      var data = json.decode(response.body) as Map<String, dynamic>;
      log('stats -> 3 -> $data');
      log('stats -> 3 -> ${data.values}');
      log('stats -> 3 -> ${data.keys}');

      List<Statistic> newStatistics = [];

      data.forEach((key, value){
        log('stats -> 4');
        log('stats -> 4'+ value['email']);
        log('stats -> 4'+ value['stats'].toString() );
        if(value['email'] == email){
          if(value['stats'] != null){
            if(Map.castFrom(value['stats']).keys.contains('no data yet') ){
              log('qua ->');
              userNameRef.child('${email}').child('stats').child('no data yet').remove();
            }
            else{
              log('dentro ->');
              log('${Map.castFrom(value['stats']).keys}');
              var newStatistic = Statistic(
                  id: key,
                  email: value['email'],
                  stats: Map.castFrom(value['stats']));
              newStatistics.add(newStatistic);
              log('stats -> 5 -> $newStatistic');

            }
          }
        }
        log('stats -> 6 -> $newStatistics');
      });
      //log('stats -> 7 -> ${newStatistics[0].stats.keys.toList()[0]}');
      //log('stats -> 8 -> ${newStatistics[0].stats.keys.toList()[1]}');
      //log('stats -> 8 -> ${newStatistics[0].stats.keys.toList().length}');
      var defaultStatistic = Statistic(id: '', email: '', stats: <String, int>{'no data yet' : 0});


      return newStatistics.isNotEmpty ? newStatistics[0] : defaultStatistic;
    });
  }


  //add statistic, update statistic
  Future<void> addStatistic(Statistic statistic) async {
    var userNameRef =  myRootRef.child('/statistics_book_architettura_calcolatori');

    var s = await fetchStatistic(statistic.email);
    var isPresent = false;
    Map<String, int> map ={};
    if(s.stats.isNotEmpty){
      s.stats.forEach((key, value) {
        map[key] = value;
        if (statistic.stats.keys == key) {
          map.update(key, (value) => statistic.stats.values.first);
          isPresent = true;
        }
      });
      if(isPresent == true){
        userNameRef.child('${statistic.email}').update({
          'stats': map,
        });
      }
      else{
        map[statistic.stats.keys.first] = statistic.stats.values.first;
        userNameRef.child('${statistic.email}').update({
          'stats': map,
        });
      }
    }

    /*for (int i=0; i<s.stats.keys.length; i++){
      log('dent-> $i');
    }

    userNameRef.child('${statistic.email}').update({
      'stats': statistic.stats,
    });*/
  }



  //add user info
  void addUserAndInfo(User user){
    var userNameRef =  myRootRef.child('/statistics_book_architettura_calcolatori');

    userNameRef.child('${user.email}').set({
      'email': user.email,
      'name' : user.name,
      'surname': user.surname,
      'birthdate' : user.birthDate,
    });
  }


/*Future<void> fetchStatistic2(String email) async{
    var userNameRef =  myRootRef.child('/statistics_book_architettura_calcolatori');
    log('a -> 0');
    final snapshot = await userNameRef.child('$email').get();
    log('a -> ${snapshot.value}');
    if (snapshot.exists) {
      log('a -> 1');
      List<Statistic> newStatistics = [];
      log('a -> 2');
      var values = Map<String, dynamic>.from(snapshot.value as Map);
      var stats = Map.castFrom(values["stats"]);
      var stringQueryParameters = values.map<String, int>(
            (key, value) => MapEntry<String, int>(key, value ),
      );
      log('a -> 2 -> ${stringQueryParameters}');
      //var newStatistic = Statistic(id: email, email: email, stats: stats);
      //var data = snapshot as Map<String, dynamic>;
      log('a -> 3');

      values.forEach((key, value){
        log('a-> 4 $key');
        log('a-> 4 $value');
        var stats = Map.castFrom(value['stats']);
        log('a-> 4 $stats');
        var newStatistic = Statistic(id: key, email: value['email'], stats: Map.castFrom(value['stats']));
        log('a -> 5 -> $newStatistic');
        newStatistics.add(newStatistic);
        log('a -> 6 -> $newStatistics');
      });
      print(snapshot.value);
    } else {
      print('No data available.');
    }
  }*/


}