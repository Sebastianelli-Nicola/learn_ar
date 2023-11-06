import 'dart:convert';
import 'dart:developer';
//import 'dart:html';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_ar/ScreenArguments.dart';
import 'package:learn_ar/constants.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../database/ChapterModel.dart';
import '../../database/DbFireBaseConnect.dart';
import '../../provider/QuizProvider.dart';
import '../../utility/PermissionUtility.dart';

class ScanQuiz extends StatefulWidget {
  //const ScanQuiz({Key? key}) : super(key: key);

  final String title;
  final List<bool> list;


  const ScanQuiz({
    super.key,
    required this.title,
    required this.list,
  });

  @override
  State<StatefulWidget> createState() => _ScanQuizState();
}

class _ScanQuizState extends State<ScanQuiz> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool correct = false;
  var data;
  bool showSnackLock = false;


   @override
  void initState() {
     //readJson();
     final provider = Provider.of<QuizProvider>(context, listen: false);
     //provider.readJson();
     data = provider.item;
     PermissionUtility().requestPermission();
     super.initState();
  }

  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        //title: const Text('Scan QR Code'),
        backgroundColor: Colors.transparent,
        foregroundColor: background,
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
                },
              icon: const Icon(Icons.flash_on)
          ),
          IconButton(
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {});
              },
              icon: const Icon(Icons.camera)
          ),
        ],
      ),
      body: Stack(
        children:  <Widget>[
          _buildQrView(context),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('Place the QR Code in the area', style: TextStyle(fontSize: 15.0, color: background),textAlign: TextAlign.center,)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    //check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: background,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        log('scan1 -> $scanData');
        var filter = scanFilter();
        for(int i=0; i<filter.length; i++){
          log('scan2 -> ${filter[i].name}');
          if (result!.code == filter[i].name){
            if(filter[i].isLock == false){
              log('qui3 -> ${filter[i].name}');
              Navigator.pop(context);
              Navigator.pushNamed(context, '/quizpage', arguments: ScreenArguments('name', filter[i].name, 'scan'));
            }
            else{
              if(showSnackLock== false){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Chapter Locked'),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                ));
                showSnackLock = true;
              }

            }

            //reassemble();
            return;
          }
        }

      });

    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  //return list of filters for qrcode
  List<Chapter> scanFilter(){
    List<Chapter> newChapters = [];
     var listLock = widget.list;
     log('listlock ->$listLock');
    int i = 0;
    data.forEach((key, value){
      log('listlock$i ->${listLock[i]}');
      var newChapter = Chapter(id: key, name: (value['name']),isLock: listLock[i]);
      i++;
      log('newChapter ->$newChapter');
      newChapters.add(newChapter);
    });
    log('newChapterslist ->$newChapters');
    return newChapters;
  }




}