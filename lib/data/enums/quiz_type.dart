enum QuizType { complete, ing, canceled, text, date }
// attend : 출석함, tardy : 지각, cut : 결석

extension QuizTypeExtention on QuizType {
  String get name {
    switch (this) {
      case QuizType.complete:
        return '응답완료';
      case QuizType.ing:
        return '진행중';
      case QuizType.canceled:
        return '취소됨';
      case QuizType.text:
        return '텍스트';
      case QuizType.date:
        return '날짜';
      default:
        return null;
    }
  }
}

/***
 * 아래는 미국 출석 처리에 관한 TMI
 * E: Excused Absence 이유있는 결석
 * A: Absence due to School Activities 학교활동으로 결석
 * W: Warrant 정당한 이유 (예: 장례식)
 * CC: Full Day Cut 하루종일 땡땡이
 * PC: Period Cut 그 시간만 땡땡이
 * T: Tardy 지각
 * S: Suspension 정학 (보통 dean's office에서 매일 정학당한 학생들의 리스트를 이메일로 보내줍니다.)
 */
