import 'package:flutter/material.dart';
import 'package:schuul/src/obj/vote.dart';

enum Modes { teacher, student }

extension ModesExtention on Modes {
  String get name {
    switch (this) {
      case Modes.teacher:
        return '선생님 모드';
      case Modes.student:
        return '학생 모드';
      default:
        return null;
    }
  }
}

class Mode with ChangeNotifier {
  // Modes _mode = Modes.student;
  Modes _mode = Modes.teacher;

  Modes get mode => _mode;

  set mode(Modes mode) {
    _mode = mode;
    notifyListeners();
  }

  toggle() {
    _mode = _mode == Modes.teacher ? Modes.student : Modes.teacher;
    notifyListeners();
  }
}
