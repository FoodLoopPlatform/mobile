class ApiConstants {
  static const String baseUrl = 'https://foodloop.runasp.net/';
  static const String registerEndpoint = 'auth/register';
  static const String loginEndpoint = 'auth/login';
  static const String refreshEndpoint = 'auth/refresh';
  static const String logoutEndpoint = 'auth/logout';
  static const String uploadDocumentsEndpoint = 'stores/me/documents';

  static const String categoriesEndpoint = 'categories';

  static const String profileEndpoint = 'users/me';
  static const String addressesEndpoint = 'users/me/addresses';

  static String addressByIdEndpoint(String id) => 'users/me/addresses/$id';
}
