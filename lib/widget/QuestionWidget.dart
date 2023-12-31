import 'package:flutter/material.dart';
import 'package:learn_ar/constants.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({Key? key, required this.question, required this.indexAction,
                        required this.totalQuestions}) : super(key: key);

  final String question;
  final int indexAction;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
              '${indexAction+1}/$totalQuestions: $question',
              style: const TextStyle(
                    fontSize: 20.0,
                    color: neutralB,
                  ),
              ),
    );
  }
}
