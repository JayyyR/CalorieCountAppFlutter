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
  final TextEditingController _calorieEditTextController = TextEditingController();

  _AddCaloriesPageState() {
    //initialize viewmodel with trigger to update state
    viewModel = _AddCaloriesPageViewModel(triggerViewStateChange: () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
          Text(
              "${viewModel.totalCaloriesForDay}",
              style: TextStyle(fontSize: 16.0)
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 96,
              right: 96
            ),
            child: TextField(
              textAlign: TextAlign.center,
              controller: _calorieEditTextController,
              keyboardType: TextInputType.number,
            )
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 16.0
            ),
            child: MaterialButton(
              color: Colors.blue[200],
              onPressed: () {
                int calories = int.parse(_calorieEditTextController.text);
                viewModel.onAddCaloriesToDayPressed(calories);
                _calorieEditTextController.clear();
              },
              child: Text("Add"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 16.0
            ),
            child: MaterialButton(
              color: Colors.red[200],
              onPressed: () {
              },
              child: Text("End The Day"),
            ),
          )
        ],
      )),
    );
  }
}

class _AddCaloriesPageViewModel {
  final VoidCallback triggerViewStateChange;
  final PublishSubject<int> dayFinished = PublishSubject();

  int totalCaloriesForDay = 0;

  _AddCaloriesPageViewModel({@required this.triggerViewStateChange});

  void dispose() => dayFinished.close();

  void onAddCaloriesToDayPressed(int caloriesInMeal) {
    //add calories to total
    totalCaloriesForDay += caloriesInMeal;

    //trigger view state
    triggerViewStateChange();
  }
}
