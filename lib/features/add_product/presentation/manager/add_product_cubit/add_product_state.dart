import 'package:equatable/equatable.dart';

abstract class AddProductState extends Equatable {
  const AddProductState();

  @override
  List<Object> get props => [];
}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {}

class AddProductFail extends AddProductState {
  final String message;
  final int timestamp;

  AddProductFail(this.message) : timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object> get props => [message, timestamp];
}
