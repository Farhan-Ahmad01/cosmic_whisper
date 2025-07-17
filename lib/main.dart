import 'package:flutter/material.dart';

import 'pages/HomePage.dart';

void main (){
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'SixtyFour',
        primaryColor: Colors.black38
      ),
    );
  }
}
