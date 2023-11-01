import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:learn_ar/auth.dart';
import 'package:learn_ar/constants.dart';
import 'package:learn_ar/provider/QuizProvider.dart';
import 'package:learn_ar/widget/BlankWidget.dart';
import 'package:learn_ar/widget/Model3dWidget.dart';
import 'package:learn_ar/widget/NextButton.dart';
import 'package:learn_ar/widget/OptionCard.dart';
import 'package:learn_ar/widget/QuestionWidget.dart';
import 'package:learn_ar/widget/ResultBox.dart';
import 'package:learn_ar/database/DbFireBaseConnect.dart';
import 'package:learn_ar/widget/TrueFalseWidget.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';

import '../../database/QuestionModel.dart';
import '../../database/StatisticModel.dart';

class QuizPage extends StatefulWidget {
  //const QuizPage({super.key});
  final String title;
  final String message;
  final String origin;


  // This Widget accepts the arguments as constructor
  // parameters. It does not extract the arguments from
  // the ModalRoute.
  //
  // The arguments are extracted by the onGenerateRoute
  // function provided to the MaterialApp widget.
  const QuizPage({
    super.key,
    required this.title,
    required this.message,
    required this.origin,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {


  var db = DBconnect();

  late Future _questions;

  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;
  bool isTrue = false;

  //return questions data for a specific chapter
  /*Future<List<Question>> getData(String name) async{
    return db.fetchQuestion(name);
  }*/

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<QuizProvider>(context, listen: false);
    _questions = provider.getDataQuestion(this.widget.message.toString());
    //_questions = getData(this.widget.message.toString());
  }


  @override
  Widget build(BuildContext context) {
    var quizProvider = context.watch<QuizProvider>();
    return FutureBuilder(
      future: _questions as Future<List<Question>>,
      builder: (ctx, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return Center(child: Text('${snapshot.error}'));
          }else if(snapshot.hasData){
            var extractedData = snapshot.data as List<Question>;
            return WillPopScope(
              onWillPop: () async {
                final shouldPop = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Do you want to go back?'),
                      actionsAlignment: MainAxisAlignment.end,
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
                return shouldPop!;
              },
              child: Scaffold(
                        //backgroundColor: Colors.grey.shade300,
                        appBar: AppBar(
                          //title: const Text('Quiz Page'),
                          //backgroundColor: background,
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
                              LinearProgressIndicator(value: index * 1.0 /  extractedData.length,minHeight: 5.0,),
                              const SizedBox(height: 5.0,),
                              QuestionWidget(
                                  question: extractedData[index].title,
                                  indexAction: index,
                                  totalQuestions: extractedData.length
                              ),
                              const Divider(color: neutralB,),
                              const SizedBox(height: 5.0,),
                              SizedBox(
                                //width: double.infinity,
                                height: 275.0,
                                child: check3dModel(extractedData[index].model3dName),
                              ),
                              const SizedBox(height: 5.0,),
                              for(int i=0; i < extractedData[index].options.length; i++)
                                GestureDetector(
                                  onTap: () => checkAnswerAndUpdate(extractedData[index].options.values.toList()[i]),
                                  child: OptionCard(
                                    option: extractedData[index].options.keys.toList()[i],
                                    color: isPressed ? extractedData[index].options.values.toList()[i] == true ? correct : incorrect : Colors.grey.shade100,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        floatingActionButton: GestureDetector(
                          onTap: () => nextQuestion(extractedData.length, quizProvider),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: NextButton(),
                          ),
                        ),
                        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                      ),
            );
          }
        }
        else{
          return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   CircularProgressIndicator(),
                   /*const SizedBox(height: 20.0,),
                   Text(
                     'Please Wait while Question are loading..',
                     style: TextStyle(
                       color: Theme.of(context).primaryColor,
                       decoration: TextDecoration.none,
                       fontSize: 14.0,
                     ),
                   )*/
                 ],
              )
          );
        }
      return Center(child: Text('No Data'));
    },
    );
  }



  //execute when the user press on next question button
  void nextQuestion(int questionLength, QuizProvider provider) {
    if (index == questionLength - 1){
      if(isPressed){
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => ResultBox(
              result: score,
              questionLength: questionLength,
              onPressedRestart: startOver,
              onPressedFinish:  ()=> finish(provider),
            )
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select any option'),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
            )
        );
      }
    }
    else{
      if(isPressed){
        setState(() {
          index++; //when the index will change to 1. rebuild the app
          isPressed = false;
          isAlreadySelected = false;
          isTrue = false;
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

  //verify the response and update the interface
  void checkAnswerAndUpdate(bool value) {
    if(isAlreadySelected){
      return;
    }else{
      if(value == true){
        score++;
        setState(() {
          isTrue = true;
        });
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
    }
  }


  //execute when the user press on start over button
  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
      isTrue = false;
    });
    Navigator.pop(context);
    Navigator.pushNamed(context, '/quizpage');
  }

  /*Future<void> addStats() async {
    var emailWithoutComma = Auth().currentUser!.email.toString().replaceAll('.', '');
    double p = (score * 1.0 / (index + 1)) * 100;
    int perc = p.round();
    await db.addStatistic(Statistic(id: '1', email: emailWithoutComma , stats: {
      widget.message.toString(): perc,},));
  }*/

  //execute when the user press on finish button
  void finish(QuizProvider provider) {
    //addStats();
    provider.addStats(score, index, widget.message.toString());
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
      isTrue = false;
    });
    if(widget.origin.toString() == 'scan'){
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      //Navigator.pop(context);
    }
    else{
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    }
    Navigator.pushNamed(context, '/quizhomepage');

  }

  //check 3d model and set true or false image and view
  check3dModel(String name) {
    if(name != 'none'){
      if(isPressed == false){
        return Model3dWidget(db: db, model3dName: name, chapter: widget.message.toString(),);
      }else{
        if (isTrue == true){
          return const TrueFalseWidget(value: 'True.svg');
        }else{
          return const TrueFalseWidget(value: 'False.svg');
        }
      }
    }else{
      if(isPressed == false){
        return const TrueFalseWidget(value: 'questionmark.svg');
      }
      if (isTrue == true && isPressed == true){
        return const TrueFalseWidget(value: 'True.svg');
      }
      else{
        if(isTrue == false && isPressed == true){
          return const TrueFalseWidget(value: 'False.svg');
        }
      }
      //return const BlankWidget();
    }
  }

  _promptExit(BuildContext context) {

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text('Are you sure?'),
        //content: new Text(Strings.prompt_exit_content),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          SizedBox(height: 16),
          TextButton(
            child: Text('Yes'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ) ??
        false;
  }

}
