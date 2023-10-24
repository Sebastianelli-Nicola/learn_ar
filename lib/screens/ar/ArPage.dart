import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class ArPage extends StatefulWidget {
  const ArPage({Key? key}) : super(key: key);

  @override
  _ArPageState createState() => _ArPageState();
}

class _ArPageState extends State<ArPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late UnityWidgetController _unityWidgetController;

  bool visibilityInfo = false;
  late String info;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        /*appBar: AppBar(
          title: const Text('View in Ar'),
        ),*/
        body: Card(
          margin: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: <Widget>[
              UnityWidget(
                onUnityCreated: onUnityCreated,
                onUnityMessage: onUnityMessage,
                onUnitySceneLoaded: onUnitySceneLoaded,
                fullscreen: false,
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Opacity(
                  opacity: visibilityInfo == true ? 1.0 : 0.0,
                  child: Card(
                    elevation: 10,
                    child: Column(
                      children: <Widget>[
                        Container(
                          //margin: EdgeInsets.all(10),
                          // ignore: deprecated_member_use
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/infoar');
                            },
                            /*shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: EdgeInsets.all(0.0),*/
                            child: Ink(
                              decoration: BoxDecoration(
                                  /*gradient: const LinearGradient(
                                    colors: [Color(0xff9E9E9E), Color(0xffE0E0E0)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),*/
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Container(
                                constraints:
                                BoxConstraints(maxWidth: 280.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  "Info",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black, fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // Communcation from Flutter to Unity
  void setRotationSpeed(String speed) {
    _unityWidgetController.postMessage(
      'Cube',
      'SetRotationSpeed',
      speed,
    );
  }

  // Communcation from Flutter to Unity
  void setAR(String speed) {
    _unityWidgetController.postMessage(
      'Cube',
      'SetRotationSpeed',
      speed,
    );
  }

  // Communication from Unity to Flutter
  void onUnityMessage(message) {
    log('unity1 ->'+ message.toString());
    print('Received message from unity: ${message.toString()}');
    if(message.toString() == 'gpu'){
      setState(() {
        info = message.toString();
        visibilityInfo = true;
      });
    }
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }

  // Communication from Unity when new scene is loaded to Flutter
  void onUnitySceneLoaded(SceneLoaded? sceneInfo) {
    log('unity2 ->'+'${sceneInfo?.name}');
    log('unity2 ->'+'${sceneInfo?.buildIndex}');
    print('Received scene loaded from unity: ${sceneInfo?.name}');
    print('Received scene loaded from unity buildIndex: ${sceneInfo?.buildIndex}');
  }

  Future<void> requestPermission() async {
    final permission = Permission.camera;

    if (await permission.isDenied) {
      await permission.request();
    }
  }

  Future<bool> checkPermissionStatus() async {
    final permission = Permission.camera;

    return await permission.status.isGranted;
  }

}

