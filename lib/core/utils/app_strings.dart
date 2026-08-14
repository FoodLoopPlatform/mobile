import 'lang/ar.dart';
import 'lang/en.dart';

abstract class AppStrings {
  static String currentLanguage = 'ar';

  static void setLocale(String langCode) {
    currentLanguage = langCode;
  }

  static String _getString(String key) {
    if (currentLanguage == 'en') {
      if (enStrings[key] == null) {
        print('missing value language en $key');
      }
      return enStrings[key]!;
    }
    if (arStrings[key] == null) {
      print('missing value language ar $key');
      return 'missing value language ar $key';
    }
    return arStrings[key]!;
  }

  // --- App Name ---
  static String get appName => _getString('appName');

  // --- Welcome / Onboarding ---
  static String get welcomeHeadline => _getString('welcomeHeadline');
  static String get welcomeSubtitle1 => _getString('welcomeSubtitle1');
  static String get welcomeSubtitle2 => _getString('welcomeSubtitle2');
  static String get welcomeSubtitle3 => _getString('welcomeSubtitle3');
  static String get welcomeSubtitle4 => _getString('welcomeSubtitle4');
  static String get welcomeSubtitle5 => _getString('welcomeSubtitle5');
  static String get createAccount => _getString('createAccount');
  static String get login => _getString('login');
  static String get english => _getString('english');

  // --- Create Account ---
  static String get createAccountTitle => _getString('createAccountTitle');
  static String get createAccountSubtitle =>
      _getString('createAccountSubtitle');
  static String get accountTypeLabel => _getString('accountTypeLabel');
  static String get accountTypeUser => _getString('accountTypeUser');
  static String get accountTypeSeller => _getString('accountTypeSeller');
  static String get accountTypeCharity => _getString('accountTypeCharity');
  static String get fullNameLabel => _getString('fullNameLabel');
  static String get fullNameHint => _getString('fullNameHint');
  static String get emailLabel => _getString('emailLabel');
  static String get emailHint => _getString('emailHint');
  static String get passwordLabel => _getString('passwordLabel');
  static String get confirmPasswordLabel => _getString('confirmPasswordLabel');
  static String get passwordStrengthWeak => _getString('passwordStrengthWeak');
  static String get passwordStrengthFair => _getString('passwordStrengthFair');
  static String get passwordStrengthStrong =>
      _getString('passwordStrengthStrong');
  static String get passwordMinLength => _getString('passwordMinLength');
  static String get passwordsDoNotMatch => _getString('passwordsDoNotMatch');
  static String get termsPrefix => _getString('termsPrefix');
  static String get termsOfService => _getString('termsOfService');
  static String get termsAnd => _getString('termsAnd');
  static String get privacyPolicy => _getString('privacyPolicy');
  static String get termsSuffix => _getString('termsSuffix');
  static String get continueButton => _getString('continueButton');
  static String get alreadyHaveAccount => _getString('alreadyHaveAccount');
  static String get logIn => _getString('logIn');
  static String get phoneNumberLabel => _getString('phoneNumberLabel');
  // --- Login ---
  static String get loginTitle => _getString('loginTitle');
  static String get loginSubtitle => _getString('loginSubtitle');
  static String get loginEmailHint => _getString('loginEmailHint');
  static String get passwordHint => _getString('passwordHint');
  static String get forgotPassword => _getString('forgotPassword');
  static String get loginButton => _getString('loginButton');
  static String get noAccountPrefix => _getString('noAccountPrefix');
  static String get joinFoodloop => _getString('joinFoodloop');
  static String get accountPendingBanner => _getString('accountPendingBanner');

  // --- Forgot Password ---
  static String get forgotPasswordTitle => _getString('forgotPasswordTitle');
  static String get forgotPasswordSubtitle =>
      _getString('forgotPasswordSubtitle');
  static String get forgotPasswordEmailHint =>
      _getString('forgotPasswordEmailHint');
  static String get sendResetLink => _getString('sendResetLink');
  static String get backToLogin => _getString('backToLogin');

