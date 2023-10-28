import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_ar/auth.dart';
import 'package:learn_ar/database/DbFireBaseConnect.dart';
import 'package:learn_ar/database/UserModel.dart' as consumer;

import '../constants.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surname = TextEditingController();
  final TextEditingController _date = TextEditingController();
  bool isLogin = true;
  DateTime selectedDate = DateTime(2010,12,31);
  dynamic selectedDateF;

  DBconnect db = DBconnect();

  Future<void> signIn() async{
    try{
        await Auth().signInWithEmailAndPassword(email: _email.text, password: _password.text);
    }on FirebaseAuthException catch (error){}
  }

  Future<void> createUser() async{
    try{
      await Auth().createUserWithEmailAndPassword(email: _email.text, password: _password.text);
    }on FirebaseAuthException catch (error){}
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: background,
          backgroundColor: background2,
          shadowColor: Colors.transparent
      ),
      backgroundColor: background2,
      body: Container(
        padding: const EdgeInsets.only(left: 30.0,top: 30.0,right: 30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Learn AR', style: TextStyle(fontSize: 26.0,fontWeight: FontWeight.bold),),
              const SizedBox(height: 30.0,),
              Text(isLogin ? 'Login' : 'Sign up', style: const TextStyle(fontSize: 20.0, color: background,fontWeight: FontWeight.bold),),
              const Divider(color: background,),
              //const SizedBox(height: 5.0,),
              isLogin == true ?
                Column(
                  children: [
                    TextField(
                      controller: _email,
                      decoration: const InputDecoration(label: Text('email')),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(label: Text('password')),
                    )
                  ],
                )
              : Column(
                children: [
                  TextField(
                      controller: _email,
                      decoration: const InputDecoration(label: Text('email')),
                    ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(label: Text('password')),
                  ),
                  TextField(
                    controller: _name,
                    decoration: const InputDecoration(label: Text('name')),
                  ),
                  TextField(
                    controller: _surname,
                    decoration: const InputDecoration(label: Text('surname')),
                  ),
                  TextField(
                    onTap: (){
                      //showDatePicker(context: context, initialDate: selectedData, firstDate: DateTime(2002), lastDate: DateTime.now());
                      _selectDate(context);
                    },
                    controller: _date,
                    keyboardType: TextInputType.none,
                    decoration: const InputDecoration(label: Text('birth date')),
                  ),
                ],
              ),


              const SizedBox(height: 20.0,),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: (){
                  isLogin ? signIn() : createUser();
                  if (isLogin == false){
                    db.addUserAndInfo(consumer.User(id: '1', email: _email.text.replaceAll('.', ''), name: _name.text, surname: _surname.text, birthDate: _date.text));
                  }
                  },
                  child: Text(isLogin ? 'Login' : 'Sign up', style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                ),
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(isLogin ? 'Don’t have an account yet? Sign up' : 'Do you have an account? Login'),)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2010,12,31)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedDateF = "${selectedDate.toLocal()}".split(' ')[0];
        _date.text = selectedDateF;
      });
    }
  }

}