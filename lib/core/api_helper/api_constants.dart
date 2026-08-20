class ApiConstants {
  static const String baseUrl = 'https://foodloop.runasp.net/';
  static const String registerEndpoint = 'auth/register';
  static const String loginEndpoint = 'auth/login';
  static const String refreshEndpoint = 'auth/refresh';
  static const String logoutEndpoint = 'auth/logout';
  static const String forgotPasswordEndpoint = 'auth/forgot-password';
  static const String storeDocumentsEndpoint = 'stores/me/documents';
  static const String charityDocumentsEndpoint = 'charities/me/documents';
  static const String storeProductsEndpoint = 'stores/me/products';
  static String storeProductImagesEndpoint(String id) => 'stores/me/products/$id/images';
  static const String ocrScanEndpoint = 'stores/me/products/ocr-scan';

  // --- Notifications ---
  static const String notificationsEndpoint = 'notifications';
  static const String notificationsReadAllEndpoint = 'notifications/read-all';
  static String notificationReadEndpoint(String id) => 'notifications/$id/read';
  static const String deviceTokenEndpoint = 'notifications/device-token';

  static const String categoriesEndpoint = 'categories';
  static const String marketplaceProductsEndpoint = 'marketplace/products';
  static String reportProductEndpoint(String id) => 'marketplace/products/$id/report';

  static const String profileEndpoint = 'users/me';
  static const String addressesEndpoint = 'users/me/addresses';
  static const String walletEndpoint = 'users/me/wallet';

  static const String ordersEndpoint = 'orders';
  static String paymobCheckoutEndpoint(String id) => 'orders/$id/paymob-checkout';
  static String walletCheckoutEndpoint(String id) => 'orders/$id/wallet-checkout';
  static const String storeOrdersEndpoint = 'stores/me/orders';
  static const String reviewsEndpoint = 'reviews';
  static String storeOrderStatusEndpoint(String id) => 'stores/me/orders/$id/status';

  // --- Support Tickets ---
  static const String supportTicketsEndpoint = 'support-tickets';
  static String supportTicketByIdEndpoint(String id) => 'support-tickets/$id';
  static String supportTicketReplyEndpoint(String id) => 'support-tickets/$id/reply';

  // --- Stores ---
  static const String storesEndpoint = 'stores';
  static String storeReviewsEndpoint(String id) => 'stores/$id/reviews';

  static String addressByIdEndpoint(String id) => 'users/me/addresses/$id';
}