  // --- Reset Password ---
  static String get resetPasswordTitle => _getString('resetPasswordTitle');
  static String get resetPasswordSubtitle =>
      _getString('resetPasswordSubtitle');
  static String get newPasswordLabel => _getString('newPasswordLabel');
  static String get newPasswordHint => _getString('newPasswordHint');
  static String get confirmNewPasswordLabel =>
      _getString('confirmNewPasswordLabel');
  static String get confirmNewPasswordHint =>
      _getString('confirmNewPasswordHint');
  static String get passwordStrengthLabel =>
      _getString('passwordStrengthLabel');
  static String get passwordStrengthEmpty =>
      _getString('passwordStrengthEmpty');
  static String get passwordStrengthMedium =>
      _getString('passwordStrengthMedium');
  static String get updatePassword => _getString('updatePassword');
  static String get needHelpPrefix => _getString('needHelpPrefix');
  static String get contactSupport => _getString('contactSupport');

  // --- Business Details ---
  static String get businessDetailsTitle => _getString('businessDetailsTitle');
  static String get businessDetailsSubtitle =>
      _getString('businessDetailsSubtitle');
  static String get locationSectionTitle => _getString('locationSectionTitle');
  static String get governorateLabel => _getString('governorateLabel');
  static String get governorateHint => _getString('governorateHint');
  static String get cityLabel => _getString('cityLabel');
  static String get cityHint => _getString('cityHint');
  static String get neighborhoodLabel => _getString('neighborhoodLabel');
  static String get neighborhoodHint => _getString('neighborhoodHint');
  static String get streetLabel => _getString('streetLabel');
  static String get streetHint => _getString('streetHint');
  static String get pinOnMap => _getString('pinOnMap');
  static String get mapHint => _getString('mapHint');
  // --- Business Category ---
  static String get businessInfoSectionTitle =>
      _getString('businessInfoSectionTitle');
  static String get businessCategoryLabel =>
      _getString('businessCategoryLabel');
  static String get businessCategoryHint => _getString('businessCategoryHint');
  static String get categoryFieldRequired =>
      _getString('categoryFieldRequired');
  // Category values sent to the backend (English)
  static String get catSupermarket => _getString('catSupermarket');
  static String get catRestaurant => _getString('catRestaurant');
  static String get catBakery => _getString('catBakery');
  static String get catCafe => _getString('catCafe');
  static String get catHotel => _getString('catHotel');
  static String get catConvenienceStore => _getString('catConvenienceStore');
  static String get catGroceryChain => _getString('catGroceryChain');
  // Category display labels (Arabic)
  static String get catSupermarketLabel => _getString('catSupermarketLabel');
  static String get catRestaurantLabel => _getString('catRestaurantLabel');
  static String get catBakeryLabel => _getString('catBakeryLabel');
  static String get catCafeLabel => _getString('catCafeLabel');
  static String get catHotelLabel => _getString('catHotelLabel');
  static String get catConvenienceStoreLabel =>
      _getString('catConvenienceStoreLabel');
  static String get catGroceryChainLabel => _getString('catGroceryChainLabel');
  static String get legalDocumentsSectionTitle =>
      _getString('legalDocumentsSectionTitle');

  // --- Document API type values (sent to backend) ---
  static String get docTypeCommercialRegistration =>
      _getString('docTypeCommercialRegistration');
  static String get docTypeTaxIdCertificate =>
      _getString('docTypeTaxIdCertificate');
  static String get docTypeStoreFacilityPhoto =>
      _getString('docTypeStoreFacilityPhoto');
  static String get docTypeAssociationCertificate =>
      _getString('docTypeAssociationCertificate');
  static String get docTypeCharityBylaws => _getString('docTypeCharityBylaws');
  static String get docTypeBoardOfDirectorsList =>
      _getString('docTypeBoardOfDirectorsList');

  // --- Merchant document labels (Arabic) ---
  static String get commercialRegLabel => _getString('commercialRegLabel');
  static String get commercialRegSubtitle =>
      _getString('commercialRegSubtitle');
  static String get taxIdLabel => _getString('taxIdLabel');
  static String get taxIdSubtitle => _getString('taxIdSubtitle');
  static String get storeFacilityPhotoLabel =>
      _getString('storeFacilityPhotoLabel');
  static String get storeFacilityPhotoSubtitle =>
      _getString('storeFacilityPhotoSubtitle');

