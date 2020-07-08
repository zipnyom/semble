enum DateType { start, end }
// attend : 출석함, tardy : 지각, cut : 결석

extension VoteTypeExtention on DateType {
  String get day {
    switch (this) {
      case DateType.start:
        return '시작일';
      case DateType.end:
        return '종료일';
      default:
        return null;
    }
  }
}
