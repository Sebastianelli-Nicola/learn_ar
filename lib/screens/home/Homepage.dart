import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_ar/auth.dart';
import 'package:learn_ar/widget/HomepageButton.dart';
import 'package:learn_ar/widget/IconWidget.dart';

import '../../constants.dart';


class Intro extends StatelessWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          foregroundColor: background,
          backgroundColor: CupertinoColors.white,
          shadowColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {
                  Auth().signOut();
                },
                icon: const Icon(Icons.logout)
            ),

          ],
          leading: Row(
            children: [
              SizedBox(width: 10,),
              Container(
                  //margin: EdgeInsets.fromLTRB(0, 8, 10, 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.orange,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(new Radius.circular(50.0)),
                  ),
                  //margin: EdgeInsets.fromLTRB(0, 8, 10, 8),
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: CircleAvatar(
                      child: Text(getEmailFirstLetter() ,style: TextStyle(fontSize: 15.0),),
                      //backgroundImage: ExactAssetImage('assets/Bronze.jpg'),
                    ),
                  )),
            ],
          ),
        ),
        backgroundColor: CupertinoColors.white,
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
                        const HomePageButton(option: 'View in AR'),
                        const HomePageButton(option: 'Quiz'),
                        const HomePageButton(option: 'Statistics'),

                      ],
                    ),

                ],
              ),
            ),
          ),
    );
  }

  getEmailFirstLetter(){
    var email = Auth().currentUser?.email;
    var logo = email?[0] != null ? email![0] : '?';
    return logo.toUpperCase();
  }
}