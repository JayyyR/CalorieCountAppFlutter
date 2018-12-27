import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

const CALORIES_IN_PROGRESS = "calories_in_progress";

void saveCaloriesInProgress(int caloriesInProgress) {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _prefs.then((sharedPrefs) {
    sharedPrefs.setInt(CALORIES_IN_PROGRESS, caloriesInProgress);
  });
}

PublishSubject<int> getCaloriesInProgress() {

  final caloriesInProgressStream = PublishSubject<int>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _prefs.then((sharedPrefs) {
    int caloriesInProgress = sharedPrefs.getInt(CALORIES_IN_PROGRESS);
    caloriesInProgressStream.add(caloriesInProgress);

  });

  return caloriesInProgressStream;
}