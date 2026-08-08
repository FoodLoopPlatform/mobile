import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/enums/account_type_enum.dart';
import 'package:foodloop/core/errors/errors.dart';
import 'package:foodloop/features/auth/data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  
  AuthCubit(this._authRepository) : super(const AuthInitial());

  // Cached registration fields
  String _registerFullName = '';
  String _registerEmail = '';
  String _registerPassword = '';
  String _registerPhone = '';
  
  AccountType selectedAccountType = AccountType.user;

  Future<void> logout() async {
    emit(const AuthLoading());
    await _authRepository.logout();
    _clearDrafts();
    emit(const AuthLoggedOut());
  }

  /// Half-finished sign-up state must not survive into the next session.
  void _clearDrafts() {
    _registerFullName = '';
    _registerEmail = '';
    _registerPassword = '';
    _registerPhone = '';
    selectedAccountType = AccountType.user;
    draftGovernorate = null;
    draftCity = null;
    draftNeighborhood = '';
    draftStreet = '';
    draftCategory = null;
    draftDocuments = {};
  }

  // Business-details draft (persisted across back/forward navigation)
  String? draftGovernorate;
  String? draftCity;
  String draftNeighborhood = '';
  String draftStreet = '';
  String? draftCategory;
  Map<String, File?> draftDocuments = {};

  void saveBusinessDraft({
    String? governorate,
    String? city,
    String? neighborhood,
    String? street,
    String? category,
    Map<String, File?>? documents,
  }) {
    draftGovernorate = governorate;
    draftCity = city;
    draftNeighborhood = neighborhood ?? '';
    draftStreet = street ?? '';
    draftCategory = category;
    if (documents != null) draftDocuments = documents;
  }

  void changeAccountType(AccountType type) {
    selectedAccountType = type;
    emit(AuthAccountTypeChanged(accountType: type));
  }

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      await _authRepository.login(email, password);
      emit(AuthSuccess(email: email));
    } on Errors catch (e) {
      emit(AuthFail(message: e.errMessage));
    } catch (e) {
      emit(AuthFail(message: e.toString()));
    }
  }

  void proceedToBusinessDetails({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) {
    _registerFullName = fullName;
    _registerEmail = email;
    _registerPassword = password;
    _registerPhone = phoneNumber;
    
    // For Sellers and Charities, we just navigate to the next screen.
    if (selectedAccountType == AccountType.seller || selectedAccountType == AccountType.charity) {
      emit(const AuthSellerSuccess());
    } else {
      // For Users, register directly
      register(role: selectedAccountType.toBackendRole());
    }
  }

  Future<void> register({
    required String role,
    String? businessName,
    String? businessCategory,
    Map<String, File?> documentFiles = const {},
  }) async {
    emit(const AuthLoading());
    try {
      await _authRepository.register(
        name: _registerFullName,
        email: _registerEmail,
        password: _registerPassword,
        phoneNumber: _registerPhone,
        role: role,
        businessName: businessName,
        businessCategory: businessCategory,
        documentFiles: documentFiles,
      );
      emit(AuthSuccess(email: _registerEmail));
    } on Errors catch (e) {
      emit(AuthFail(message: e.errMessage));
    } catch (e) {
      emit(AuthFail(message: e.toString()));
    }
  }

  /// Simulates resending verification email.
  Future<void> resendVerification(String email) async {
    // TODO: connect to API
  }
}
