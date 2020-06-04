import 'package:flutter/material.dart';
import 'package:schuul/screens/main/home/model/class_model.dart';

class ClassNotifier extends ChangeNotifier {
  List<ClassModel> _classes = [];

  List<ClassModel> get classes => _classes;
  set classes(List<ClassModel> newClasses) {
    _classes.clear();
    _classes.addAll(newClasses);
    notifyListeners();
  }
}

ClassNotifier classNotifier = ClassNotifier();
