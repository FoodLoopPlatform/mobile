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
  // --- Business Category ---
  static const String businessInfoSectionTitle = 'معلومات النشاط التجاري';
  static const String businessCategoryLabel = 'نوع النشاط التجاري';
  static const String businessCategoryHint = 'اختر نوع نشاطك';
  static const String categoryFieldRequired = 'يرجى اختيار نوع النشاط';
  // Category values sent to the backend (English)
  static const String catSupermarket = 'Supermarket';
  static const String catRestaurant = 'Restaurant';
  static const String catBakery = 'Bakery';
  static const String catCafe = 'Cafe';
  static const String catHotel = 'Hotel';
  static const String catConvenienceStore = 'ConvenienceStore';
  static const String catGroceryChain = 'GroceryChain';
  // Category display labels (Arabic)
  static const String catSupermarketLabel = 'سوبر ماركت';
  static const String catRestaurantLabel = 'مطعم';
  static const String catBakeryLabel = 'مخبز';
  static const String catCafeLabel = 'كافيه';
  static const String catHotelLabel = 'فندق';
  static const String catConvenienceStoreLabel = 'متجر قريب';
  static const String catGroceryChainLabel = 'سلسلة بقالة';
  static const String legalDocumentsSectionTitle = 'المستندات القانونية';

  // --- Document API type values (sent to backend) ---
  static const String docTypeCommercialRegistration = 'CommercialRegistration';
  static const String docTypeTaxIdCertificate = 'TaxIdCertificate';
  static const String docTypeStoreFacilityPhoto = 'StoreFacilityPhoto';
  static const String docTypeAssociationCertificate = 'AssociationCertificate';
  static const String docTypeCharityBylaws = 'CharityBylaws';
  static const String docTypeBoardOfDirectorsList = 'BoardOfDirectorsList';

  // --- Merchant document labels (Arabic) ---
  static const String commercialRegLabel = 'السجل التجاري';
  static const String commercialRegSubtitle = 'ملف تسجيل نشط';
  static const String taxIdLabel = 'البطاقة الضريبية';
  static const String taxIdSubtitle = 'مثال: 466-XXX-XXX';
  static const String storeFacilityPhotoLabel = 'صورة المنشأة';
  static const String storeFacilityPhotoSubtitle = 'صورة واضحة لمقر النشاط التجاري';

  // --- Charity document labels (Arabic) ---
  static const String associationCertLabel = 'شهادة تأسيس الجمعية';
  static const String associationCertSubtitle = 'وثيقة الاعتراف الرسمي بالجمعية';
  static const String charityBylawsLabel = 'النظام الأساسي للجمعية';
  static const String charityBylawsSubtitle = 'اللائحة الداخلية للجمعية';
  static const String boardOfDirectorsListLabel = 'قائمة مجلس الإدارة';
  static const String boardOfDirectorsListSubtitle = 'أسماء وتوقيعات أعضاء مجلس الإدارة';

  // Kept for backward compatibility (health cert was replaced by StoreFacilityPhoto)
  static const String healthCertLabel = 'الشهادة الصحية';
  static const String healthCertSubtitle = 'مطلوبة للتعامل مع الأطعمة';

  static const String statusPending = 'قيد الانتظار';
  static const String changeLabel = 'تغيير';
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
  static const String addressNotesHint =
      'ملاحظات / علامات مميزة (مثال: بجوار المسجد)';
  static const String saveAddress = 'حفظ العنوان';
  static const String editAddressTitle = 'تعديل العنوان';
  static const String deleteAddressTitle = 'حذف العنوان';
  static const String deleteAddressMessage =
      'هل أنت متأكد من حذف هذا العنوان؟ لا يمكن التراجع عن هذا الإجراء.';
  static const String cancel = 'إلغاء';
  static const String delete = 'حذف';

  // --- Add Product (Step 1) ---
  static const String addProductTitle = 'إضافة منتج';
  static const String addProductStepLabel = 'الخطوة 1 من 3';
  static const String addProductStepName = 'تفاصيل المنتج';
  static const String addProductHeadline = 'ما الذي تعرضه اليوم؟';
  static const String addProductSubtitle =
      'أدخل البيانات الأساسية لمنتجاتك الطازجة أو المصنوعة يدوياً.';
  static const String productPhotosTitle = 'صور المنتج';
  static const String productPhotosHint =
      'اضغط لرفع صور عالية الجودة. الإضاءة الطبيعية هي الأفضل.';
  static const String productPhotosSelected = 'صورة تم اختيارها';
  static const String productPhotosTip =
      'الأوصاف التفصيلية والصور الواضحة ترفع مبيعاتك بنسبة تصل إلى 40%.';
  static const String productNameLabel = 'اسم المنتج';
  static const String productNameHint = 'مثال: خبز العجين المخمر';
  static const String productCategoryLabel = 'الفئة';
  static const String productCategoryHint = 'اختر فئة المنتج';
  static const String categoriesLoading = 'جارٍ تحميل الفئات...';
  static const String productPriceLabel = 'السعر (ج.م)';
  static const String productPriceHint = '0.00';
  static const String productQuantityLabel = 'الكمية';
  static const String productDescriptionLabel = 'الوصف';
  static const String productDescriptionHint =
      'اذكر المصدر أو المكونات أو طريقة التحضير...';
  static const String addProductNextStep = 'التالي: تفاصيل الصلاحية';
  static const String stepWord = 'الخطوة';
  static const String stepOfWord = 'من';

  // --- Add Product (Step 2 — Expiration) ---
  static const String expirationStepName = 'تفاصيل الصلاحية';
  static const String expirationTitle = 'التحقق من الصلاحية';
  static const String expirationSubtitle =
      'لضمان سلامة الغذاء، نطلب تواريخ صلاحية دقيقة لجميع المنتجات المعروضة.';
  static const String manualExpiryLabel = 'تاريخ الصلاحية';
  static const String selectDateHint = 'اختر التاريخ';
  static const String verifyViaCamera = 'التحقق عبر الكاميرا';
  static const String verifyViaCameraHint =
      'سيقوم الذكاء الاصطناعي بقراءة تاريخ الصلاحية من العبوة.';
  static const String cameraVerifyUnavailable =
      'قراءة التاريخ تلقائياً غير متاحة حالياً.';
  static const String sameDateForAll = 'كل الوحدات لها نفس تاريخ الصلاحية';
  static const String appliesToAllUnits = 'يُطبّق التاريخ على جميع الوحدات:';
  static const String individualBatchesTitle = 'دفعات بتواريخ منفصلة';
  static const String addAnotherBatch = 'إضافة دفعة أخرى';
  static const String batchUploadPhoto = 'رفع صورة';
  static const String verificationStatusTitle = 'حالة التحقق';
  static const String productNameStatusLabel = 'اسم المنتج';
  static const String quantityShort = 'الكمية';
  static const String shelfLifeIndexLabel = 'مؤشر مدة الصلاحية';
  static const String shelfLifeLong = 'مرتفع';
  static const String shelfLifeModerate = 'متوسط';
  static const String shelfLifeShort = 'قصير';
  static const String shelfLifeExpired = 'منتهي الصلاحية';
  static const String shelfLifeUnknown = '--';
  static const String batchIntegrityLabel = 'سلامة الدفعة';
  static const String batchIntegrityPending = 'قيد الموافقة';
  static const String verifyDates = 'تأكيد التواريخ';
  static const String verifyDisclaimer =
      'بالضغط على تأكيد، فإنك تقر بأن هذه المنتجات تستوفي معايير الجودة المعتمدة.';

  // --- Camera scanning ---
  static const String scanningTitle = 'جارٍ التحقق من الصلاحية...';
  static const String scanningMessage1 =
      'يقوم النظام بقراءة تاريخ الصلاحية من العبوة.';
  static const String scanningMessage2 = 'تحليل بنية الحروف للتحقق من الملصق...';
  static const String scanningMessage3 = 'مطابقة التواريخ مع سجلات التوريد...';
  static const String scanningMessage4 = 'التأكد من معايير السلامة المحلية...';
  static const String scanStatusLabel = 'الحالة';
  static const String scanStatusAnalyzing = 'جارٍ التحليل';
  static const String scanElapsedLabel = 'المدة';
  static const String scanSecondsSuffix = 'ث';
  static const String scanSecureFooter = 'تتبع آمن للأغذية';

  // --- Add Product (Step 3 — Results) ---
  static const String resultsStepName = 'النتائج';
  static const String resultsTitle = 'نتائج التحقق';
  static const String resultsSubtitle =
      'انتهى تحليل بيانات الصلاحية الخاصة بمنتجك.';
  static const String totalVerifiedLabel = 'إجمالي الوحدات المؤكدة';
  static const String unitsWord = 'وحدة';
  static const String verifiedBatchesTitle = 'دفعات الصلاحية المؤكدة';
  static const String unitsConfirmed = 'وحدة مؤكدة';
  static const String issuesTitle = 'مشكلات مكتشفة';
  static const String issueUnverifiedTitle = 'وحدات غير مؤكدة';
  static const String issueUnverifiedMessage =
      'لم يتم تأكيد تاريخ صلاحية جميع الوحدات. أضف دفعة أخرى أو عدّل الكميات.';
  static const String retakeImage = 'إعادة التصوير';
  static const String verificationRateLabel = 'نسبة التحقق';
  static const String verificationRateHint =
      'نسبة الوحدات التي تم تأكيد تاريخ صلاحيتها.';
  static const String saveAsDraft = 'حفظ كمسودة';
  static const String confirmAndPublish = 'تأكيد ونشر';
  static const String batchPrefix = 'دفعة';

  // --- Logout ---
  static const String logout = 'تسجيل الخروج';
  static const String logoutConfirmMessage =
      'هل أنت متأكد من تسجيل الخروج من حسابك؟';
  static const String mapDragHint = 'حرّك الخريطة لتحديد موقع التوصيل بدقة.';
  static const String locationServiceDisabled = 'خدمة الموقع غير مُفعّلة على جهازك.';
  static const String locationPermissionDenied = 'تم رفض إذن الوصول إلى الموقع.';
  static const String locationFetchFailed = 'تعذّر تحديد موقعك الحالي.';
  static const String locatingYou = 'جارٍ تحديد موقعك...';
  static const String resolvingAddress = 'جارٍ تحديد العنوان...';
  static const String cityCairo = 'القاهرة';
  static const String cityAlexandria = 'الإسكندرية';
  static const String cityGiza = 'الجيزة';

  // --- Market / Home ---
  static const String currencyEgp = 'ج.م';
  static const String marketBrand = 'فودلوب';
  static const String activeOrderLabel = 'طلب نشط';
  static const String activeOrderStatus = 'يصل خلال 12 دقيقة';
  static const String categoryBakery = 'مخبوزات';
  static const String categoryMeals = 'وجبات';
  static const String categoryGroceries = 'بقالة';
  static const String categoryDesserts = 'حلويات';
  static const String categoryBeverages = 'مشروبات';
  static const String recommendedTitle = 'موصى به لك';
  static const String viewAll = 'عرض الكل';
  static const String nearbyDealsTitle = 'عروض قريبة منك';
  static const String trendingTitle = 'الأكثر رواجاً';

  // --- Product Details ---
  static const String inStock = 'متوفر';
  static const String currentOffer = 'العرض الحالي';
  static const String freePickup = 'استلام مجاني';
  static const String delivery = 'توصيل';
  static const String deliveryFee = 'رسوم 25 ج.م';
  static const String reviewsCount = 'تقييم';
  static const String flashDealExpires = 'ينتهي العرض السريع خلال';
  static const String saveBadgePrefix = 'وفّر';
  static const String productDetailsSection = 'تفاصيل المنتج';
  static const String productDescription =
      'باقة الفائض المنسّقة هذه تضم مزيجاً متنوعاً من الأوراق الخضراء الموسمية المحصودة صباح اليوم من مزرعتنا المائية. تحتوي كل حقيبة على ما يقارب كيلوغرام من المنتجات المتنوعة، وعادةً ما تشمل الكرنب واللفت والخس والكزبرة أو البقدونس. باختيارك لهذه الباقة، تساعدنا على تقليل هدر الطعام مع الاستمتاع بأجود أنواع التغذية الطازجة.';
  static const String chipCertifiedOrganic = 'عضوي معتمد';
  static const String chipZeroPlastic = 'تغليف خالٍ من البلاستيك';
  static const String chipWithinFiveMiles = 'ضمن 5 أميال';
  static const String pickupLocationTitle = 'موقع الاستلام';
  static const String pickupLocationAddress = '1242 شارع جرينواي، سبرينجفيلد';
  static const String viewOnMap = 'عرض على الخريطة';
  static const String whatsInTheBox = 'ماذا يوجد في الصندوق؟';
  static const String boxItem1 = 'حزمتان من الكرنب المجعّد';
  static const String boxItem2 = 'كيس سبانخ صغير 150 جم';
  static const String boxItem3 = 'رأس خس أحمر';
  static const String boxItem4 = 'حزمة أعشاب موسمية';
  static const String quantityLabel = 'الكمية';
  static const String addToCart = 'أضف إلى العربة';

  // --- Search ---
  static const String searchHint = 'ابحث عن فائض الطعام المحلي...';
  static const String localHarvestDeals = 'عروض الحصاد المحلي';
  static const String resultsCountSuffix = 'نتيجة';
  static const String filterSortByPrice = 'ترتيب حسب السعر';
  static const String filterRating = 'التقييم';
  static const String filterNearby = 'قريب';
  static const String filterOrganicOnly = 'عضوي فقط';
  static const String noResultsTitlePrefix = 'لا توجد نتائج لـ';
  static const String noResultsSubtitle =
      'جرّب تعديل الفلاتر أو البحث عن شيء آخر قريب منك.';
  static const String browseAllDeals = 'تصفح كل العروض';
  static const String clearAllFilters = 'مسح كل الفلاتر';
  static const String trendingInArea = 'الأكثر رواجاً في منطقتك';
  static const String suggestionTomatoes = 'طماطم هيرلوم';
  static const String suggestionTomatoesDistance = '2.4 كم';
  static const String suggestionSourdough = 'رغيف خبز مخمّر';
  static const String suggestionSourdoughDistance = '0.8 كم';

  // --- Bottom Navigation ---
  static const String navMarket = 'السوق';
  static const String navOrders = 'الطلبات';
  static const String navInbox = 'الرسائل';
  static const String navCart = 'العربة';
  static const String navAddListing = 'إضافة';
  static const String navProfile = 'الملف الشخصي';

  // --- Connection / Errors ---
  static const String systemStatusOffline = 'حالة النظام: غير متصل';
  static const String connectionLostTitle = 'عذراً! انقطع الاتصال';
  static const String connectionLostSubtitle =
      'نواجه مشكلة في الوصول إلى شبكتنا. يرجى التحقق من اتصالك بالإنترنت أو حالة الشبكة اللاسلكية لمتابعة استكشاف المنتجات القريبة منك.';
  static const String retry = 'إعادة المحاولة';

  // --- Generic ---
  static const String back = 'رجوع';
  static const String loading = 'جاري التحميل...';
}
