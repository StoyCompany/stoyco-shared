enum NotificationType {
  unknown(0),
  partner(1),
  community(2),
  product(3),
  communityDetail(4);

  const NotificationType(this.id);
  final int id;

  static NotificationType fromInt(int? value) {
    switch (value) {
      case 1:
        return NotificationType.partner;
      case 2:
        return NotificationType.community;
      case 3:
        return NotificationType.product;
      case 4:
        return NotificationType.communityDetail;
      default:
        return NotificationType.unknown;
    }
  }
}
