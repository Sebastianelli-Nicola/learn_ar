import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:learn_ar/database/models/Chapter.dart';
import 'package:learn_ar/database/models/Question.dart';
import 'package:learn_ar/database/models/Statistic.dart';
import 'dart:convert';

import 'models/Info.dart';
import 'models/UserModel.dart';

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

  //For load model 3D in the quiz. return url
  Future<String> downloadURL(String imageName, String chapter) async{
    String downloadurl = await storage.ref('/quiz_$chapter/$imageName').getDownloadURL();
    return downloadurl;
  }


  // Realtime Database -->

  // add question on realtime database
  Future<void> addQuestion(Question question) async{
      http.post(url, body: json.encode({
        'title': question.title,
        'options': question.options,
      }
      ));
  }

  //return question for chapter name
  Future<List<Question>> fetchQuestion(String name) async{
    var urlQuestions = Uri.parse(urlStringQuestions + name + '/questions.json' );
    return http.get(urlQuestions).then((response){
      var data = json.decode(response.body) as Map<String, dynamic>;
      List<Question> newQuestions = [];

      data.forEach((key, value){
        var newQuestion = Question(id: key, title: value['title'],
            options: Map.castFrom(value['options']), model3dName: value['model3dName']);
        newQuestions.add(newQuestion);
      });
      return newQuestions;
    });
  }


  //return list of Chapters
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

  //return Info associate at the Ar Model
  Future<List<Info>> fetchInfo(String chapter) async{
    var urlInfo = Uri.parse(urlStringInfo + '$chapter' + '/info.json' );
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

  //return a qr code filters map
  Future<Map<String, dynamic>> readJson() async {
    final String response = await rootBundle.loadString('assets/chapters.json');
    return json.decode(response) as Map<String, dynamic>;
  }



  //return statistic for a email
  Future<Statistic> fetchStatistic(String email) async{
    var userNameRef =  myRootRef.child('/statistics_book_architettura_calcolatori');
    var urlStatistics = Uri.parse(urlStringStatistics);
    return http.get(urlStatistics).then((response){
      var data = json.decode(response.body) as Map<String, dynamic>;

      List<Statistic> newStatistics = [];

      data.forEach((key, value){
        if(value['email'] == email){
          if(value['stats'] != null){
            if(Map.castFrom(value['stats']).keys.contains('no data yet') ){
              userNameRef.child('${email.replaceAll('.', '')}').child('stats').child('no data yet').remove();
            }
            else{
              var newStatistic = Statistic(
                  id: key,
                  email: value['email'],
                  stats: Map.castFrom(value['stats']));
              newStatistics.add(newStatistic);

            }
          }
        }
      });
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
        userNameRef.child('${statistic.email.replaceAll('.', '')}').update({
          'stats': map,
        });
      }
      else{
        map[statistic.stats.keys.first] = statistic.stats.values.first;
        userNameRef.child('${statistic.email.replaceAll('.', '')}').update({
          'stats': map,
        });
      }
    }
  }



  //add user info on realtime database
  void addUserAndInfo(UserModel user){
    var userNameRef =  myRootRef.child('/statistics_book_architettura_calcolatori');

    userNameRef.child('${user.email.replaceAll('.', '')}').set({
      'email': user.email,
      'name' : user.name,
      'surname': user.surname,
      'birthdate' : user.birthDate,
    });
  }

  //return info for a specific user
  fetchUserInfo(String email){
    var urlStatistics = Uri.parse(urlStringStatistics);
    return http.get(urlStatistics).then((response){
      var data = json.decode(response.body) as Map<String, dynamic>;
      UserModel user = UserModel(id: 'id', email: '', name: '', surname: '', birthDate: '');

      data.forEach((key, value){
        if(value['email'] == email){
          var newUser = UserModel(
              id: key,
              email: value['email'],
              name: value['name'],
              surname: value['surname'],
              birthDate: value['birthdate']
          );
          user = newUser;
        }
      });
      return user;
    });
  }

}
