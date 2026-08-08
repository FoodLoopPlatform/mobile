import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/secure_storage_helper.dart';

import 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit(String initialLocale)
      : super(LocalizationState(locale: initialLocale)) {
    AppStrings.setLocale(initialLocale);
  }

  Future<void> changeLanguage(String langCode) async {
    if (state.locale != langCode) {
      AppStrings.setLocale(langCode);
      await SecureStorageHelper.saveLanguage(langCode);
      emit(LocalizationState(locale: langCode));
    }
  }
}
