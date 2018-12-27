import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:calorie_counter/StorageHelper.dart';

class RecentDaysPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _RecentDaysPageState();
  }
}

class _RecentDaysPageState extends State<RecentDaysPage> {
  _RecentDaysPageViewModel _viewModel;

  _RecentDaysPageState() {
    _viewModel = _RecentDaysPageViewModel(triggerViewStateChange: () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _viewModel.getRecentCaloriesLength() * 2,
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return Divider();
        }

        final index = i ~/ 2;
        final daysAgo = index + 1;
        final daysAgoString = (daysAgo == 1) ? "yesterday" : "$daysAgo days ago";
        String dayText = "Calories consumed $daysAgoString: "
            "${_viewModel.getCaloriesConsumed(daysAgo)}";
        return Text(
            dayText,
            style: TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
        );
      },
    );
  }
}

class _RecentDaysPageViewModel {
  final VoidCallback triggerViewStateChange;
  List<int> _recentCalories = List<int>();

  int getRecentCaloriesLength() {
    return _recentCalories.length;
  }

  int getCaloriesConsumed(int daysAgo) {
    return _recentCalories[daysAgo - 1];
  }

  _RecentDaysPageViewModel({@required this.triggerViewStateChange}) {
    getRecentCalories().listen((recentStoredCalories) {
      if (recentStoredCalories != null) {
        _recentCalories = recentStoredCalories;
        triggerViewStateChange();
      }
    });
  }
}