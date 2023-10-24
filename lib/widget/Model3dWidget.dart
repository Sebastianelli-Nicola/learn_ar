import 'package:flutter/material.dart';
import 'package:learn_ar/database/DbFireBaseConnect.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';



class Model3dWidget extends StatelessWidget {

  const Model3dWidget({Key? key, required this.db, required this.model3dName, required this.chapter}) : super(key: key);

  final DBconnect db;
  final String model3dName;
  final String chapter;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db.downloadURL(model3dName, chapter),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          return Container(
            width: double.infinity,
            height: 275.0,
            child: ModelViewer(
              src: snapshot.data!,
              alt: "A 3D model",
              //autoRotate: true,
              cameraControls: true,
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting || snapshot.hasData){
          return  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 40.0,
                child: CircularProgressIndicator(),
              ),
            ]
          );
        }
        return Center(child: Text('No Data'));
      },
    );
  }
}