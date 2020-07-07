enum RespondType { yes, no }
// attend : 출석함, tardy : 지각, cut : 결석

extension ActionTypeExtention on RespondType {
  String get name {
    switch (this) {
      case RespondType.yes:
        return '예';
      case RespondType.no:
        return '아니오';
      default:
        return null;
    }
  }
}
