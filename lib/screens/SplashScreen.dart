import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<SplashScreen> /*with AfterLayoutMixin<Splash>*/ {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      if (!mounted) return;
      Navigator.pushNamed(context, '/homepage');
    } else {
      await prefs.setBool('seen', true);
      if (!mounted) return;
      Navigator.pushNamed(context, '/introscreen');
    }
  }

  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}