import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_ar/screens/AuthPage.dart';
import 'package:learn_ar/screens/Homepage.dart';
import 'package:provider/provider.dart';
import 'screens/Login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
          title: 'Routine Programmer',
          //theme: theme,
          routes: {
            '/': (context) => const MyHomePage(title: 'LearnAR'),
            '/login': (context) => const IntroSignUp(),
            '/homepage': (context) => const Intro(),
            '/auth': (context) => const AuthPage(),
          }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  /*int currentIndex = 1;
  final screens = [
    CategoryList(),
    const ProgrammedActList(),
    FavouriteActList(),
  ];

  updateCurrentIndex(index) {
    setState(() => currentIndex = index);
  }

  _MyHomePageState (){
    var list = CategoryProvider().item;
    if(list.isEmpty){
      CategoryProvider().insertCategory("Other");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Text("Hi,", style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'circle'
                  ),),
                  Text("Have fun,", style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'circle'
                  ),),
                  Text("Lets get started", style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'circle'
                  ),),
                ],
              ),
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.5,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/flyer.png'),
                      fit: BoxFit.contain
                  )
              ),
            ),
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 15,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: IconButton(
                        onPressed: (){
                          Navigator.pushNamed(context, '/login');
                          /*Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (__) => introsignup()));*/
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }




}