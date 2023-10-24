import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:learn_ar/database/DbFireBaseConnect.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  late firebase_storage.FirebaseStorage storage;
  late dynamic modelRef;


  final storageRef = firebase_storage.FirebaseStorage.instance.ref();

  late String imageUrl = "";

  late Future _image;

  //
  final store = DBconnect();

  @override
  void initState() {
    storage = firebase_storage.FirebaseStorage.instance;
    modelRef = storage.ref().child("gpuprova4.gltf").getDownloadURL();
    //_image = downloadModel();
    _image = modelRef;
    super.initState();
  }

  Future<String> downloadModel() async{

    return imageUrl =
    await storageRef.child("gpuprova4.gltf").getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: store.downloadURL('gpuprova4.gltf','/quiz_gpu/'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          return Container(
            width: 300,
            height: 300,
            child: ModelViewer(
              src: snapshot.data!,
              alt: "A 3D model of an Earth",
              ar: true,
              autoRotate: true,
              cameraControls: true,
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting || snapshot.hasData){
          return CircularProgressIndicator();
        }
        return Center(child: Text('No Data'));
      },




      /*future: _image,
        builder: (ctx, snapshot){
      if(snapshot.connectionState == ConnectionState.done){
        if(snapshot.hasError){
          return Center(child: Text('${snapshot.error}'));
        }else if(snapshot.hasData){
          var extractedData = snapshot.data;
          return Scaffold(
          appBar: AppBar(title: Text("Model Viewer")),
          body: ModelViewer(
            src: extractedData,
            alt: "A 3D model of an Earth",
            ar: true,
            autoRotate: true,
            cameraControls: true,
          ),
        );
        }
       }
      else{
        return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20.0,),
                Text(
                  'Please Wait while Question are loading..',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                  ),
                )
              ],
            )
        );
      }
      return Center(child: Text('No Data'));
      },*/
    );

  }

}