  // --- Charity document labels (Arabic) ---
  static String get associationCertLabel => _getString('associationCertLabel');
  static String get associationCertSubtitle =>
      _getString('associationCertSubtitle');
  static String get charityBylawsLabel => _getString('charityBylawsLabel');
  static String get charityBylawsSubtitle =>
      _getString('charityBylawsSubtitle');
  static String get boardOfDirectorsListLabel =>
      _getString('boardOfDirectorsListLabel');
  static String get boardOfDirectorsListSubtitle =>
      _getString('boardOfDirectorsListSubtitle');

  // Kept for backward compatibility (health cert was replaced by StoreFacilityPhoto)
  static String get healthCertLabel => _getString('healthCertLabel');
  static String get healthCertSubtitle => _getString('healthCertSubtitle');

  static String get statusPending => _getString('statusPending');
  static String get changeLabel => _getString('changeLabel');
  static String get verificationTimeNote => _getString('verificationTimeNote');
  static String get submitForVerification =>
      _getString('submitForVerification');
  static String get dataSecurityNote => _getString('dataSecurityNote');

  // --- Email Verification ---
  static String get emailVerificationTitle =>
      _getString('emailVerificationTitle');
  static String get verificationPendingTitle =>
      _getString('verificationPendingTitle');
  static String get verificationPendingSubtitle =>
      _getString('verificationPendingSubtitle');
  static String get sentToLabel => _getString('sentToLabel');
  static String get expiresInLabel => _getString('expiresInLabel');
  static String get checkMailbox => _getString('checkMailbox');
  static String get resendEmail => _getString('resendEmail');

  // --- Validation ---
  static String get fieldRequired => _getString('fieldRequired');
  static String get invalidEmail => _getString('invalidEmail');
  static String get mustAgreeToTerms => _getString('mustAgreeToTerms');

  // --- Profile ---
  static String get profileTitle => _getString('profileTitle');
  static String get profileEdit => _getString('profileEdit');
  static String get profileName => _getString('profileName');
  static String get profileEmail => _getString('profileEmail');
  static String get profilePhone => _getString('profilePhone');

  // --- Preferences ---
  static String get preferencesTitle => _getString('preferencesTitle');
  static String get languageLabel => _getString('languageLabel');
  static String get languageEn => _getString('languageEn');
  static String get languageAr => _getString('languageAr');
  static String get notificationsLabel => _getString('notificationsLabel');
  static String get orderUpdatesLabel => _getString('orderUpdatesLabel');
  static String get latestOffersLabel => _getString('latestOffersLabel');

  // --- Saved Addresses ---
  static String get savedAddressesTitle => _getString('savedAddressesTitle');
  static String get addNew => _getString('addNew');
  static String get addressDefaultBadge => _getString('addressDefaultBadge');
  static String get addressHomeTitle => _getString('addressHomeTitle');
  static String get addressHomeLine1 => _getString('addressHomeLine1');
  static String get addressHomeLine2 => _getString('addressHomeLine2');
  static String get addressOfficeTitle => _getString('addressOfficeTitle');
  static String get addressOfficeLine1 => _getString('addressOfficeLine1');
  static String get addressOfficeLine2 => _getString('addressOfficeLine2');
  static String get addressOtherTitle => _getString('addressOtherTitle');
  static String get addressEmptyHint => _getString('addressEmptyHint');

  // --- Add / Edit Address ---
  static String get addAddressTitle => _getString('addAddressTitle');
  static String get addressLabelSectionTitle =>
      _getString('addressLabelSectionTitle');
  static String get addressDetailsSectionTitle =>
      _getString('addressDetailsSectionTitle');
  static String get addressTypeCompany => _getString('addressTypeCompany');
  static String get selectCityHint => _getString('selectCityHint');
  static String get districtHint => _getString('districtHint');
  static String get streetNameHint => _getString('streetNameHint');
  static String get buildingNoHint => _getString('buildingNoHint');
  static String get floorHint => _getString('floorHint');
  static String get apartmentNoHint => _getString('apartmentNoHint');
  static String get addressNotesHint => _getString('addressNotesHint');
  static String get saveAddress => _getString('saveAddress');
  static String get editAddressTitle => _getString('editAddressTitle');
  static String get deleteAddressTitle => _getString('deleteAddressTitle');
  static String get deleteAddressMessage => _getString('deleteAddressMessage');
  static String get cancel => _getString('cancel');
  static String get delete => _getString('delete');

