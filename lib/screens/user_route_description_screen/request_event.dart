import 'package:equatable/equatable.dart';

abstract class RequestEvent extends Equatable {
  const RequestEvent();

  @override
  List<Object> get props => [];
}

class FetchRequests extends RequestEvent {
  final String routeId;

  const FetchRequests(this.routeId);

  @override
  List<Object> get props => [routeId];
}
