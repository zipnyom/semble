enum VoteType {
  done,
  running,
  yet,
  canceled,
  text,
  limited,
  date,
  multiple,
  ananymous,
  addable
}
// attend : 출석함, tardy : 지각, cut : 결석

extension VoteTypeExtention on VoteType {
  String get name {
    switch (this) {
      case VoteType.done:
        return '마감됨';
      case VoteType.running:
        return '진행중';
      case VoteType.yet:
        return '실행 전';
      case VoteType.canceled:
        return '취소됨';
      case VoteType.text:
        return '텍스트';
      case VoteType.date:
        return '날짜';
      case VoteType.limited:
        return '마감시간 설정';
      case VoteType.multiple:
        return '복수 선택';
      case VoteType.ananymous:
        return '익명';
      case VoteType.addable:
        return '선택항목 추가 허용';

      default:
        return null;
    }
  }

  String get code {
    switch (this) {
      case VoteType.done:
        return 'done';
      case VoteType.running:
        return 'running';
      case VoteType.yet:
        return 'yet';
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
