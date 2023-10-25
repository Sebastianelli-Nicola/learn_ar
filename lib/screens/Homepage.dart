import 'package:flutter/material.dart';
import 'package:learn_ar/auth.dart';
import 'package:learn_ar/widget/IconWidget.dart';

import '../constants.dart';


class Intro extends StatelessWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          foregroundColor: background,
          backgroundColor: background2,
          shadowColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {
                  Auth().signOut();
                },
                icon: const Icon(Icons.logout)
            ),
          ],
        ),
        backgroundColor: background2,
        body: Container(
            padding: EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Welcome in ", style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'circle'
                                ),),
                                Text("Learn AR", style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'circle'
                                ),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                      children: [
                        InkWell(
                          onTap: (){
                            /*Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (context, animation, _) {
                                  return ObjectDetail();
                                },
                                opaque: false));*/
                            Navigator.pushNamed(context, '/ar');
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            width: 360,
                            height: 180,
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
                            child:const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Image.asset('images/jett.png',width: 130,height: 130,),
                                Text('View in AR',style: TextStyle( fontSize: 20,fontWeight: FontWeight.bold),),
                                SizedBox(height:10 ,),
                                IconWidget(value: 'augmented-reality-ar.svg',)
                              ],

                            ),
                          ),
                        ),
                      ],
                    ),
                  InkWell(
                    onTap: (){
                      /*Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (context, animation, _) {
                            return ObjectDetail2();
                          },
                          opaque: false));*/
                      Navigator.pushNamed(context, '/quizhomepage');
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 360,
                      height: 180,
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
                      child:const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Image.asset('images/alien.png',width: 160,height: 130,),
                          Text('Quiz',style: TextStyle( fontSize: 20,fontWeight: FontWeight.bold),),
                          SizedBox(height:10 ,),
                          IconWidget(value: 'question-home.svg',),
                        ],

                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
    );
  }
}