import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// const kPrimaryColor = Color(0xFF6F35A5);
// const kPrimaryLightColor = Color(0xFFF1E6FF);

const kPrimaryColor = Color(0xFF54BF86);
const kPrimaryLightColor = Color(0xFFC2FBDB);

// const kTextColor = Color(0xFF0D1333);
const kBlueColor = Color(0xFF6E8AFA);
const kBestSellerColor = Color(0xFFFFD073);
const kGreenColor = Color(0xFF49CC96);

const kBackgroundColor = Color(0xFFFAFAFA);

const kTextColor = Color(0xFF1E2432);
const kTextMediumColor = Color(0xFF53627C);
const kTextLightColor = Color(0xFFACB1C0);
// const kPrimaryColor = Color(0xFF0D8E53);
const kBackgroundColor2 = Color(0xFFFCFCFC);
const kInactiveChartColor = Color(0xFFEAECEF);

// My Text Styles
const kHeadingextStyle = TextStyle(
  fontSize: 22,
  color: kTextColor,
  fontWeight: FontWeight.bold,
);
const kSubheadingextStyle = TextStyle(
  fontSize: 20,
  color: Color(0xFF61688B),
  height: 2,
);

const kTitleTextStyle = TextStyle(
  fontSize: 20,
  color: kTextColor,
  fontWeight: FontWeight.bold,
);

const kSubtitleTextSyule = TextStyle(
  fontSize: 18,
  color: kTextColor,
  // fontWeight: FontWeight.bold,
);

const kListTitleStyle = TextStyle(
  fontSize: 18,
  color: kTextColor,
  fontWeight: FontWeight.bold,
);
const kListSubTitleStyle = TextStyle(
  fontSize: 12,
  color: kTextLightColor,
  fontWeight: FontWeight.bold,
);

const kAttendColor = kPrimaryColor;
const kTardyColor = Colors.amber;
const kCutColor = Colors.redAccent;

const sampleTitle1 = "안녕하세요 여러분 조정석입니다. 슬기로운 의사생활 때려치고 강의를 시작했어요";
const sampleTitle2 = "다음주 토요일 수업에 퀴즈 할 예정입니다.";
const sampleTitle3 = "휴강 안내";

String tShortAnswer = "주관식";
String tMultipleChoice = "객관식";

const double modalMaxWidth = 400;

const Color modalBackgroundColor = Color.fromRGBO(241, 241, 241, 1);

const String db_col_items = "items";
const String db_col_vote = "vote";
const String db_col_class = "class";
const String db_col_event = "event";
const String db_col_user = "user";
String gEmail = "";

const String monday = "월";
const String tuesday = "화";
const String wednesday = "수";
const String thursday = "목";
const String friday = "금";
const String saturday = "토";
const String sunday = "일";

const String defaultImagePath = "assets/images/login_bottom.png";
