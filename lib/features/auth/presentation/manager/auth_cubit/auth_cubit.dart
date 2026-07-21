import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/enums/account_type_enum.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  AccountType selectedAccountType = AccountType.user;

  void changeAccountType(AccountType type) {
    selectedAccountType = type;
    emit(AuthAccountTypeChanged(accountType: type));
  }

  /// Simulates registration. Replace with real API call later.
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required AccountType accountType,
  }) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(seconds: 1)); // TODO: replace with API

    if (accountType == AccountType.seller) {
      emit(const AuthSellerSuccess());
    } else {
      emit(AuthSuccess(email: email));
    }
  }

  /// Simulates business details submission. Replace with real API call later.
  Future<void> submitBusinessDetails() async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(seconds: 1)); // TODO: replace with API
    emit(const AuthSuccess(email: ''));
  }

  /// Simulates resending verification email.
  Future<void> resendVerification(String email) async {
    // TODO: connect to API
  }
}
