import 'package:carpooling_frontend/models/DriverRequest.dart';
import 'package:equatable/equatable.dart';

abstract class RequestState extends Equatable {
  const RequestState();

  @override
  List<Object> get props => [];
}

class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestLoaded extends RequestState {
  final List<DriverRequest> requests;

  const RequestLoaded(this.requests);

  @override
  List<Object> get props => [requests];
}

class RequestError extends RequestState {
  final String message;

  const RequestError(this.message);

  @override
  List<Object> get props => [message];
}
