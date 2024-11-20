import 'package:equatable/equatable.dart';

abstract class RouteDescriptionEvent extends Equatable {
  const RouteDescriptionEvent();

  @override
  List<Object> get props => [];
}

class SubmitJobRequest extends RouteDescriptionEvent {
  final String adId;

  const SubmitJobRequest(this.adId);

  @override
  List<Object> get props => [adId];
}

class LaunchPhone extends RouteDescriptionEvent {
  final String adId;

  const LaunchPhone(this.adId);

  @override
  List<Object> get props => [adId];
}
