import 'package:flutter/material.dart';
import 'package:learn_ar/constants.dart';
import 'package:learn_ar/widget/Model3dWidget.dart';
import 'package:learn_ar/widget/NextButton.dart';
import 'package:learn_ar/widget/OptionCard.dart';
import 'package:learn_ar/widget/QuestionWidget.dart';
import 'package:learn_ar/widget/ResultBox.dart';
import 'package:learn_ar/database/DbFireBaseConnect.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../database/QuestionModel.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  var db = DBconnect();

  late Future _questions;

  Future<List<Question>> getData() async{
    return db.fetchQuestion();
  }

  @override
  void initState() {
    _questions = getData();
    super.initState();
  }

  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;


  void nextQuestion(int questionLength) {
    if (index == questionLength - 1){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
            result: score,
            questionLength: questionLength,
            onPressed: startOver,
          )
      );
    }
    else{
      if(isPressed){
        setState(() {
          index++; //when the index will change to 1. rebuild the app
          isPressed = false;
          isAlreadySelected = false;
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select any option'),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
          )
        );
      }

    }
  }

  void checkAnswerAndUpdate(bool value) {
    if(isAlreadySelected){
      return;
    }else{
      if(value == true){
        score++;
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
    }
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _questions as Future<List<Question>>,
      builder: (ctx, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return Center(child: Text('${snapshot.error}'));
          }else if(snapshot.hasData){
            var extractedData = snapshot.data as List<Question>;
            return Scaffold(
                      backgroundColor: Colors.grey.shade300,
                      appBar: AppBar(
                        title: const Text('Quiz Page'),
                        backgroundColor: background,
                        shadowColor: Colors.transparent,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text('Score: $score', style: TextStyle(fontSize: 18.0),),
                          )
                        ],
                      ),
                      body: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 5.0,),
                            QuestionWidget(
                                question: extractedData[index].title,
                                indexAction: index,
                                totalQuestions: extractedData.length
                            ),
                            const Divider(color: neutralB,),
                            const SizedBox(height: 5.0,),
                            Model3dWidget(db: db, model3dName: extractedData[index].model3dName),
                            /*FutureBuilder(
                              future: db.downloadURL('gpu1.glb'),
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                                if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                  return Container(
                                    width: double.infinity,
                                    height: 275.0,
                                    child: ModelViewer(
                                      src: snapshot.data!,
                                      alt: "A 3D model of an Earth",
                                      //autoRotate: true,
                                      cameraControls: true,
                                    ),
                                  );
                                }
                                if(snapshot.connectionState == ConnectionState.waiting || snapshot.hasData){
                                  return CircularProgressIndicator();
                                }
                                return Center(child: Text('No Data'));
                              },
                            ),*/
                            const SizedBox(height: 5.0,),
                            for(int i=0; i < extractedData[index].options.length; i++)
                              GestureDetector(
                                onTap: () => checkAnswerAndUpdate(extractedData[index].options.values.toList()[i]),
                                child: OptionCard(
                                  option: extractedData[index].options.keys.toList()[i],
                                  color: isPressed ? extractedData[index].options.values.toList()[i] == true ? correct : incorrect : neutralW,
                                ),
                              ),

                          ],

                        ),
                      ),
                      floatingActionButton: GestureDetector(
                        onTap: () => nextQuestion(extractedData.length),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: NextButton(),
                        ),
                      ),
                      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                    );
          }

        }
        else{
          return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   const CircularProgressIndicator(),
                   const SizedBox(height: 20.0,),
                   Text(
                     'Please Wait while Question are loading..',
                     style: TextStyle(
                       color: Theme.of(context).primaryColor,
                       decoration: TextDecoration.none,
                       fontSize: 14.0,
                     ),
                   )
                 ],
              )
          );
        }
      return Center(child: Text('No Data'));

    },

    );
  }
}
