import 'package:flutter/material.dart';
import 'package:schuul/src/data/enums/vote_type.dart';

class FilterChipWidget extends StatefulWidget {
  final VoteType voteType;
  final List<String> filterList;
  final Function press;

  FilterChipWidget({Key key, this.voteType, this.filterList, this.press})
      : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.voteType.name),
      labelStyle: TextStyle(
          color: Color(0xff6200ee),
          fontSize: 16.0,
          fontWeight: FontWeight.bold),
      selected: widget.filterList.contains(widget.voteType.code),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Color(0xffededed),
      onSelected: (isSelected) {
        widget.press(widget.voteType);
      },
      selectedColor: Color(0xffeadffd),
    );
  }
}
