import 'package:flutter/material.dart';
import 'package:learn_ar/database/DbFireBaseConnect.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';



class Model3dWidget extends StatelessWidget {

  const Model3dWidget({Key? key, required this.db, required this.model3dName}) : super(key: key);

  final DBconnect db;
  final String model3dName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db.downloadURL(model3dName),
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
          return CircularProgressIndicator();
        }
        return Center(child: Text('No Data'));
      },
    );
  }
}