import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_ar/ScreenArguments.dart';
import 'package:learn_ar/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../database/ChapterModel.dart';
import '../../database/DbFireBaseConnect.dart';

class ScanQuiz extends StatefulWidget {
  const ScanQuiz({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQuizState();
}

class _ScanQuizState extends State<ScanQuiz> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool correct = false;

   var data;
   @override
  void initState() {
     readJson();
     super.initState();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: background,
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
      body: Column(
        children:  <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Text('Place the QR Code in the area', style: TextStyle(fontSize: 15.0, color: Colors.red),textAlign: TextAlign.center,)

        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
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
          borderColor: Colors.red,
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
    // TODO: bug telecamera rimane attiva anche quando si avvaia il quiz e può leggere altri qrcode (WillPoScope ?)
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;

        var filter = scanFilter();
        for(int i=0; i<filter.length; i++){
          if (result!.code == filter[i].name){
            Navigator.pushNamed(context, '/quizpage', arguments: ScreenArguments('name', filter[i].name));
            reassemble();
            return;
          }
        }

        /*if (result!.code == 'gpu'){
          log('scan -> ');
          Navigator.pushNamed(context, '/quizpage', arguments: ScreenArguments('name', 'gpu'));
          reassemble();
        }
        if (result!.code == 'ram'){
          log('scan -> ');
          Navigator.pushNamed(context, '/quizpage', arguments: ScreenArguments('name', 'ram'));
          reassemble();
          controller.dispose();
        }*/

      });

    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  List<Chapter> scanFilter(){
    List<Chapter> newChapters = [];
    data.forEach((key, value){
      var newChapter = Chapter(id: key, name: (value['name']));
      newChapters.add(newChapter);
    });
    return newChapters;
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/chapters.json');
    data = json.decode(response) as Map<String, dynamic>;
  }





}