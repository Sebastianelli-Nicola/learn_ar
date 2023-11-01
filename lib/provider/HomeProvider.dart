import 'package:flutter/material.dart';
import 'package:learn_ar/database/UserModel.dart';

import '../auth.dart';
import '../database/DbFireBaseConnect.dart';
import '../database/StatisticModel.dart';

class HomeProvider extends ChangeNotifier{
  var db = DBconnect();

  Future<UserModel> getDataProfile()async{
    var emailWithoutComma = Auth().currentUser!.email.toString().replaceAll('.', '');
    return db.fetchUserInfo(emailWithoutComma);
  }
  Future<void> addUserInfo(UserModel user)async{
    db.addUserAndInfo(user);
  }

}