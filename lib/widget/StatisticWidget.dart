
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_ar/ScreenArguments.dart';

class StatisticWidget extends StatelessWidget {
  const StatisticWidget({Key? key, required this.stat, required this.perc, /*required this.chapter,*/ }) : super(key: key);

  //final String chapter;
  final String stat;
  final int perc;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: stat != 'no data yet' ?
      Container(
        margin: EdgeInsets.only(top: 20),
        width: (MediaQuery.of(context).size.width - 40.0) * (perc == 0 ? 1 : perc) / 100,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.green,
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
            Text((perc == 0 ? '' : '${stat.toUpperCase()}') + (perc == 0 ? '' : ': $perc %'),style: TextStyle( fontSize: 12,fontWeight: FontWeight.bold),),
          ],

        ),
      )
      :
        Container(
          alignment: Alignment.center,
          height: 350,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text('No data yet', style: TextStyle( fontSize: 15,fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        )
    );
  }
}