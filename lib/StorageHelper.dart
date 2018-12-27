import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

const CALORIES_IN_PROGRESS = "calories_in_progress";
const RECENT_CALORIES = "recent_calories";
const DAY_LIMIT = 11;

void saveCaloriesInProgress(int caloriesInProgress) {

  SharedPreferences.getInstance().then((sharedPrefs) {
    sharedPrefs.setInt(CALORIES_IN_PROGRESS, caloriesInProgress);
  });
}

PublishSubject<int> getCaloriesInProgress() {

  final caloriesInProgressStream = PublishSubject<int>();

  SharedPreferences.getInstance().then((sharedPrefs) {
    int caloriesInProgress = sharedPrefs.getInt(CALORIES_IN_PROGRESS);
    caloriesInProgressStream.add(caloriesInProgress);

    caloriesInProgressStream.close();
  });

  return caloriesInProgressStream;
}

void saveTodaysCalories(int todaysCalories) {

  getRecentCalories().listen((recentCalories) {
    if (recentCalories == null) {
      recentCalories = List<int>();
    }

    print("$todaysCalories today");

    recentCalories.insert(0, todaysCalories);

    //remove from end of list of its more than 10 (all we show)
    if (recentCalories.length > DAY_LIMIT) {
      recentCalories.removeLast();
    }

    print(recentCalories);
    SharedPreferences.getInstance().then((sharedPrefs) {
      sharedPrefs.setString(RECENT_CALORIES, json.encode(recentCalories));
    });

  });

}

PublishSubject<List<int>> getRecentCalories() {

  final recentCaloriesStream = PublishSubject<List<int>>();

  SharedPreferences.getInstance().then((sharedPrefs) {
    String recentCaloriesJson = sharedPrefs.getString(RECENT_CALORIES);

    List<dynamic> recentCalories;

    if (recentCaloriesJson != null) {
      recentCalories = json.decode(recentCaloriesJson);
    }

    recentCaloriesStream.add(recentCalories.cast<int>().toList());
    recentCaloriesStream.close();
  });

  return recentCaloriesStream;

}