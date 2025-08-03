import 'package:equatable/equatable.dart';

sealed class RemoteState extends Equatable {}

class RemoteStateNone extends RemoteState {
  @override
  List<Object?> get props => [];
}

class RemoteStateLoading extends RemoteState {
  @override
  List<Object?> get props => [];
}

class RemoteStateError extends RemoteState {
  final String error;

  RemoteStateError(this.error);

  @override
  List<Object?> get props => [error];
}

class RemoteStateSuccess<T> extends RemoteState {
  final T data;

  RemoteStateSuccess(this.data);

  @override
  List<Object?> get props => [data];
}
