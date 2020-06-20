enum ActionType {
  attend,
  tardy,
  cut,
  bulkAttend,
  bulkTardy,
  bulkCut,
  bulkDelete,
  delete,
  add
}
// attend : 출석함, tardy : 지각, cut : 결석

extension ActionTypeExtention on ActionType {
  String get name {
    switch (this) {
      case ActionType.attend:
        return '출석처리';
      case ActionType.tardy:
        return '지각처리';
      case ActionType.cut:
        return '결석처리';
      case ActionType.bulkAttend:
        return '일괄 출석처리';
      case ActionType.bulkTardy:
        return '일괄 지각처리';
      case ActionType.bulkCut:
        return '일괄 결석처리';
      case ActionType.bulkDelete:
        return '일괄삭제';
      case ActionType.delete:
        return '삭제';
      case ActionType.add:
        return '추가';
      default:
        return null;
    }
  }
}
