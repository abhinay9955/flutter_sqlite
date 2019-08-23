import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/showlist.dart';
import './screens/insert.dart';

main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShowList(),
    );
  }
}
