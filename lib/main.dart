import 'package:calorie_counter/AddCaloriesPage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  final Function(int) dayOfCaloriesSaved = (int) {
    //todo save something
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Counter',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Calorie Counter")),
        body: AddCaloriesPage(daySavedCallback: dayOfCaloriesSaved),
      )
    );
  }
}