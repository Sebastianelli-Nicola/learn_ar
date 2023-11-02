import 'package:flutter/material.dart';

import '../database/DbFireBaseConnect.dart';
import '../database/InfoModel.dart';

class ArProvider extends ChangeNotifier{
  var db = DBconnect();

  //return a list of informations of 3d model
  Future<List<Info>> getData(String chapter) async{
    return db.fetchInfo(chapter);
  }
}