  // --- Add Product (Step 1) ---
  static String get addProductTitle => _getString('addProductTitle');
  static String get addProductStepLabel => _getString('addProductStepLabel');
  static String get addProductStepName => _getString('addProductStepName');
  static String get addProductHeadline => _getString('addProductHeadline');
  static String get addProductSubtitle => _getString('addProductSubtitle');
  static String get productPhotosTitle => _getString('productPhotosTitle');
  static String get productPhotosHint => _getString('productPhotosHint');
  static String get productPhotosSelected =>
      _getString('productPhotosSelected');
  static String get productPhotosTip => _getString('productPhotosTip');
  static String get productNameLabel => _getString('productNameLabel');
  static String get productNameHint => _getString('productNameHint');
  static String get productCategoryLabel => _getString('productCategoryLabel');
  static String get productCategoryHint => _getString('productCategoryHint');
  static String get categoriesLoading => _getString('categoriesLoading');
  static String get productPriceLabel => _getString('productPriceLabel');
  static String get productPriceHint => _getString('productPriceHint');
  static String get productQuantityLabel => _getString('productQuantityLabel');
  static String get productDescriptionLabel =>
      _getString('productDescriptionLabel');
  static String get productDescriptionHint =>
      _getString('productDescriptionHint');
  static String get addProductNextStep => _getString('addProductNextStep');
  static String get stepWord => _getString('stepWord');
  static String get stepOfWord => _getString('stepOfWord');

  // --- Add Product (Step 2 — Expiration) ---
  static String get expirationStepName => _getString('expirationStepName');
  static String get expirationTitle => _getString('expirationTitle');
  static String get expirationSubtitle => _getString('expirationSubtitle');
  static String get manualExpiryLabel => _getString('manualExpiryLabel');
  static String get selectDateHint => _getString('selectDateHint');
  static String get verifyViaCamera => _getString('verifyViaCamera');
  static String get verifyViaCameraHint => _getString('verifyViaCameraHint');
  static String get cameraVerifyUnavailable =>
      _getString('cameraVerifyUnavailable');
  static String get sameDateForAll => _getString('sameDateForAll');
  static String get appliesToAllUnits => _getString('appliesToAllUnits');
  static String get individualBatchesTitle =>
      _getString('individualBatchesTitle');
  static String get addAnotherBatch => _getString('addAnotherBatch');
  static String get batchUploadPhoto => _getString('batchUploadPhoto');
  static String get verificationStatusTitle =>
      _getString('verificationStatusTitle');
  static String get productNameStatusLabel =>
      _getString('productNameStatusLabel');
  static String get quantityShort => _getString('quantityShort');
  static String get shelfLifeIndexLabel => _getString('shelfLifeIndexLabel');
  static String get shelfLifeLong => _getString('shelfLifeLong');
  static String get shelfLifeModerate => _getString('shelfLifeModerate');
  static String get shelfLifeShort => _getString('shelfLifeShort');
  static String get shelfLifeExpired => _getString('shelfLifeExpired');
  static String get shelfLifeUnknown => _getString('shelfLifeUnknown');
  static String get batchIntegrityLabel => _getString('batchIntegrityLabel');
  static String get batchIntegrityPending =>
      _getString('batchIntegrityPending');
  static String get verifyDates => _getString('verifyDates');
  static String get verifyDisclaimer => _getString('verifyDisclaimer');

  // --- Camera scanning ---
  static String get scanningTitle => _getString('scanningTitle');
  static String get scanningMessage1 => _getString('scanningMessage1');
  static String get scanningMessage2 => _getString('scanningMessage2');
  static String get scanningMessage3 => _getString('scanningMessage3');
  static String get scanningMessage4 => _getString('scanningMessage4');
  static String get scanStatusLabel => _getString('scanStatusLabel');
  static String get scanStatusAnalyzing => _getString('scanStatusAnalyzing');
  static String get scanElapsedLabel => _getString('scanElapsedLabel');
  static String get scanSecondsSuffix => _getString('scanSecondsSuffix');
  static String get scanSecureFooter => _getString('scanSecureFooter');

