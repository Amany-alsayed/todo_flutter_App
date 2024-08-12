import 'package:flutter/material.dart';

import 'layout/todo_app/todo_layout.dart';

void main() {
  runApp( MyApp());
}


  // This widget is the root of your application.
  @override
  class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
  debugShowCheckedModeBanner: false,
  home:HomeLayout(),
  );

  }
  }