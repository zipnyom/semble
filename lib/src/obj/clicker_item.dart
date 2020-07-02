import 'package:json_annotation/json_annotation.dart';

part 'clicker_item.g.dart';

@JsonSerializable()
class ClickerItem {
  String title;
  int count;
  List<String> voters;

  ClickerItem(this.title, this.count, this.voters);

  factory ClickerItem.fromJson(Map<String, dynamic> json) =>
      _$ClickerItemFromJson(json);

  Map<String, dynamic> toJson() => _$ClickerItemToJson(this);
}