  // --- Add Product (Step 3 — Results) ---
  static String get resultsStepName => _getString('resultsStepName');
  static String get resultsTitle => _getString('resultsTitle');
  static String get resultsSubtitle => _getString('resultsSubtitle');
  static String get totalVerifiedLabel => _getString('totalVerifiedLabel');
  static String get unitsWord => _getString('unitsWord');
  static String get verifiedBatchesTitle => _getString('verifiedBatchesTitle');
  static String get unitsConfirmed => _getString('unitsConfirmed');
  static String get issuesTitle => _getString('issuesTitle');
  static String get issueUnverifiedTitle => _getString('issueUnverifiedTitle');
  static String get issueUnverifiedMessage =>
      _getString('issueUnverifiedMessage');
  static String get retakeImage => _getString('retakeImage');
  static String get verificationRateLabel =>
      _getString('verificationRateLabel');
  static String get verificationRateHint => _getString('verificationRateHint');
  static String get saveAsDraft => _getString('saveAsDraft');
  static String get confirmAndPublish => _getString('confirmAndPublish');
  static String get batchPrefix => _getString('batchPrefix');

  // --- Logout ---
  static String get logout => _getString('logout');
  static String get logoutConfirmMessage => _getString('logoutConfirmMessage');
  static String get mapDragHint => _getString('mapDragHint');
  static String get locationServiceDisabled =>
      _getString('locationServiceDisabled');
  static String get locationPermissionDenied =>
      _getString('locationPermissionDenied');
  static String get locationFetchFailed => _getString('locationFetchFailed');
  static String get locatingYou => _getString('locatingYou');
  static String get resolvingAddress => _getString('resolvingAddress');
  static String get cityCairo => _getString('cityCairo');
  static String get cityAlexandria => _getString('cityAlexandria');
  static String get cityGiza => _getString('cityGiza');

  // --- Market / Home ---
  static String get currencyEgp => _getString('currencyEgp');
  static String get marketBrand => _getString('marketBrand');
  static String get activeOrderLabel => _getString('activeOrderLabel');
  static String get activeOrderStatus => _getString('activeOrderStatus');
  static String get categoryBakery => _getString('categoryBakery');
  static String get categoryMeals => _getString('categoryMeals');
  static String get categoryGroceries => _getString('categoryGroceries');
  static String get categoryDesserts => _getString('categoryDesserts');
  static String get categoryBeverages => _getString('categoryBeverages');
  static String get recommendedTitle => _getString('recommendedTitle');
  static String get viewAll => _getString('viewAll');
  static String get nearbyDealsTitle => _getString('nearbyDealsTitle');
  static String get trendingTitle => _getString('trendingTitle');

  // --- Product Details ---
  static String get inStock => _getString('inStock');
  static String get currentOffer => _getString('currentOffer');
  static String get freePickup => _getString('freePickup');
  static String get delivery => _getString('delivery');
  static String get deliveryFee => _getString('deliveryFee');
  static String get reviewsCount => _getString('reviewsCount');
  static String get flashDealExpires => _getString('flashDealExpires');
  static String get saveBadgePrefix => _getString('saveBadgePrefix');
  static String get productDetailsSection =>
      _getString('productDetailsSection');
  static String get productDescription => _getString('productDescription');
  static String get chipCertifiedOrganic => _getString('chipCertifiedOrganic');
  static String get chipZeroPlastic => _getString('chipZeroPlastic');
  static String get chipWithinFiveMiles => _getString('chipWithinFiveMiles');
  static String get pickupLocationTitle => _getString('pickupLocationTitle');
  static String get pickupLocationAddress =>
      _getString('pickupLocationAddress');
  static String get viewOnMap => _getString('viewOnMap');
  static String get whatsInTheBox => _getString('whatsInTheBox');
  static String get boxItem1 => _getString('boxItem1');
  static String get boxItem2 => _getString('boxItem2');
  static String get boxItem3 => _getString('boxItem3');
  static String get boxItem4 => _getString('boxItem4');
  static String get quantityLabel => _getString('quantityLabel');
  static String get addToCart => _getString('addToCart');

