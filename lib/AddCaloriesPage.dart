import 'package:calorie_counter/StorageHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class AddCaloriesPage extends StatefulWidget {
  final Function daySavedCallback;

  AddCaloriesPage({@required this.daySavedCallback});

  @override
  _AddCaloriesPageState createState() => _AddCaloriesPageState();
}

class _AddCaloriesPageState extends State<AddCaloriesPage> {
  _AddCaloriesPageViewModel _viewModel;
  final TextEditingController _calorieEditTextController =
      TextEditingController();

  _AddCaloriesPageState() {
    //initialize viewmodel with trigger to update state
    _viewModel = _AddCaloriesPageViewModel(triggerViewStateChange: () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Day's Calorie Count",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Text("${_viewModel.totalCaloriesForDay}",
              style: TextStyle(fontSize: 16.0)),
          Padding(
              padding: EdgeInsets.only(left: 96, right: 96),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _calorieEditTextController,
                keyboardType: TextInputType.number,
              )),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: MaterialButton(
                    color: Colors.red[200],
                    onPressed: () {
                      _viewModel.clearCalories();
                    },
                    child: Text("Clear"),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: MaterialButton(
                      color: Colors.blue[200],
                      onPressed: () {
                        int calories = int.parse(_calorieEditTextController.text);
                        _viewModel.onAddCaloriesToDayPressed(calories);
                        _calorieEditTextController.clear();
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                      },
                      child: Text("Add"),
                    )),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: MaterialButton(
              color: Colors.green[200],
              onPressed: () {
                _viewModel.saveDaysCalories();
              },
              child: Text("End The Day"),
            ),
          )
        ],
      ),
    );
  }
}

class _AddCaloriesPageViewModel {
  final VoidCallback triggerViewStateChange;

  int totalCaloriesForDay = 0;

  _AddCaloriesPageViewModel({@required this.triggerViewStateChange}) {
    //get calories from storage
    getCaloriesInProgress().listen((caloriesInProgress) {
      if (caloriesInProgress != null) {
        totalCaloriesForDay = caloriesInProgress;
        triggerViewStateChange();
      }
    });
  }

  void clearCalories() {
    totalCaloriesForDay = 0;
    triggerViewStateChange();
    saveCaloriesInProgress(totalCaloriesForDay);
  }

  void saveDaysCalories() {
    saveTodaysCalories(totalCaloriesForDay);
    clearCalories();
  }

  void onAddCaloriesToDayPressed(int caloriesInMeal) {
    //add calories to total
    totalCaloriesForDay += caloriesInMeal;
    //trigger view state
    triggerViewStateChange();
    saveCaloriesInProgress(totalCaloriesForDay);
  }
}
