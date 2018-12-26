import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AddCaloriesPage extends StatefulWidget {
  final Function daySavedCallback;

  AddCaloriesPage({@required this.daySavedCallback});

  @override
  _AddCaloriesPageState createState() => _AddCaloriesPageState();
}

class _AddCaloriesPageState extends State<AddCaloriesPage> {

  _AddCaloriesPageViewModel viewModel;

  _AddCaloriesPageState() {
    //initialize viewmodel with trigger to update state
    viewModel = _AddCaloriesPageViewModel(triggerViewStateChange: (){
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

class _AddCaloriesPageViewModel {

  final VoidCallback triggerViewStateChange;
  final PublishSubject<int> dayFinished = PublishSubject();

  _AddCaloriesPageViewModel({@required this.triggerViewStateChange});

  int totalCaloriesForDay = 0;

  void onAddCaloriesToDayPressed(int caloriesInMeal) {
    //add calories to total
    totalCaloriesForDay += caloriesInMeal;

    //trigger view state
    triggerViewStateChange();
  }

  void dispose() => dayFinished.close();
}
