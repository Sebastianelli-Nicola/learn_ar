import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_ar/ScanQuizArguments.dart';
import 'package:learn_ar/database/DbFireBaseConnect.dart';
import 'package:learn_ar/database/QuestionModel.dart';
import 'package:learn_ar/database/StatisticModel.dart';
import 'package:learn_ar/provider/ArProvider.dart';
import 'package:learn_ar/provider/HomeProvider.dart';
import 'package:learn_ar/provider/QuizProvider.dart';
import 'package:learn_ar/provider/StatisticProvider.dart';
import 'package:learn_ar/screens/ar/ArPage.dart';
import 'package:learn_ar/screens/auth/AuthPage.dart';
import 'package:learn_ar/screens/home/Homepage.dart';
import 'package:learn_ar/screens/IntroScreen.dart';
import 'package:learn_ar/screens/SplashScreen.dart';
import 'package:learn_ar/screens/ar/InfoArPage.dart';
import 'package:learn_ar/screens/home/ProfilePage.dart';
import 'package:learn_ar/screens/quiz/QuizPage.dart';
import 'package:learn_ar/screens/quiz/ScanQuizPage.dart';
import 'package:learn_ar/screens/quiz/SectionQuizPage.dart';
import 'package:learn_ar/screens/statistics/StatisticsPage.dart';
import 'package:learn_ar/theme/Themes.dart';
import 'package:provider/provider.dart';
import 'ScreenArguments.dart';
import 'auth.dart';
import 'screens/Login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async {
  /*var db = DBconnect();
  db.addStatistic(Statistic(id: '1', email: 'seba97985@gmail.com', stats: {
    'gpu': 70,'ram': 75,'cpu': 30,},));*/
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Auth().signOut();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //*@override
  /*Future<AppExitResponse> didRequestAppExit() async {
    Auth().signOut();
    return AppExitResponse.exit;
  }*/

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        //Auth().signInWithEmailAndPassword(email: Auth().currentUser!.email, password: uth().currentUser.p)
        break;
      case AppLifecycleState.detached:
        //Auth().signOut();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => QuizProvider()),
                  ChangeNotifierProvider(create: (context) => StatisticProvider()),
                  ChangeNotifierProvider(create: (context) => ArProvider()),
                  ChangeNotifierProvider(create: (context) => HomeProvider())],
      child: MaterialApp(
          title: 'Learn AR',
          theme: theme,
          routes: {
            //'/splashscreen': (context) => const SplashScreen(),
            //'/introscreen': (context) => IntroScreen(),
            //'/': (context) => const MyHomePage(title: 'LearnAR'),
            //'/login': (context) => const IntroSignUp(),
            '/homepage': (context) => const Intro(),
            '/profile': (context) => const ProfilePage(),
            '/auth': (context) => const AuthPage(),
            '/ar': (context) => const ArPage(),
            //'/infoar': (context) => const InfoAr(),
            '/quizhomepage': (context) => const SectionQuizPage(),
            //'/quizpage': (context) => const QuizPage(title: '', message: 'gpu',),
            //'/scanquiz': (context) => const ScanQuiz(),
            '/statistics': (context) => const Statistics(),
          },
          onGenerateRoute: (settings) {
            // If you push the PassArguments route
            if (settings.name == '/quizpage') {
              // Cast the arguments to the correct
              // type: ScreenArguments.
              final args = settings.arguments as ScreenArguments;

              // Then, extract the required data from
              // the arguments and pass the data to the
              // correct screen.
              return MaterialPageRoute(
                builder: (context) {
                  return QuizPage(
                    title: args.title,
                    message: args.message,
                    origin: args.origin,
                  );
                },
              );
            }
            if (settings.name == '/infoar') {
              // Cast the arguments to the correct
              // type: ScreenArguments.
              final args = settings.arguments as ScreenArguments;

              // Then, extract the required data from
              // the arguments and pass the data to the
              // correct screen.
              return MaterialPageRoute(
                builder: (context) {
                  return InfoAr(
                    title: args.title,
                    message: args.message,
                    origin: args.origin,
                  );
                },
              );
            }
            if (settings.name == '/scanquiz') {
              // Cast the arguments to the correct
              // type: ScreenArguments.
              final args = settings.arguments as ScanQuizArguments;

              // Then, extract the required data from
              // the arguments and pass the data to the
              // correct screen.
              return MaterialPageRoute(
                builder: (context) {
                  return ScanQuiz(
                    title: args.title,
                    list: args.list,
                  );
                },
              );
            }

            assert(false, 'Need to implement ${settings.name}');
            return null;
          },
          home: AnimatedSplashScreen(
            splash: Column(
              children: [
                Image.asset('assets/learn_ar_logo.png',width: 60.0, height: 60.0,),
                Text('Learn AR',style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),),
              ],
            ),
            splashIconSize: 150.0,
            splashTransition: SplashTransition.fadeTransition,
            nextScreen: StreamBuilder(
                stream: Auth().authStateChanges,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Intro()/*IntroSignUp()*/;
                  }
                  else {
                    return AuthPage();
                  }
                }),
          )


      ),
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
