import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:learn_ar/constants.dart';
import 'package:learn_ar/database/ChapterModel.dart';
import 'package:learn_ar/database/QuestionModel.dart';
import 'package:learn_ar/database/StatisticModel.dart';
import 'package:learn_ar/widget/ChapterWidget.dart';
import 'package:learn_ar/widget/StatisticWidget.dart';

import '../../database/DbFireBaseConnect.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  var db = DBconnect();

  late Future _statistics;



  Future<Statistic> getData()async{
   return db.fetchStatistic();
  }

  @override
  void initState() {
    _statistics = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _statistics,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (snapshot.hasData) {
           var extractedData = snapshot.data as Statistic;
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
                                    Text("Statistics Section", style: TextStyle(
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
                      SizedBox(height: 25,),
                      const Divider(color: neutralB,),
                      const Text('Percentages of correct answers for each chapter', style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold,),
                        textAlign: TextAlign.center,),
                        for(int i=0; i< extractedData.stats.keys.toList().length ; i++)
                          StatisticWidget(stat: extractedData.stats.keys.toList()[i], perc: extractedData.stats.values.toList()[i],),
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
}