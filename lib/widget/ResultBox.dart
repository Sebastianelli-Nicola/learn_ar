import 'package:flutter/material.dart';
import 'package:learn_ar/constants.dart';

class ResultBox extends StatelessWidget {
  const ResultBox({Key? key, required this.result, required this.questionLength, required this.onPressedRestart, required this.onPressedFinish}) : super(key: key);

  final int result;
  final int questionLength;
  final VoidCallback onPressedRestart;
  final VoidCallback onPressedFinish;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: background,
      content: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'Score',
                style: TextStyle(color: neutralW, fontSize: 22.0),
            ),
            const SizedBox(height: 20.0,),
            CircleAvatar(
              radius: 70.0,
              backgroundColor: (result < questionLength * (0.6) && result >= questionLength * (0.5))
                  ? Colors.yellow
                  : result < questionLength * (0.5)
                    ? incorrect
                    : correct,
              child: Text(
                '$result/$questionLength',
                 style: TextStyle(fontSize: 30.0),
              ),
            ),
            const SizedBox(height: 20.0,),
            Text((result < questionLength * (0.6) && result >= questionLength * (0.5))
                ? 'Almost There'
                : result < questionLength * (0.5)
                ? 'Try Again'
                : (result < questionLength * (0.75) && result >= questionLength * (0.6))
                ? 'Good!'
                : result == questionLength * (0.75)
                ? 'Great!'
                : (result > questionLength * (0.75) && result < questionLength)
                ? 'Excellent!'
                : 'Perfect!',
              style: const TextStyle(color: neutralW),
            ),
            const SizedBox(height: 25.0,),
            GestureDetector(
              onTap: onPressedRestart,
              child: const Text(
                  'Start Over',
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                  ),
              ),
            ),
            const SizedBox(height: 25.0,),
            result >= questionLength * (0.6)
                  ? GestureDetector(
                    onTap: onPressedFinish,
                    child: const Text(
                      'Finish',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  )
                :
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                    },
                  child: const Text(
                    'Go Back',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                )

          ],
        )
      ),
    );
  }
}
