import 'package:http/http.dart' as http;
import 'package:learn_ar/database/QuestionModel.dart';
import 'dart:convert';

class DBconnect{

  final url = Uri.parse('https://learn-ar-default-rtdb.europe-west1.firebasedatabase.app/questions.json');

  Future<void> addQuestion(Question question) async{
      http.post(url, body: json.encode({
        'title': question.title,
        'options': question.options,
      }
      ));
  }

  Future<void> fetchQuestion() async{
    http.get(url).then((response){
      var data = json.decode(response.body) as Map<String, dynamic>;
      List<Question> newQuestions = [];

      data.forEach((key, value){
        var newQuestion = Question(id: key, title: value['title'], options: Map.castFrom(value['options']));
        newQuestions.add(newQuestion);
      });
      print(newQuestions);
    });
  }

}