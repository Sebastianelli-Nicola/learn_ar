import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_ar/auth.dart';
import 'package:learn_ar/database/DbFireBaseConnect.dart';
import 'package:learn_ar/database/UserModel.dart' as consumer;


import '../../constants.dart';

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
  DateTime selectedDate = DateTime(2010, 12, 31);
  dynamic selectedDateF;

  DBconnect db = DBconnect();

  Future<void> signIn() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
    } on FirebaseAuthException catch (error) {
      // Handle Errors here.
      var errorCode = error.code;
      var errorMessage = error.message;
      if (errorCode == 'INVALID_LOGIN_CREDENTIALS') {
        //alert('Wrong password.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Email or Password not correct'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        ));
      } else if(errorCode == 'too-many-requests'){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('We have blocked all requests from this device due to unusual activity. Try again later'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        ));
      }
    }
    ;
  }

  Future<void> createUser() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _email.text, password: _password.text);
    } on FirebaseAuthException catch (error) {
      var errorCode = error.code;
      var errorMessage = error.message;
      if (errorCode == 'email-already-in-use') {
        //alert('Wrong password.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The email address is already in use by another account'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        ));
      } else if(errorCode == 'too-many-requests'){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('We have blocked all requests from this device due to unusual activity. Try again later'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        ));
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: background,
          backgroundColor: background2,
          shadowColor: Colors.transparent),
      backgroundColor: background2,
      body: Container(
        padding: const EdgeInsets.only(left: 30.0, top: 30.0, right: 30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Learn AR',
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                isLogin ? 'Login' : 'Sign up',
                style: const TextStyle(
                    fontSize: 20.0,
                    color: background,
                    fontWeight: FontWeight.bold),
              ),
              const Divider(
                color: background,
              ),
              //const SizedBox(height: 5.0,),
              isLogin == true
                  ? Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _email,
                            decoration:
                                const InputDecoration(label: Text('email')),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _password,
                            obscureText: true,
                            decoration:
                                const InputDecoration(label: Text('password')),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    )
                  : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _email,
                            decoration:
                                const InputDecoration(label: Text('email')),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              } else if (!value.contains('@') ||
                                  !value.contains('.')) {
                                return 'Invalid Email';
                              } else if (value.length < 6) {
                                return ("Email Must be more than 5 characters");
                              } else if (value.length > 64) {
                                return ("Email Must be fewer than 65 characters");
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _password,
                            obscureText: true,
                            decoration:
                                const InputDecoration(label: Text('password')),
                            validator: (value) {
                              RegExp regex = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              var passNonNullValue = value ?? "";
                              if (passNonNullValue.isEmpty) {
                                return ("Password is required");
                              } else if (passNonNullValue.length < 6) {
                                return ("Password Must be more than 5 characters");
                              } else if (passNonNullValue.length > 16) {
                                return ("Password Must be fewer than 17 characters");
                              }
                              /*else if(!regex.hasMatch(passNonNullValue)){
                              return ("Password should contain upper,lower,digit and Special character ");
                            }*/
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _name,
                            decoration:
                                const InputDecoration(label: Text('name')),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              } else if (value.length < 2) {
                                return ("Name Must be more than 1 characters");
                              } else if (value.length > 32) {
                                return ("Name Must be fewer than 33 characters");
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _surname,
                            decoration:
                                const InputDecoration(label: Text('surname')),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Surname is required';
                              } else if (value.length < 2) {
                                return ("Surname Must be more than 1 characters");
                              } else if (value.length > 64) {
                                return ("Surname Must be fewer than 65 characters");
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            onTap: () {
                              //showDatePicker(context: context, initialDate: selectedData, firstDate: DateTime(2002), lastDate: DateTime.now());
                              _selectDate(context);
                            },
                            controller: _date,
                            keyboardType: TextInputType.none,
                            decoration: const InputDecoration(
                                label: Text('birth date')),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Birth date is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      isLogin ? signIn() : createUser();
                      if (isLogin == false) {
                        db.addUserAndInfo(consumer.User(
                            id: '1',
                            email: _email.text.replaceAll('.', ''),
                            name: _name.text,
                            surname: _surname.text,
                            birthDate: _date.text));
                      }
                    }
                  },
                  child: Text(
                    isLogin ? 'Login' : 'Sign up',
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(isLogin
                    ? 'Don’t have an account yet? Sign up'
                    : 'Do you have an account? Login'),
              ),
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
        lastDate: DateTime(2010, 12, 31));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedDateF = "${selectedDate.toLocal()}".split(' ')[0];
        _date.text = selectedDateF;
      });
    }
  }
}
