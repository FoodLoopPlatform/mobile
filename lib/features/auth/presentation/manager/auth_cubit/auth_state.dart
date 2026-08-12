import 'package:equatable/equatable.dart';
import 'package:foodloop/core/enums/account_type_enum.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final String email;
  const AuthSuccess({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthSellerSuccess extends AuthState {
  const AuthSellerSuccess();
}

class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}

class AuthFail extends AuthState {
  final String message;
  final DateTime timestamp;
  AuthFail({required this.message}) : timestamp = DateTime.now();

  @override
  List<Object?> get props => [message, timestamp];
}

class AuthAccountTypeChanged extends AuthState {
  final AccountType accountType;
  const AuthAccountTypeChanged({required this.accountType});

  @override
  List<Object?> get props => [accountType];
}
