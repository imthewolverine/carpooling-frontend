import 'dart:convert';
import 'package:carpooling_frontend/screens/driverHome_screen/driverHome_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'driverHome_state.dart';
import '../../models/route.dart';

class DriverHomeBloc extends Bloc<DriverHomeEvent, DriverHomeState> {
  List<RouteModel> _ads = [];
  final String baseUrl =
      'https://backend-api-491759785783.asia-northeast1.run.app';

  DriverHomeBloc() : super(DriverHomeLoading()) {
    on<LoadAds>(_onLoadAds);
    on<AddNewAd>(_onAddNewAd);
    on<SearchAds>(_onSearchAds);
  }

  Future<void> _onLoadAds(LoadAds event, Emitter<DriverHomeState> emit) async {
    emit(DriverHomeLoading());
    try {
      final response = await http.get(Uri.parse('$baseUrl/ads'));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        // Parse 'ads' array into list of Ad objects
        _ads = (responseBody['ads'] as List)
            .map((adData) => RouteModel.fromMap(adData))
            .toList();

        emit(DriverHomeLoaded(ads: _ads));
      } else {
        emit(DriverHomeError('Failed to load ads: ${response.statusCode}'));
      }
    } catch (e) {
      emit(DriverHomeError('Error fetching ads: $e'));
    }
  }

  Future<void> _onAddNewAd(
      AddNewAd event, Emitter<DriverHomeState> emit) async {
    _ads.add(event.newAd);
    emit(DriverHomeLoaded(ads: _ads));
  }

  void _onSearchAds(SearchAds event, Emitter<DriverHomeState> emit) {
    final query = event.query.toLowerCase();
    final filteredAds = _ads.where((ad) {
      return ad.location.toLowerCase().contains(query) ||
          ad.location.toLowerCase().contains(query) ||
          ad.description.toLowerCase().contains(query);
    }).toList();

    emit(DriverHomeLoaded(ads: filteredAds, isSearchResult: true));
  }
}
