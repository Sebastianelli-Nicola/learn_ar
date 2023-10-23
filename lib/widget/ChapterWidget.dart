import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_ar/ScreenArguments.dart';

class ChapterWidget extends StatelessWidget {
  const ChapterWidget({Key? key, required this.chapter, }) : super(key: key);

  final String chapter;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        /*Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, _) {
                          return ObjectDetail2();
                        },
                        opaque: false));*/
        Navigator.pushNamed(context, '/quizpage', arguments: ScreenArguments('name', chapter));
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        width: 360,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
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
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chapter : ${chapter.toUpperCase()}',style: TextStyle( fontSize: 20,fontWeight: FontWeight.bold),),
          ],

        ),
      ),
    );
  }
}
