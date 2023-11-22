import 'package:flutter/material.dart';

import '../auth.dart';
import '../database/DbFireBaseConnect.dart';
import '../database/StatisticModel.dart';

class StatisticProvider extends ChangeNotifier{
  var db = DBconnect();

  Future<Statistic> getDataStatistics()async{
    var emailWithoutComma = Auth().currentUser!.email.toString()/*.replaceAll('.', '')*/;
    return db.fetchStatistic(emailWithoutComma);
  }
}