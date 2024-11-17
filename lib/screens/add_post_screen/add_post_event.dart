import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

abstract class AddPostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickDateTimeEvent extends AddPostEvent {
  final DateTime selectedDateTime;

  PickDateTimeEvent(this.selectedDateTime);

  @override
  List<Object?> get props => [selectedDateTime];
}

class SelectSourceEvent extends AddPostEvent {
  final LatLng sourcePoint;
  final String sourceAddress;

  SelectSourceEvent(this.sourcePoint, this.sourceAddress);

  @override
  List<Object?> get props => [sourcePoint, sourceAddress];
}

class SelectDestinationEvent extends AddPostEvent {
  final LatLng destinationPoint;
  final String destinationAddress;

  SelectDestinationEvent(this.destinationPoint, this.destinationAddress);

  @override
  List<Object?> get props => [destinationPoint, destinationAddress];
}

class SaveAdditionalInfoEvent extends AddPostEvent {
  final String address;
  final String description;

  SaveAdditionalInfoEvent(this.address, this.description);

  @override
  List<Object?> get props => [address, description];
}
