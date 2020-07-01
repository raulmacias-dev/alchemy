import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedBackground(
            behaviour: RandomParticleBehaviour(),
            vsync: this,
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/pocion.png"),
                  width: MediaQuery.of(context).size.width / 1.7,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  '4lchemy',
                  style: GoogleFonts.griffy(),
                  textScaleFactor: 5,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  'Loading ...',
                  style: GoogleFonts.griffy(),
                  textScaleFactor: 3,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Image(
                  alignment: Alignment.centerLeft,
                  image: AssetImage("assets/text.png"),
                  width: MediaQuery.of(context).size.width / 2.7,
                ),
              ],
            ))) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}