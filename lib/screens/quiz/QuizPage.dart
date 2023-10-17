import 'package:flutter/material.dart';
import 'package:learn_ar/constants.dart';
import 'package:learn_ar/widget/NextButton.dart';
import 'package:learn_ar/widget/OptionCard.dart';
import 'package:learn_ar/widget/QuestionWidget.dart';
import 'package:learn_ar/widget/ResultBox.dart';

import '../../database/QuestionModel.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  List<Question> _questions = [
    Question(id: '10', title: 'Quanto fa 2 + 2 ?',
        options: {'5': false, '4': true, '7': false, '3': false,}),
    Question(id: '11', title: 'Quanto fa 5 + 2 ?',
        options: {'5': false, '4': false, '7': true, '3': false,})
  ];

  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;


  void nextQuestion() {
    if (index == _questions.length - 1){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
            result: score,
            questionLength: _questions.length,
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
            QuestionWidget(
                question: _questions[index].title,
                indexAction: index,
                totalQuestions: _questions.length
            ),
            const Divider(color: neutralB,),
            const SizedBox(height: 25.0,),
            for(int i=0; i < _questions[index].options.length; i++)
              GestureDetector(
                onTap: () => checkAnswerAndUpdate(_questions[index].options.values.toList()[i]),
                child: OptionCard(
                  option: _questions[index].options.keys.toList()[i],
                  color: isPressed ? _questions[index].options.values.toList()[i] == true ? correct : incorrect : neutralW,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(nextQuestion: nextQuestion),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
