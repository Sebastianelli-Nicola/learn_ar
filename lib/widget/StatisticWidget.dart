import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_ar/ScreenArguments.dart';

class StatisticWidget extends StatelessWidget {
  const StatisticWidget({
    Key? key,
    required this.stat,
    required this.perc, required this.width,
    /*required this.chapter,*/
  }) : super(key: key);

  //final String chapter;
  final String stat;
  final int perc;
  final int width;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: stat != 'no data yet'
            ? Row(
                children: [
                  Container(
                    width: 50,
                      margin: EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      child: Text(stat.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(width: 20,),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    /*width: (MediaQuery.of(context).size.width - 140.0) *
                        (perc == 0 ? 1 : perc) /
                        100,*/
                    width: (width-160)*(perc == 0 ? 2 : perc) / 100,
                    height: 50,
                    decoration: BoxDecoration(
                      color: perc > 66 ? Colors.green : perc < 34 ? Colors.redAccent.shade200 : Colors.orangeAccent,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300]!
                              .withOpacity(1.0), //color of shadow
                          spreadRadius: 1, //spread radius
                          blurRadius: 1, // blur radius
                          offset: Offset(0, 1), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        //you can set more BoxShadow() here
                      ],
                    ),
                    child: Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (perc < 15 ? '' : '$perc %'),
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                alignment: Alignment.center,
                height: 350,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text('No data yet',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ));
  }
}
