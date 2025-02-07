import 'package:equatable/equatable.dart';
import '../../models/route.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

// Load Ads Event
class LoadAds extends HomeEvent {
  @override
  List<Object> get props => [];
}

// Add New Ad Event
class AddNewAd extends HomeEvent {
  final RouteModel newAd;

  const AddNewAd(this.newAd);

  @override
  List<Object> get props => [newAd];
}

// Search Ads Event
class SearchAds extends HomeEvent {
  final String query;

  const SearchAds(this.query);

  @override
  List<Object> get props => [query];
}
