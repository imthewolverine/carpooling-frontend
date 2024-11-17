import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class AddPostState extends Equatable {
  final DateTime? selectedDateTime;
  final LatLng? sourcePoint;
  final String? sourceAddress;
  final LatLng? destinationPoint;
  final String? destinationAddress;
  final String? address;
  final String? description;

  const AddPostState({
    this.selectedDateTime,
    this.sourcePoint,
    this.sourceAddress,
    this.destinationPoint,
    this.destinationAddress,
    this.address,
    this.description,
  });

  AddPostState copyWith({
    DateTime? selectedDateTime,
    LatLng? sourcePoint,
    String? sourceAddress,
    LatLng? destinationPoint,
    String? destinationAddress,
    String? address,
    String? description,
  }) {
    return AddPostState(
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
      sourcePoint: sourcePoint ?? this.sourcePoint,
      sourceAddress: sourceAddress ?? this.sourceAddress,
      destinationPoint: destinationPoint ?? this.destinationPoint,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      address: address ?? this.address,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
    selectedDateTime,
    sourcePoint,
    sourceAddress,
    destinationPoint,
    destinationAddress,
    address,
    description,
  ];
}
