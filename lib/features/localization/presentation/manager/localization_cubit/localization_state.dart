import 'package:equatable/equatable.dart';

class LocalizationState extends Equatable {
  final String locale;

  const LocalizationState({required this.locale});

  @override
  List<Object> get props => [locale];
}
