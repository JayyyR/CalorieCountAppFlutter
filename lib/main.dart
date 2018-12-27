import 'package:calorie_counter/AddCaloriesPage.dart';
import 'package:calorie_counter/RecentDaysPage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _MyAppViewModel _viewModel;
  _MyAppState() {
    _viewModel = _MyAppViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Calorie Counter',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Calorie Counter"),
                bottom: TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.home),
                      text: "Today",
                    ),
                    Tab(icon: Icon(Icons.calendar_today), text: "Recent"),
                  ],
                ),
              ),
              body: TabBarView(children: [
                AddCaloriesPage(
                    daySavedCallback: _viewModel.dayOfCaloriesSaved),
                RecentDaysPage()
              ]),
            )));
  }
}

class _MyAppViewModel {
  final Function(int) dayOfCaloriesSaved = (int) {
    //todo save something
  };
}
