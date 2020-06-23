import 'package:json_annotation/json_annotation.dart';

part 'clicker.g.dart';

@JsonSerializable()
class Clicker {
  @JsonKey(name: 'clicker_title')
  String clickerName;
  @JsonKey(name: 'time_stamp')
  String timeStamp;

  bool _checked = false;

  bool get checked => _checked;

  set checked(bool checked) {
    _checked = checked;
  }

  Clicker(
    this.clickerName,
    this.timeStamp,
  );

  factory Clicker.fromJson(Map<String, dynamic> json) =>
      _$ClickerFromJson(json);

  Map<String, dynamic> toJson() => _$ClickerToJson(this);
}
