import 'package:equatable/equatable.dart';
import '../../models/route.dart';

class DriverHomeState extends Equatable {
  const DriverHomeState();

  @override
  List<Object> get props => [];
}

class DriverHomeInitial extends DriverHomeState {}

class DriverHomeLoading extends DriverHomeState {}

class DriverHomeLoaded extends DriverHomeState {
  final List<RouteModel> ads;
  final bool isSearchResult;

  const DriverHomeLoaded({required this.ads, this.isSearchResult = false});

  @override
  List<Object> get props => [ads, isSearchResult];
}

class DriverHomeError extends DriverHomeState {
  final String message;

  const DriverHomeError(this.message);

  @override
  List<Object> get props => [message];
}
