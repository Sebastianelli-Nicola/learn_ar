import 'package:flutter/material.dart';


class Intro extends StatelessWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Container(
            padding: EdgeInsets.all(30),
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
                              SizedBox(height: 30,),
                              Text("Welcome", style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'circle'
                              ),),
                              Text("Jackson", style: TextStyle(
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
                            children: [
                              //Image.asset('images/jett.png',width: 130,height: 130,),
                              SizedBox(height:10 ,),
                              Text('AR Model',style: TextStyle( fontSize: 20,fontWeight: FontWeight.bold),),
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
                      children: [
                        //Image.asset('images/alien.png',width: 160,height: 130,),
                        SizedBox(height:10 ,),
                        Text('Quiz',style: TextStyle( fontSize: 20,fontWeight: FontWeight.bold),),
                      ],

                    ),
                  ),
                ),

              ],
            ),
          ),
    );
  }
}