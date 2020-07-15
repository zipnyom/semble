enum EventType { myclass, notice, comment, vote, quiz, gallery, message }

extension EventTypeExtention on EventType {
  String get name {
    switch (this) {
      case EventType.myclass:
        return '진행중인 수업';
      case EventType.notice:
        return '새 게시물';
      case EventType.comment:
        return '댓글';
      case EventType.vote:
        return '투표';
      case EventType.quiz:
        return '퀴즈';
      case EventType.gallery:
        return '갤러리';
      case EventType.message:
        return "메시지";
      default:
        return null;
    }
  }
}
