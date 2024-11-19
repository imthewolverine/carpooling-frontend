import 'package:carpooling_frontend/models/route.dart';
import 'package:equatable/equatable.dart';

abstract class DriverHomeEvent extends Equatable {
  const DriverHomeEvent();
}

// Load Ads Event
class LoadAds extends DriverHomeEvent {
  @override
  List<Object> get props => [];
}

// Add New Ad Event
class AddNewAd extends DriverHomeEvent {
  final RouteModel newAd;

  const AddNewAd(this.newAd);

  @override
  List<Object> get props => [newAd];
}

// Search Ads Event
class SearchAds extends DriverHomeEvent {
  final String query;

  const SearchAds(this.query);

  @override
  List<Object> get props => [query];
}
