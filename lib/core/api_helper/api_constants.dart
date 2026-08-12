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

  static String addressByIdEndpoint(String id) => 'users/me/addresses/$id';
}
