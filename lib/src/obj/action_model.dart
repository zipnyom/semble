import 'package:schuul/src/data/enums/action_type.dart';

class ActionModel {
  final ActionType type;
  final Function press;

  ActionModel(this.type, this.press);
}
