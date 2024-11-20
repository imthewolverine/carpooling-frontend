import 'package:equatable/equatable.dart';

abstract class RouteDescriptionState extends Equatable {
  const RouteDescriptionState();

  @override
  List<Object> get props => [];
}

class RouteDescriptionInitial extends RouteDescriptionState {}

class JobRequestLoading extends RouteDescriptionState {}

class JobRequestSuccess extends RouteDescriptionState {}

class JobRequestError extends RouteDescriptionState {
  final String message;

  const JobRequestError(this.message);

  @override
  List<Object> get props => [message];
}
