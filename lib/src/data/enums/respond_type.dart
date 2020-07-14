enum RespondType { yes, no, ok, cancel }

extension ActionTypeExtention on RespondType {
  String get name {
    switch (this) {
      case RespondType.yes:
        return '예';
      case RespondType.no:
        return '아니오';
      case RespondType.ok:
        return '확인';
      case RespondType.cancel:
        return '취소';
      default:
        return null;
    }
  }
}