  // --- Search ---
  static String get searchHint => _getString('searchHint');
  static String get localHarvestDeals => _getString('localHarvestDeals');
  static String get resultsCountSuffix => _getString('resultsCountSuffix');
  static String get filterSortByPrice => _getString('filterSortByPrice');
  static String get filterRating => _getString('filterRating');
  static String get filterNearby => _getString('filterNearby');
  static String get filterOrganicOnly => _getString('filterOrganicOnly');
  static String get noResultsTitlePrefix => _getString('noResultsTitlePrefix');
  static String get noResultsSubtitle => _getString('noResultsSubtitle');
  static String get browseAllDeals => _getString('browseAllDeals');
  static String get clearAllFilters => _getString('clearAllFilters');
  static String get trendingInArea => _getString('trendingInArea');
  static String get suggestionTomatoes => _getString('suggestionTomatoes');
  static String get suggestionTomatoesDistance =>
      _getString('suggestionTomatoesDistance');
  static String get suggestionSourdough => _getString('suggestionSourdough');
  static String get suggestionSourdoughDistance =>
      _getString('suggestionSourdoughDistance');

  // --- Bottom Navigation ---
  static String get navMarket => _getString('navMarket');
  static String get navOrders => _getString('navOrders');
  static String get navInbox => _getString('navInbox');
  static String get navCart => _getString('navCart');
  static String get navAddListing => _getString('navAddListing');
  static String get navProfile => _getString('navProfile');

  // --- Connection / Errors ---
  static String get systemStatusOffline => _getString('systemStatusOffline');
  static String get connectionLostTitle => _getString('connectionLostTitle');
  static String get connectionLostSubtitle =>
      _getString('connectionLostSubtitle');
  static String get retry => _getString('retry');

  // --- Generic ---
  static String get back => _getString('back');
  static String get loading => _getString('loading');

  // --- Error Messages (repositories / data layer) ---
  static String get errorUnknown => _getString('errorUnknown');
  static String get errorSomethingWentWrong =>
      _getString('errorSomethingWentWrong');
  static String get errorUnexpectedResponse =>
      _getString('errorUnexpectedResponse');
  static String get errorAccountNotVerified =>
      _getString('errorAccountNotVerified');
  static String get errorLoginFailed => _getString('errorLoginFailed');
  static String get errorRegistrationFailed =>
      _getString('errorRegistrationFailed');

  // --- Error Messages (Dio / network layer) ---
  static String get errorConnectionTimeout =>
      _getString('errorConnectionTimeout');
  static String get errorSendTimeout => _getString('errorSendTimeout');
  static String get errorReceiveTimeout => _getString('errorReceiveTimeout');
  static String get errorBadCertificate => _getString('errorBadCertificate');
  static String get errorRequestCancelled =>
      _getString('errorRequestCancelled');
  static String get errorConnectionError => _getString('errorConnectionError');
  static String get errorNoInternet => _getString('errorNoInternet');
  static String get errorUnexpected => _getString('errorUnexpected');
  static String get errorBadRequest => _getString('errorBadRequest');
  static String get errorNotFound => _getString('errorNotFound');
  static String get errorInternalServer => _getString('errorInternalServer');

  // --- Cart & Checkout ---
  static String get checkout => _getString('checkout');
  static String get fulfillment => _getString('fulfillment');
  static String get pickup => _getString('pickup');
  static String get shippingTo => _getString('shippingTo');
  static String get change => _getString('change');
  static String get orderReview => _getString('orderReview');
  static String get items => _getString('items');
  static String get summary => _getString('summary');
  static String get subtotal => _getString('subtotal');
  static String get promoDiscount => _getString('promoDiscount');
  static String get grandTotal => _getString('grandTotal');
  static String get placeOrder => _getString('placeOrder');
  static String get inCart => _getString('inCart');
  static String get cartEmpty => _getString('cartEmpty');
  static String get cartEmptySubtitle => _getString('cartEmptySubtitle');
  static String get browsMarket => _getString('browsMarket');

