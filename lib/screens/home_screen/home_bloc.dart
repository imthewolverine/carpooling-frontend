import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'home_event.dart';
import 'home_state.dart';
import '../../models/ad.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<Ad> _ads = [];
  final String baseUrl =
      'https://backend-api-491759785783.asia-northeast1.run.app';

  HomeBloc() : super(HomeLoading()) {
    on<LoadAds>(_onLoadAds);
    on<AddNewAd>(_onAddNewAd);
    on<SearchAds>(_onSearchAds);
  }

  Future<void> _onLoadAds(LoadAds event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final response = await http.get(Uri.parse('$baseUrl/ads'));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        // Parse 'ads' array into list of Ad objects
        _ads = (responseBody['ads'] as List)
            .map((adData) => Ad.fromMap(adData))
            .toList();

        emit(HomeLoaded(ads: _ads));
      } else {
        emit(HomeError('Failed to load ads: ${response.statusCode}'));
      }
    } catch (e) {
      emit(HomeError('Error fetching ads: $e'));
    }
  }

  Future<void> _onAddNewAd(AddNewAd event, Emitter<HomeState> emit) async {
    _ads.add(event.newAd);
    emit(HomeLoaded(ads: _ads));
  }

  void _onSearchAds(SearchAds event, Emitter<HomeState> emit) {
    final query = event.query.toLowerCase();
    final filteredAds = _ads.where((ad) {
      return ad.school.toLowerCase().contains(query) ||
          ad.schoolAddress.toLowerCase().contains(query) ||
          ad.description.toLowerCase().contains(query);
    }).toList();

    emit(HomeLoaded(ads: filteredAds, isSearchResult: true));
  }
}
