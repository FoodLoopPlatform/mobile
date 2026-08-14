class ApiConstants {
  static const String baseUrl = 'https://foodloop.runasp.net/';
  static const String registerEndpoint = 'auth/register';
  static const String loginEndpoint = 'auth/login';
  static const String refreshEndpoint = 'auth/refresh';
  static const String logoutEndpoint = 'auth/logout';
  static const String storeDocumentsEndpoint = 'stores/me/documents';
  static const String charityDocumentsEndpoint = 'charities/me/documents';
  static const String storeProductsEndpoint = 'stores/me/products';
  static String storeProductImagesEndpoint(String id) => 'stores/me/products/$id/images';

  static const String categoriesEndpoint = 'categories';
  static const String marketplaceProductsEndpoint = 'marketplace/products';

  static const String profileEndpoint = 'users/me';
  static const String addressesEndpoint = 'users/me/addresses';

  static const String ordersEndpoint = 'orders';
  static const String storeOrdersEndpoint = 'stores/me/orders';
  static const String reviewsEndpoint = 'reviews';
  static String storeOrderStatusEndpoint(String id) => 'stores/me/orders/$id/status';

  // --- Support Tickets ---
  static const String supportTicketsEndpoint = 'support-tickets';
  static String supportTicketByIdEndpoint(String id) => 'support-tickets/$id';
  static String supportTicketReplyEndpoint(String id) => 'support-tickets/$id/reply';

  static String addressByIdEndpoint(String id) => 'users/me/addresses/$id';
}
