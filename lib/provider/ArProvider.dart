import 'package:flutter/material.dart';

import '../database/DbFireBaseConnect.dart';
import '../database/InfoModel.dart';

class ArProvider extends ChangeNotifier{
  var db = DBconnect();

  Future<List<Info>> getData() async{
    return db.fetchInfo();
  }
}