  // --- Checkout Success ---
  static String get thankYouTitle => _getString('thankYouTitle');
  static String get thankYouSubtitle => _getString('thankYouSubtitle');
  static String get orderReference => _getString('orderReference');
  static String get placedSuccessfully => _getString('placedSuccessfully');
  static String get estimatedReadyTime => _getString('estimatedReadyTime');
  static String get minutes => _getString('minutes');
  static String get pickupDetails => _getString('pickupDetails');
  static String get backToHome => _getString('backToHome');
  static String get errorPlaceOrder => _getString('errorPlaceOrder');

  // --- Support Center ---
  static String get supportCenterTitle => _getString('supportCenterTitle');
  static String get supportCenterButton => _getString('supportCenterButton');
  static String get createTicketTitle => _getString('createTicketTitle');
  static String get createTicketSubtitle => _getString('createTicketSubtitle');
  static String get ticketCategoryLabel => _getString('ticketCategoryLabel');
  static String get ticketCategoryHint => _getString('ticketCategoryHint');
  static String get ticketDescriptionLabel => _getString('ticketDescriptionLabel');
  static String get ticketDescriptionHint => _getString('ticketDescriptionHint');
  static String get submitTicket => _getString('submitTicket');
  static String get recentOrdersLabel => _getString('recentOrdersLabel');
  static String get ticketCategoryOrderIssue => _getString('ticketCategoryOrderIssue');
  static String get ticketCategoryPayment => _getString('ticketCategoryPayment');
  static String get ticketCategoryDelivery => _getString('ticketCategoryDelivery');
  static String get ticketCategoryProductQuality => _getString('ticketCategoryProductQuality');
  static String get ticketCategoryAccount => _getString('ticketCategoryAccount');
  static String get ticketCategoryOther => _getString('ticketCategoryOther');
  static String get inboxEmptyTitle => _getString('inboxEmptyTitle');
  static String get inboxEmptySubtitle => _getString('inboxEmptySubtitle');
  static String get ticketStatusOpen => _getString('ticketStatusOpen');
  static String get ticketStatusClosed => _getString('ticketStatusClosed');
  static String get ticketStatusInProgress => _getString('ticketStatusInProgress');
  static String get ticketDetailsTitle => _getString('ticketDetailsTitle');
  static String get closeTicketLabel => _getString('closeTicketLabel');
  static String get typeMessageHint => _getString('typeMessageHint');
  static String get ticketCreatedSuccess => _getString('ticketCreatedSuccess');
  static String get ticketCreateError => _getString('ticketCreateError');
  static String get replyError => _getString('replyError');
  static String get ordersLoadingError => _getString('ordersLoadingError');

  // --- Orders ---
  static String get ordersTitle => _getString('ordersTitle');
  static String get ordersEmptyTitle => _getString('ordersEmptyTitle');
  static String get ordersEmptySubtitle => _getString('ordersEmptySubtitle');
  static String get orderStatusPending => _getString('orderStatusPending');
  static String get orderStatusCompleted => _getString('orderStatusCompleted');
  static String get orderStatusCancelled => _getString('orderStatusCancelled');
  static String get orderTotalLabel => _getString('orderTotalLabel');
  static String get orderItemsLabel => _getString('orderItemsLabel');

  // --- Review Screen ---
  static String get reviewTitle => _getString('reviewTitle');
  static String get reviewSubtitle => _getString('reviewSubtitle');
  static String get reviewRateLabel => _getString('reviewRateLabel');
  static String get reviewCommentLabel => _getString('reviewCommentLabel');
  static String get reviewCommentHint => _getString('reviewCommentHint');
  static String get reviewSubmit => _getString('reviewSubmit');
  static String get reviewSuccess => _getString('reviewSuccess');
  static String get reviewError => _getString('reviewError');
  static String get leaveReview => _getString('leaveReview');
  static String get yourRecentOrder => _getString('yourRecentOrder');

  // --- Order Status Labels (Merchant) ---
  static String get orderStatusConfirmed => _getString('orderStatusConfirmed');
  static String get orderStatusPreparing => _getString('orderStatusPreparing');
  static String get orderStatusReadyForPickup =>
      _getString('orderStatusReadyForPickup');
  static String get changeStatusLabel => _getString('changeStatusLabel');
  static String get statusUpdateSuccess => _getString('statusUpdateSuccess');
  static String get statusUpdateError => _getString('statusUpdateError');
}
