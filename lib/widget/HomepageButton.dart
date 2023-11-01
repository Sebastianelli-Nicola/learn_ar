import 'package:flutter/material.dart';
import 'package:learn_ar/constants.dart';

import 'IconWidget.dart';

class HomePageButton extends StatelessWidget {
  const HomePageButton({Key? key, required this.option,}) : super(key: key);
  final String option;
  //final Color color;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        option == 'Statistics' ? Navigator.pushNamed(context, '/statistics')  : option == 'Quiz' ? Navigator.pushNamed(context, '/quizhomepage') : Navigator.pushNamed(context, '/ar');
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 20),
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: option == 'Statistics' ? Colors.greenAccent.shade100  : option == 'Quiz' ? Colors.orange.shade100 : Colors.cyan.shade200,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow:[
            BoxShadow(
              color: Colors.grey[300]!.withOpacity(1.0), //color of shadow
              spreadRadius: 1, //spread radius
              blurRadius: 1, // blur radius
              offset: Offset(0, 1), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconWidget(value: option == 'Statistics' ? 'statistics.svg' : option == 'Quiz' ? 'question-home.svg' : 'augmented-reality-ar.svg' ,),
            SizedBox(height:10 ,),
            Text(option,style: TextStyle( fontSize: 20,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}

