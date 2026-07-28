abstract class AppStrings {
  // --- App Name ---
  static const String appName = 'FoodLoop';

  // --- Welcome / Onboarding ---
  static const String welcomeHeadline = 'نقضي على هدر الطعام في مصر.';
  static const String welcomeSubtitle1 = 'نحول ';
  static const String welcomeSubtitle2 = 'الفائض';
  static const String welcomeSubtitle3 =
      ' إلى فرصة. نربط الشركات التي لديها فائض من الطعام بالمستهلكين الباحثين عن ';
  static const String welcomeSubtitle4 = 'خيارات طازجة وبأسعار معقولة';
  static const String welcomeSubtitle5 = ' في الوقت الفعلي.';
  static const String createAccount = 'إنشاء حساب';
  static const String login = 'تسجيل الدخول';
  static const String english = 'English';

  // --- Create Account ---
  static const String createAccountTitle = 'إنشاء حساب';
  static const String createAccountSubtitle =
      'انضم إلى شبكتنا لتقليل الخسائر الاقتصادية وجعل الطعام الطازج في متناول الجميع في مصر.';
  static const String accountTypeLabel = 'نوع الحساب';
  static const String accountTypeUser = 'مستخدم';
  static const String accountTypeSeller = 'بائع';
  static const String accountTypeCharity = 'جمعية خيرية';
  static const String fullNameLabel = 'الاسم الكامل';
  static const String fullNameHint = 'أحمد محمود';
  static const String emailLabel = 'البريد الإلكتروني';
  static const String emailHint = 'a.mahmoud@example.com';
  static const String passwordLabel = 'كلمة المرور';
  static const String confirmPasswordLabel = 'تأكيد كلمة المرور';
  static const String passwordStrengthWeak = 'ضعيفة';
  static const String passwordStrengthFair = 'مقبولة';
  static const String passwordStrengthStrong = 'قوية';
  static const String passwordMinLength =
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل.';
  static const String passwordsDoNotMatch = 'كلمات المرور غير متطابقة.';
  static const String termsPrefix = 'أوافق على ';
  static const String termsOfService = 'شروط الخدمة';
  static const String termsAnd = ' و ';
  static const String privacyPolicy = 'سياسة الخصوصية';
  static const String termsSuffix = '.';
  static const String continueButton = 'متابعة';
  static const String alreadyHaveAccount = 'لديك حساب بالفعل؟ ';
  static const String logIn = 'تسجيل الدخول';
  static const String phoneNumberLabel = 'رقم الهاتف';
  // --- Login ---
  static const String loginTitle = 'مرحباً بعودتك';
  static const String loginSubtitle =
      'سجل دخولك لإدارة الفائض والمساعدة في جعل الطعام الطازج متاحاً في جميع أنحاء مصر.';
  static const String loginEmailHint = 'logistics@foodloop.com';
  static const String passwordHint = '••••••••';
  static const String forgotPassword = 'نسيت كلمة المرور؟';
  static const String loginButton = 'تسجيل الدخول';
  static const String noAccountPrefix = "ليس لديك حساب؟ ";
  static const String joinFoodloop = 'انضم إلى فودلوب.';
  static const String accountPendingBanner =
      'قيد الانتظار: الحساب قيد المراجعة حالياً';

  // --- Forgot Password ---
  static const String forgotPasswordTitle = 'نسيت كلمة المرور؟';
  static const String forgotPasswordSubtitle =
      "أدخل البريد الإلكتروني المرتبط بحسابك وسنرسل لك رابطاً آمناً لإعادة تعيين كلمة المرور.";
  static const String forgotPasswordEmailHint = 'name@example.com';
  static const String sendResetLink = 'إرسال رابط إعادة التعيين';
  static const String backToLogin = 'العودة لتسجيل الدخول';

  // --- Reset Password ---
  static const String resetPasswordTitle = 'إعادة تعيين كلمة المرور';
  static const String resetPasswordSubtitle =
      'اختر كلمة مرور قوية وجديدة للحفاظ على أمان حساب فودلوب الخاص بك.';
  static const String newPasswordLabel = 'كلمة المرور الجديدة';
  static const String newPasswordHint = 'أدخل 8 أحرف على الأقل';
  static const String confirmNewPasswordLabel = 'تأكيد كلمة المرور الجديدة';
  static const String confirmNewPasswordHint = 'أعد إدخال كلمة المرور الجديدة';
  static const String passwordStrengthLabel = 'قوة كلمة المرور';
  static const String passwordStrengthEmpty = '--';
  static const String passwordStrengthMedium = 'متوسطة';
  static const String updatePassword = 'تحديث كلمة المرور';
  static const String needHelpPrefix = 'تحتاج مساعدة؟ ';
  static const String contactSupport = 'اتصل بالدعم';

  // --- Business Details ---
  static const String businessDetailsTitle = 'تفاصيل العمل';
  static const String businessDetailsSubtitle =
      'ساعدنا في التحقق من مؤسستك لبدء تقليل هدر الطعام. نحن نضمن أن جميع شركائنا يستوفون معايير السلامة والمعايير القانونية المحلية.';
  static const String locationSectionTitle = 'الموقع';
  static const String governorateLabel = 'المحافظة';
  static const String governorateHint = 'اختر المحافظة';
  static const String cityLabel = 'المدينة';
  static const String cityHint = 'اختر المدينة';
  static const String neighborhoodLabel = 'الحي';
  static const String neighborhoodHint = 'مثال: المعادي';
  static const String streetLabel = 'الشارع';
  static const String streetHint = 'مثال: شارع 9';
  static const String pinOnMap = 'تحديد على الخريطة';
  static const String mapHint =
      'الإحداثيات عالية الدقة تساعد فرق الخدمات اللوجستية في العثور عليك بشكل أسرع.';
  static const String legalDocumentsSectionTitle = 'المستندات القانونية';
  static const String taxIdLabel = 'البطاقة الضريبية';
  static const String taxIdSubtitle = 'مثال: 466-XXX-XXX';
  static const String commercialRegLabel = 'السجل التجاري';
  static const String commercialRegSubtitle = 'ملف تسجيل نشط';
  static const String healthCertLabel = 'الشهادة الصحية';
  static const String healthCertSubtitle = 'مطلوبة للتعامل مع الأطعمة';
  static const String statusPending = 'قيد الانتظار';
  static const String verificationTimeNote =
      'تستغرق عملية التحقق عادةً من 24 إلى 48 ساعة. سيتم إعلامك عبر البريد الإلكتروني بمجرد الموافقة.';
  static const String submitForVerification = 'إرسال للتحقق';
  static const String dataSecurityNote =
      'بياناتك مشفرة ويتم التعامل معها بأمان تام.';

  // --- Email Verification ---
  static const String emailVerificationTitle = 'التحقق من البريد الإلكتروني';
  static const String verificationPendingTitle = 'التحقق قيد الانتظار';
  static const String verificationPendingSubtitle =
      "لقد أرسلنا رابطاً آمناً للتحقق من حسابك. أنت على بعد خطوة واحدة من مساعدتنا في تقليل هدر الطعام وتحسين القدرة على تحمل التكاليف.";
  static const String sentToLabel = 'أُرسل إلى';
  static const String expiresInLabel = 'تنتهي الصلاحية في';
  static const String checkMailbox = 'تحقق من صندوق الوارد';
  static const String resendEmail = 'إعادة إرسال البريد';

  // --- Validation ---
  static const String fieldRequired = 'هذا الحقل مطلوب.';
  static const String invalidEmail = 'الرجاء إدخال بريد إلكتروني صحيح.';
  static const String mustAgreeToTerms = 'يجب الموافقة على الشروط للمتابعة.';

  // --- Profile ---
  static const String profileTitle = 'الملف الشخصي';
  static const String profileEdit = 'تعديل';
  static const String profileName = 'أحمد منصور';
  static const String profileEmail = 'ahmed@foodloop.com';
  static const String profilePhone = '+20 100 123 4567';

  // --- Preferences ---
  static const String preferencesTitle = 'التفضيلات';
  static const String languageLabel = 'اللغة';
  static const String languageEn = 'EN';
  static const String languageAr = 'AR';
  static const String notificationsLabel = 'الإشعارات';
  static const String orderUpdatesLabel = 'تحديثات الطلبات';
  static const String latestOffersLabel = 'أحدث العروض';

  // --- Saved Addresses ---
  static const String savedAddressesTitle = 'العناوين المحفوظة';
  static const String addNew = 'إضافة جديد';
  static const String addressDefaultBadge = 'الافتراضي';
  static const String addressHomeTitle = 'المنزل';
  static const String addressHomeLine1 = 'المعادي، شارع 9، عمارة 12';
  static const String addressHomeLine2 = 'القاهرة، مصر';
  static const String addressOfficeTitle = 'العمل';
  static const String addressOfficeLine1 = 'القاهرة الجديدة، التجمع الخامس';
  static const String addressOfficeLine2 = 'المنطقة الصناعية';
  static const String addressOtherTitle = 'عنوان آخر';
  static const String addressEmptyHint =
      'أضف مواقع لتسريع عملية توصيل طعامك المحلي.';

  // --- Add / Edit Address ---
  static const String addAddressTitle = 'إضافة عنوان جديد';
  static const String addressLabelSectionTitle = 'تصنيف العنوان';
  static const String addressDetailsSectionTitle = 'تفاصيل العنوان';
  static const String addressTypeCompany = 'شركة';
  static const String selectCityHint = 'اختر المدينة';
  static const String districtHint = 'الحي';
  static const String streetNameHint = 'اسم الشارع';
  static const String buildingNoHint = 'رقم المبنى';
  static const String floorHint = 'الطابق';
  static const String apartmentNoHint = 'رقم الشقة';
  static const String addressNotesHint = 'ملاحظات / علامات مميزة (مثال: بجوار المسجد)';
  static const String saveAddress = 'حفظ العنوان';
  static const String mapDragHint = 'حرّك الخريطة لتحديد موقع التوصيل بدقة.';
  static const String cityCairo = 'القاهرة';
  static const String cityAlexandria = 'الإسكندرية';
  static const String cityGiza = 'الجيزة';

  // --- Bottom Navigation ---
  static const String navMarket = 'السوق';
  static const String navOrders = 'الطلبات';
  static const String navCart = 'العربة';
  static const String navProfile = 'الملف الشخصي';

  // --- Generic ---
  static const String back = 'رجوع';
  static const String loading = 'جاري التحميل...';
}
