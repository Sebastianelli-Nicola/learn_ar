import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../database/DbFireBaseConnect.dart';
import '../../database/InfoModel.dart';
import '../../provider/ArProvider.dart';

class InfoAr extends StatefulWidget {
  //const InfoAr({super.key});

  final String title;
  final String message;
  final String origin;


  const InfoAr({
    super.key,
    required this.title,
    required this.message,
    required this.origin,
  });


  @override
  State<InfoAr> createState() => _InfoArState();
}

class _InfoArState extends State<InfoAr> {
  //var db = DBconnect();

  late Future _info;

  /*Future<List<Info>> getData() async{
    return db.fetchInfo();
  }*/

  @override
  void initState() {
    final provider = Provider.of<ArProvider>(context, listen: false);
    _info = provider.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  /*Scaffold(
      appBar: AppBar(
        backgroundColor: background,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('Info gpu'),
            )
          ],
        ),
      ),
    );*/

      FutureBuilder(
        future: _info,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else if (snapshot.hasData) {
              var extractedData = snapshot.data as List<Info>;
              return Scaffold(
                appBar: AppBar(
                  //foregroundColor: background,
                  //backgroundColor: background2,
                  shadowColor: Colors.transparent,
                ),
                body: Container(
                  padding: EdgeInsets.all(20),
                  color: CupertinoColors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(widget.message.toString().toUpperCase() ,style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(height: 20.0,),
                      Center(
                        child: Text(extractedData[0].name, style: TextStyle(fontSize: 17.0),),
                      )
                    ],
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
                      /*Text(
                        'Please Wait while Question are loading..',
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          decoration: TextDecoration.none,
                          fontSize: 14.0,
                        ),
                      )*/
                    ],
                  )
              ),
            );
          }
          return Center(child: Text('No Data'));
        },
      );
  }
}
