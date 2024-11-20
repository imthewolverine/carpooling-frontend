import 'package:carpooling_frontend/models/request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'request_event.dart';
import 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RequestBloc() : super(RequestInitial());

  Stream<RequestState> mapEventToState(RequestEvent event) async* {
    if (event is FetchRequests) {
      yield RequestLoading();
      try {
        // Fetch requests from the backend
        await Future.delayed(const Duration(seconds: 2)); // Simulate API call
        final requests = [
          Request(
              driverFirstName: "John",
              driverLastName: "Doe",
              status: "Pending"),
          Request(
              driverFirstName: "Jane",
              driverLastName: "Smith",
              status: "Approved"),
        ];
        yield RequestLoaded(requests);
      } catch (e) {
        yield RequestError("Failed to load requests.");
      }
    }
  }
}
