import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_ar/database/DbFireBaseConnect.dart';
import 'package:learn_ar/database/QuestionModel.dart';
import 'package:learn_ar/screens/ArPage.dart';
import 'package:learn_ar/screens/AuthPage.dart';
import 'package:learn_ar/screens/Homepage.dart';
import 'package:learn_ar/screens/IntroScreen.dart';
import 'package:learn_ar/screens/SplashScreen.dart';
import 'package:learn_ar/screens/quiz/QuizPage.dart';
import 'package:learn_ar/screens/quiz/ScanQuizPage.dart';
import 'package:learn_ar/screens/quiz/StartPage.dart';
import 'package:provider/provider.dart';
import 'ScreenArguments.dart';
import 'auth.dart';
import 'screens/Login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  //var db = DBconnect();
  /*db.addQuestion(Question(id: '20', title: 'Quanto fa 20 x 100', options: {
    '100': false,'200': true,'300': false,'500': false,
  }));*/
  //db.fetchQuestion();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Learn AR',
        //theme: ,
        routes: {
          '/splashscreen': (context) => const SplashScreen(),
          '/introscreen': (context) => IntroScreen(),
          //'/': (context) => const MyHomePage(title: 'LearnAR'),
          '/login': (context) => const IntroSignUp(),
          '/homepage': (context) => const Intro(),
          '/auth': (context) => const AuthPage(),
          '/ar': (context) => const ArPage(),
          '/quizhomepage': (context) => const StartPage(),
          //'/quizpage': (context) => const QuizPage(title: '', message: 'gpu',),
          '/scanquiz': (context) => const ScanQuiz(),
        },
        onGenerateRoute: (settings) {
          // If you push the PassArguments route
          if (settings.name == '/quizpage') {
            // Cast the arguments to the correct
            // type: ScreenArguments.
            log('main -> ');
            final args = settings.arguments as ScreenArguments;
            log('main -> '+ args.toString());

            // Then, extract the required data from
            // the arguments and pass the data to the
            // correct screen.
            return MaterialPageRoute(
              builder: (context) {
                return QuizPage(
                  title: args.title,
                  message: args.message,
                );
              },
            );
          }
          // The code only supports
          // PassArgumentsScreen.routeName right now.
          // Other values need to be implemented if we
          // add them. The assertion here will help remind
          // us of that higher up in the call stack, since
          // this assertion would otherwise fire somewhere
          // in the framework.
          assert(false, 'Need to implement ${settings.name}');
          return null;
        },
        home: StreamBuilder(stream: Auth().authStateChanges, builder: (context, snapshot){
            if(snapshot.hasData){
              return Intro()/*IntroSignUp()*/;
            }
            else {
              return Intro();
            }
        })
        /*home: StreamBuilder(stream: Auth.authStateChanges, builder: (context, snapshot)){
    if(snapshot.hasData){
    return IntroSignUp();
    }
    else{
    return Intro();
    }
    }*/

    );
  }

}

/*class MyApp extends StatelessWidget {
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
          //initialRoute: '/splashscreen',
          routes: {
            '/splashscreen': (context) => const SplashScreen(),
            '/introscreen': (context) => IntroScreen(),
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

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Learn AR',
      //theme: ,
      home: StreamBuilder(stream: Auth.authStateChanges, builder: (context, snapshot)){
        if(snapshot.hasData){
          return IntroSignUp();
        }
        else{
          return Intro();
        }
    }

    )
  }

}

/*class _MyHomePageState extends State<MyHomePage> {

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




}*/*/
