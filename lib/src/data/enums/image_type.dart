enum ImageType { basic, profile, upload }
// attend : 출석함, tardy : 지각, cut : 결석

extension ActionTypeExtention on ImageType {
  String get name {
    switch (this) {
      case ImageType.basic:
        return '기본 이미지';
      case ImageType.profile:
        return '내 프로필';
      case ImageType.upload:
        return '업로드';
      default:
        return null;
    }
  }
}
