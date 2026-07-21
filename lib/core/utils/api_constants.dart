//Dummy
abstract class ApiConstants {
  // --- Base URL ---
  static const String baseUrl = 'https://api.foodloop.app/v1';

  // --- Auth Endpoints ---
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String verifyEmailEndpoint = '/auth/verify-email';
  static const String resendVerificationEndpoint = '/auth/resend-verification';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';

  // --- User Endpoints ---
  static const String userProfileEndpoint = '/users/profile';

  // --- Business Endpoints ---
  static const String businessVerificationEndpoint = '/business/verify';
  static const String uploadDocumentEndpoint = '/business/documents/upload';

  // --- Listings Endpoints ---
  static const String listingsEndpoint = '/listings';

  // --- Connection Timeout ---
  static const int connectTimeout = 15000; // ms
  static const int receiveTimeout = 15000; // ms
}
