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
  List<Widget> _children;

  _MyAppState() {
    _viewModel = _MyAppViewModel(triggerViewStateChange: () {
      setState(() {});
    });

    _children = [
      AddCaloriesPage(daySavedCallback: _viewModel.dayOfCaloriesSaved),
      RecentDaysPage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Calorie Counter',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: Scaffold(
          appBar: AppBar(title: Text("Calorie Counter")),
          body: _children[_viewModel.getCurrentIndex()],
          bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                  canvasColor: Colors.white,
                  primaryColor: Colors.orange,
              ),
              child: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Text("Today")
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      title: Text("Recent")
                  )
                ],
                onTap: (int indexTapped) {
                  _viewModel.updateCurrentIndex(indexTapped);
                },
                currentIndex: _viewModel.getCurrentIndex())
          )
        )
    );
  }
}

class _MyAppViewModel {

  final VoidCallback triggerViewStateChange;
  int _currentIndex = 0;

  _MyAppViewModel({@required this.triggerViewStateChange});

  int getCurrentIndex() {
    return _currentIndex;
  }

  updateCurrentIndex(int index) {
    _currentIndex = index;
    triggerViewStateChange();
  }

  final Function(int) dayOfCaloriesSaved = (int) {
    //todo save something
  };
}
