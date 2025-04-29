/// Represents different types of notifications in the application.
/// Each notification type has an associated integer ID.
enum NotificationType {
  /// Default notification type for unknown cases
  unknown(0),

  /// Partner-related notifications
  partner(1),

  /// Community-related notifications
  community(2),

  /// Product-related notifications
  product(3),

  /// Community detail notifications
  communityDetail(4),

  /// Partner connect session notifications
  partnerConnectSesh(5),

  /// Temporary votes notifications
  temporaryVotes(6),

  /// Deadline to vote notifications
  deadlineToVote(7),

  /// Purchase order notifications
  purchaseOrder(8),

  /// Indicates when a user levels up based on stoyCoins
  levelUp(9),

  /// StoyCoins and NFT earned notifications
  stoyCoinsAndNftEarned(10),

  /// StoyCoins earned by login notifications
  stoyCoinsEarnedByLogin(11),

  /// StoyCoins earned by opening the app notifications
  stoyCoinsEarnedByOpenApp(12),

  /// StoyCoins earned by watching a video notifications
  stoyCoinsEarnedByWatchVideo(13),

  /// StoyCoins earned by buying an NFT notifications
  stoyCoinsEarnedByBuyNFT(14),

  /// StoyCoins earned by buying a product notifications
  stoyCoinsEarnedByBuyProduct(15),

  /// StoyCoins earned by buying an experience notifications
  stoyCoinsEarnedByBuyExperience(16),

  /// StoyCoins earned by following an artist partner notifications
  stoyCoinsEarnedByArtistPartnerFollow(17),

  /// StoyCoins earned by attending an artist partner session notifications
  stoyCoinsEarnedByArtistPartnerSesh(18),

  /// StoyCoins earned by purchasing an NFT notifications
  stoCoinsEarnedByPurchaseNFT(19),

  /// StoyCoins earned by login and opening the app notifications
  stoyCoinsEarnedByLoginAndOpenApp(20),

  /// Onboarding completed notifications
  onboardingCompleted(21),

  /// Messages notifications
  messages(22),

  /// Home notifications
  home(23),

  /// Notifications notifications
  notifications(24),

  /// Edit profile notifications
  editProfile(25),

  /// Shopping history products notifications
  shoppingHistoryProducts(26),

  /// Shopping history experiences notifications
  shoppingHistoryExperiences(27),

  /// Communities pages notifications
  communitiesPages(28),

  /// Wallet notifications
  wallet(29),

  /// Wallet shop notifications
  walletShop(30),

  /// Wallet shop purchase info notifications
  walletShopPurchaseInfo(31),

  /// StoyCoins earned by profile updated notifications
  stoyCoinsEarnedByProfileUpdated(32),

  /// StoyCoins earned by opening the app and completing profile notifications
  stoyCoinsEarnedByOpenAppAndCompleteProfile(33),

  /// StoyCoins earned by sharing a video notifications
  stoyCoinsEarnedBySharedVideo(34),

  /// Generic notifications
  generic(99);

  /// Creates a notification type with the specified ID.
  const NotificationType(this.id);

  /// The unique identifier for this notification type.
  final int id;

  /// Internal mapping of IDs to NotificationType values.
  static final Map<int, NotificationType> _map = {
    for (var type in NotificationType.values) type.id: type,
  };

  /// Creates a NotificationType from an integer value.
  ///
  /// @param value The integer ID of the notification type
  /// @return The corresponding NotificationType, or NotificationType.unknown if the ID is invalid
  static NotificationType fromInt(int? value) =>
      _map[value] ?? NotificationType.unknown;
}
