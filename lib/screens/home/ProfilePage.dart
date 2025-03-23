import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_ar/database/auth.dart';
import 'package:learn_ar/provider/HomeProvider.dart';
import 'package:provider/provider.dart';
import 'package:learn_ar/database/models/UserModel.dart' as profile;

import '../../constants.dart';
import '../../database/DbFireBaseConnect.dart';
import '../../database/models/Info.dart';
import '../../provider/ArProvider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late Future _info;

  @override
  void initState() {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    _info = provider.getDataProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _info,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else if (snapshot.hasData) {
              var extractedData = snapshot.data as profile.UserModel;
              return Scaffold(
                appBar: AppBar(
                  //foregroundColor: background,
                  //backgroundColor: background2,
                  shadowColor: Colors.transparent,
                ),
                body: Container(
                  padding: EdgeInsets.all(20),
                  color: CupertinoColors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Welcome in", style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'circle'
                                      ),),
                                      Text("Profile Section", style: TextStyle(
                                          fontSize: 27,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'circle'
                                      ),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.0,),
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Email: \t\t\t\t\t\t\t', style: TextStyle(fontSize: 19.0,fontWeight: FontWeight.bold),),
                                      Text(Auth().currentUser!.email.toString(), style: TextStyle(fontSize: 14.0),),
                                    ],
                                  ),
                                  SizedBox(height: 30.0,),
                                  Row(
                                    children: [
                                      Text('Name: \t\t\t\t\t\t', style: TextStyle(fontSize: 19.0,fontWeight: FontWeight.bold),),
                                      Text(extractedData.name, style: TextStyle(fontSize: 17.0),),
                                    ],
                                  ),
                                  SizedBox(height: 30.0,),
                                  Row(
                                    children: [
                                      Text('Surname: \t', style: TextStyle(fontSize: 19.0,fontWeight: FontWeight.bold),),
                                      Text(extractedData.surname, style: TextStyle(fontSize: 17.0),),
                                    ],
                                  ),
                                  SizedBox(height: 30.0,),
                                  Row(
                                    children: [
                                      Text('Birthday: \t', style: TextStyle(fontSize: 19.0,fontWeight: FontWeight.bold),),
                                      Text(extractedData.birthDate, style: TextStyle(fontSize: 17.0),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
          else {
            return Container(
              color: CupertinoColors.white,
              child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20.0,),
                    ],
                  )
              ),
            );
          }
          return Center(child: Text('No Data'));
        },
      );
  }
}
