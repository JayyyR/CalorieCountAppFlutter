import 'package:calorie_counter/StorageHelper.dart';
import 'package:calorie_counter/Strings.dart';
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

  void _showEndDayDialog() {
    showDialog(context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text (Strings.END_THE_DAY_DIALOG_TITLE),
        content: Text(Strings.END_THE_DAY_DIALOG_BODY),
        actions: [
          FlatButton(
            child: Text(Strings.CANCEL),
            textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(Strings.YES),
            textColor: Colors.black,
            onPressed: () {
              _viewModel.saveDaysCalories();
              Navigator.of(context).pop();
            }
          ),
        ],
      );
    });
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
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
              Strings.DAY_CALORIE_COUNT,
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
                    child: Text(Strings.CLEAR),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: MaterialButton(
                      color: Colors.blue[200],
                      onPressed: () {
                        int calories = int.tryParse(_calorieEditTextController.text);

                        if (calories != null && calories > 0) {
                          _viewModel.onAddCaloriesToDayPressed(calories);
                          _calorieEditTextController.clear();
                          SystemChannels.textInput.invokeMethod(
                              'TextInput.hide');
                        } else {
                          _showSnackBar(Strings.NON_VALID_INPUT_MSG);
                        }
                      },
                      child: Text(Strings.ADD),
                    )),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: MaterialButton(
              color: Colors.green[200],
              onPressed: () {
                if (_viewModel.totalCaloriesForDay > 0) {
                  _showEndDayDialog();
                } else {
                  _showSnackBar(Strings.YOU_HAVENT_CONSUMED_ANY);
                }
              },
              child: Text(Strings.END_THE_DAY_BUTTON),
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
