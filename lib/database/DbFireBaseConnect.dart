import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;
import 'package:learn_ar/database/QuestionModel.dart';
import 'dart:convert';

class DBconnect{

  final url = Uri.parse('https://learn-ar-default-rtdb.europe-west1.firebasedatabase.app/questions.json');

  //final gsReference = FirebaseStorage.instance.refFromURL("gs://learn-ar.appspot.com/gpuprova4.gltf");

  final storage = firebase_storage.FirebaseStorage.instance;

  // Storage ->

  Future<firebase_storage.ListResult> listFiles() async{
   firebase_storage.ListResult result = await storage.ref().listAll();
   result.items.forEach((firebase_storage.Reference ref) {print("Found file: $ref");});
   return result;
  }

  Future<String> downloadURL(String imageName) async{
    String downloadurl = await storage.ref(imageName).getDownloadURL();
    return downloadurl;
  }


  // Realtime Database ->

  Future<void> addQuestion(Question question) async{
      http.post(url, body: json.encode({
        'title': question.title,
        'options': question.options,
      }
      ));
  }

  Future<List<Question>> fetchQuestion() async{
    return http.get(url).then((response){
      var data = json.decode(response.body) as Map<String, dynamic>;
      List<Question> newQuestions = [];

      data.forEach((key, value){
        var newQuestion = Question(id: key, title: value['title'], options: Map.castFrom(value['options']), model3dName: value['model3dName']);
        newQuestions.add(newQuestion);
      });
      return newQuestions;
    });
  }

}