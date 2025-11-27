enum DeploymentEnvironment { local, dev, prod }

class AppConstants {
  // Other constant classes
  static final Roles roles = Roles();
  static final AuctionStatuses auctionStatuses = AuctionStatuses();
  static final Banners banners = Banners();
}

// User roles class
class Roles {
  // Fields
  final String dealer = 'Dealer';
  final String customer = 'Customer';
  final String salesManager = 'Sales Manager';
  final String admin = 'Admin';

  final String userStatusPending = 'Pending';
  final String userStatusApproved = 'Approved';
  final String userStatusRejected = 'Rejected';

  List<String> get all => [dealer, customer, salesManager, admin];
}

// Auction statuses class
class AuctionStatuses {
  final String all = 'all';
  final String upcoming = 'upcoming';
  final String live = 'live';
  final String otobuy = 'otobuy';
  final String marketplace = 'marketplace';
  final String liveAuctionEnded = 'liveAuctionEnded';
  final String sold = 'sold';
  final String otobuyEnded = 'otobuyEnded';
  final String removed = 'removed';
}

// Banners class
class Banners {
  final String active = 'Active';
  final String inactive = 'Inactive';
  final String header = 'Header';
  final String footer = 'Footer';
}
