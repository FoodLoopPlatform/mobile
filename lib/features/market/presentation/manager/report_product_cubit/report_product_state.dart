import 'package:equatable/equatable.dart';

abstract class ReportProductState extends Equatable {
  const ReportProductState();

  @override
  List<Object> get props => [];
}

class ReportProductInitial extends ReportProductState {}

class ReportProductLoading extends ReportProductState {}

class ReportProductSuccess extends ReportProductState {}

class ReportProductFailure extends ReportProductState {
  final String errorMessage;

  const ReportProductFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
