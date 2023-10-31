import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:learn_ar/constants.dart';
import 'package:learn_ar/database/ChapterModel.dart';
import 'package:learn_ar/widget/ChapterWidget.dart';
import 'package:provider/provider.dart';

import '../../auth.dart';
import '../../database/DbFireBaseConnect.dart';
import '../../database/StatisticModel.dart';
import '../../provider/QuizProvider.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {


  late Future _chapters;
  late Future<Statistic> _statistics;
  late bool beforeUnlock = true ;

  /*Future<Statistic> getDataStats()async{
    var emailWithoutComma = Auth().currentUser!.email.toString().replaceAll('.', '');
    return db.fetchStatistic(emailWithoutComma);
  }

  Future<List<Chapter>> getData() async{
    return db.fetchChapters();
  }*/

  @override
  void initState() {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    _chapters = provider.getDataChapter();
    _statistics = provider.getDataStats();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_chapters, _statistics]),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else if (snapshot.hasData) {
              var extractedData = snapshot.data?[0] as List<Chapter>;
              var extractedDataStats = snapshot.data?[1] as Statistic;
              return Scaffold(
                backgroundColor: Colors.grey.shade300,
                appBar: AppBar(
                    foregroundColor: background,
                    backgroundColor: background2,
                    shadowColor: Colors.transparent
                ),
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
                                      Text("Welcome in", style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'circle'
                                      ),),
                                      Text("Quiz Section", style: TextStyle(
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
                              onTap: () {
                                Navigator.pushNamed(context, '/scanquiz');
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 20),
                                width: 360,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[300]!.withOpacity(1.0),
                                      //color of shadow
                                      spreadRadius: 1,
                                      //spread radius
                                      blurRadius: 1,
                                      // blur radius
                                      offset: const Offset(
                                          0, 1), // changes position of shadow
                                      //first paramerter of offset is left-right
                                      //second parameter is top to down
                                    ),
                                    //you can set more BoxShadow() here
                                  ],
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Image.asset('images/jett.png',width: 130,height: 130,),
                                    Text('Scan the QR code \n and start the Quiz',
                                      style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold,),
                                      textAlign: TextAlign.center,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25,),
                        const Divider(color: neutralB,),
                        const Text('Questions for each chapter', style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold,),
                          textAlign: TextAlign.center,),
                        for(int i=0; i< extractedData.length; i++)
                        ChapterWidget(chapter: extractedData[i].name, isLock: checkLock(extractedDataStats.stats.containsKey(extractedData[i].name))),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
          else {
            return Container(
              color: background2,
              child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20.0,),
                    ],
                  )
              ),
            );
          }
          return const Center(child: Text('No Data'));
        },

    );
  }

  //check if questions for specific chapter are locked or unlocked
  bool checkLock(bool isLock){
    if(beforeUnlock == true){
      beforeUnlock = isLock;
      return false;
    }
    beforeUnlock = isLock;
    return true;
  }

}